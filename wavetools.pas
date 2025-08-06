unit WaveTools;
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{
  https://docs.fileformat.com/audio/wav/

  https://en.wikipedia.org/wiki/WAV

  [Master RIFF chunk]
  FileTypeBlocID  (4 bytes) : Identifier « RIFF »  (0x52, 0x49, 0x46, 0x46)
  FileSize        (4 bytes) : Overall file size minus 8 bytes
  FileFormatID    (4 bytes) : Format = « WAVE »  (0x57, 0x41, 0x56, 0x45)

  [Chunk describing the data format]
  FormatBlocID    (4 bytes) : Identifier « fmt␣ »  (0x66, 0x6D, 0x74, 0x20)
  BlocSize        (4 bytes) : Chunk size minus 8 bytes, which is 16 bytes here  (0x10)
  AudioFormat     (2 bytes) : Audio format (1: PCM integer, 3: IEEE 754 float)
  NbrChannels     (2 bytes) : Number of channels
  Frequency       (4 bytes) : Sample rate (in hertz)
  BytePerSec      (4 bytes) : Number of bytes to read per second (Frequency * BytePerBloc).
  BytePerBloc     (2 bytes) : Number of bytes per block (NbrChannels * BitsPerSample / 8).
  BitsPerSample   (2 bytes) : Number of bits per sample

  [Chunk containing the sampled data]
  DataBlocID      (4 bytes) : Identifier « data »  (0x64, 0x61, 0x74, 0x61)
  DataSize        (4 bytes) : SampledData size
  [[SampledData]]
}
interface

uses
  Classes, SysUtils;

type
  EWaveToolsExpception = class(Exception);

  TBitDepth = (BitDepth8 = 8, BitDepth16 = 16, BitDepth24 = 24,
    BitDepth32 = 32);
  TChannels = (Mono = 1, Stereo = 2);

  TheaderText = array [0 .. 3] of byte;

  { UInt32 =  4 bytes }
  { Uint16 = 2 Bytes }
  { Uint8 = 1 Byte }

  (*
    TWaveHeader = packed record
    RIFF: Array [0 .. 3] of char; // always 'RIFF'
    FileSize: uint32; // size of overall file -8 bytes
    WAVE: array [0 .. 3] of char; // always 'WAVE'
    fmt: array [0 .. 3] of char; // always  'fmt '
    { #todo -oB : Refactor DataLenght. Too ambigous with SizeOfData }
    BlockSize: uint32; // usually always 16 , length of data above
    TypeFormat: uint16; // 1 = pcm
    NumChannles: uint16; // number of channels
    SampleRate: uint32; // sample Rate;
    bytesPerSec: uint32;
    bytesPerBlock: uint16; // (Sample Rate * BitsPerSample * Channels) / 8
    BitsPerSample: uint16; // usually 16-bit
    Data: array [0 .. 3] of char; // 'data'
    sizeOfData: uint32; // size of the data section
    end;
  *)
  // ===========================================

  TWaveHeader = packed record
    RIFF: TheaderText; // always 'RIFF'
    FileSize: uint32; // size of overall file -8 bytes
    WAVE: TheaderText; // always 'WAVE'
    fmt: TheaderText; // always  'fmt '
    BlockSize: uint32; // usually always 16 , length of data above
    TypeFormat: uint16; // 1 = pcm
    NumChannles: uint16; // number of channels
    SampleRate: uint32; // sample Rate;
    bytesPerSec: uint32;
    bytesPerBlock: uint16; // (Sample Rate * BitsPerSample * Channels) / 8
    BitsPerSample: uint16; // usually 16-bit
    Data: TheaderText; // 'data'
    sizeOfData: uint32; // size of the data section
  end;

  IReadWaveHeader = interface
    ['{A54469CF-1B77-42D1-B6E5-338FE3FD74EC}']
    procedure ReadWaveHeader(aWaveFile: string; out aWaveHeader: TWaveHeader);
  end;

  IAddWavHeaderToPCM = interface
    ['{83CCEA66-A87A-43AB-AFD2-7FEF0022776C}']
    { #todo -oB : Add more input for proper header creation }
    procedure AddWaveHeaderToPCM(aSampleRate: uint16; channels: TChannels;
      bitDepth: TBitDepth); // unfinished
  end;

  IWaveHeaderMono16Bit8000 = interface
    ['{D75041AC-F945-446A-AF91-648CD1A6E041}']
    procedure WaveHeaderMono16bit8000(aPCMData: TMemoryStream);
  end;

  IWaveHeaderMono16Bit = interface
    ['{DE5F6DD1-31D3-435A-8AC4-B7193E75445B}']
    procedure SampleRate8000(aPCMData: TMemoryStream);
    procedure SampleRate22100(aPCMData: TMemoryStream);
    procedure SampleRate44100(aPCMData: TMemoryStream);
    procedure SampleRate48000(aPCMData: TMemoryStream);
  end;

  { TWaveHeaderReader }

  TWaveHeaderReader = class(TInterfacedObject, IReadWaveHeader)
  private
    fWaveHeader: TWaveHeader;
    fFileName: string;
    fMemStream: TMemoryStream;
  public
    constructor Create;
    procedure ReadWaveHeader(aWaveFile: string; out aWaveHeader: TWaveHeader);

  end;

  { TWaveHeaderCreator }

  TWaveHeaderCreator = class(TInterfacedObject, IWaveHeaderMono16Bit8000)
    // , IAddWavHeaderToPCM)
  private
    fNewStream: TMemoryStream;
    fWaveHeader: TWaveHeader;
  public
    constructor Create();
    destructor Destroy();
    // procedure AddWaveHeaderToPCM(aSampleRate: Dword; channels: TChannels;
    // bitDepth: TBitDepth);
    procedure WaveHeaderMono16bit8000(aPCMData: TMemoryStream);
  end;

implementation

procedure InitializeWaveHeader(var aHeader: TWaveHeader);
const
  cRIFF: TheaderText = (82, 73, 70, 70); // ('R', 'I', 'F', 'F');
  cFmt: TheaderText = (102, 109, 116, 32);
  cData: TheaderText =(100,97,116,97);// (68, 65, 84, 65);
  cWAVE: TheaderText = (87, 65, 86, 69);

begin
  aHeader.RIFF := cRIFF;
  aHeader.fmt := cFmt;
  aHeader.WAVE := cWAVE;
  aHeader.Data := cData;
  aHeader.TypeFormat := 1; // Set format to PCM
  aHeader.BlockSize := 16; // default
end;

{ TWaveHeaderReader }

constructor TWaveHeaderReader.Create;
begin
  fMemStream := TMemoryStream.Create;
end;

procedure TWaveHeaderReader.ReadWaveHeader(aWaveFile: string;
  out aWaveHeader: TWaveHeader);
var
  headerCount: integer;
begin
  try
    fMemStream.LoadFromFile(aWaveFile);
  finally
    headerCount := sizeOf(aWaveHeader);
    headerCount := fMemStream.Read(aWaveHeader, 44);
  end;
end;

{ TWaveHeaderCreator }

constructor TWaveHeaderCreator.Create();
begin
  inherited;
  fNewStream := TMemoryStream.Create;
  InitializeWaveHeader(fWaveHeader);
end;

destructor TWaveHeaderCreator.Destroy();
begin
  fNewStream.Free;
  inherited;
end;

{$IFDEF FPC}
{$INLINE+}
{$ENDIF}

function bytePerBlock(aNumChannels: longint; aBitsPerSample: longint)
  : double; inline;
begin
  Result := aNumChannels * aBitsPerSample / 8;
end;

function bytesPerSec(aSampleFreq: double; aBytesPerBlock: double)
  : double; inline;
begin
  Result := aSampleFreq * aBytesPerBlock;
end;

{ ============================================================================== }
{
  procedure TWaveHeaderCreator.AddWaveHeaderToPCM(aSampleRate: Dword;
  channels: TChannels; bitDepth: TBitDepth);
  var
  WaveHeader: TWaveHeader;
  begin
  InitializeWaveHeader(WaveHeader);
  end;
}

procedure TWaveHeaderCreator.WaveHeaderMono16bit8000(aPCMData: TMemoryStream);
type
  PWaveHeader = ^TWaveHeader;
var
  WaveHeaderPointer: PWaveHeader;
  aBytesPerBlock: double;
  tempStream: TMemoryStream;
  HeaderSize: integer;
begin
  tempStream := TMemoryStream.Create;
  fWaveHeader.FileSize := aPCMData.Size + 36;
  fWaveHeader.SampleRate := 8000;
  fWaveHeader.BitsPerSample := 16;
  fWaveHeader.bytesPerBlock := SizeOf(Int16); {For MONO}

  fWaveHeader.NumChannles := 1;
  fWaveHeader.sizeOfData := aPCMData.Size;

  aBytesPerBlock := bytePerBlock(fWaveHeader.NumChannles, (sizeOf(Int16)*8));

  fWaveHeader.bytesPerSec := Trunc(bytesPerSec(fWaveHeader.SampleRate,
    aBytesPerBlock));

  WaveHeaderPointer := @fWaveHeader;
  HeaderSize := sizeOf(fWaveHeader);

  tempStream.Write(WaveHeaderPointer^, HeaderSize);
  tempStream.Write(aPCMData.Memory^, aPCMData.Size);
  // TEMP Line for TESTING ONLY
  //tempStream.SaveToFile('WaveHeaderTest.wav');

  tempStream.Free;

end;

{.$DEFINE DEBUG_INTERNAL}
{$IFDEF DEBUG_INTERNAL}

var
  wh: TWaveHeaderCreator;
  iwh: IWaveHeaderMono16Bit8000;
  ms: TMemoryStream;
  wr: IReadWaveHeader;
  whWorking, whBroken: TWaveHeader;
  whead: TWaveHeader;
{$ENDIF}
begin

{$IFDEF DEBUG_INTERNAL}
  wr := TWaveHeaderReader.Create;
  ms := TMemoryStream.Create;
  ms.LoadFromFile('CWOutput.pcm');
  wh := TWaveHeaderCreator.Create;
  iwh := TWaveHeaderCreator.Create;
  iwh.WaveHeaderMono16bit8000(ms);

  wr.ReadWaveHeader('CWOutput.wav', whWorking);
  wr := TWaveHeaderReader.Create; { Delphi needs this to reset wr! }
  wr.ReadWaveHeader('WaveHeaderTest.wav', whBroken);
  writeln(sizeOf(whead));
  //readln;
  wh.Free;
  ms.Free;
{$ENDIF}

end.

