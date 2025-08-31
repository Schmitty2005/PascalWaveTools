unit waveGen;
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  {Math,} wavCalcs;

type
  TwavePCM = array of int16;

  TWaveStyle = (wsSine, wsTri, wsSqr, wsSaw);

  TWaveStyleSpecs = record
    WaveStyle: TWaveStyle;
    aPCM: TwavePCM;
    FreqHertz: integer;
    Amplitude: int16;
    SampleRate: integer;
    LengthMilliSec: uint32;
    StartPhaseDeg: integer;
  end;

  TwaveGenStyle = function (aWaveSpec : TWaveStyleSpecs) : uInt32;

  TwaveGenStyleExt = function(var aPCM: TwavePCM; const aHertz: integer;
    const aAmp: int16; const aSampleRate: integer; const aMilliSecLength: uint32;
    const aStartPhaseAngle: integer): uint32;



function triangleWave(var aPCM: TwavePCM; const aHertz: integer;
  const aAmp: int16; const aSampleRate: integer; const aMilliSecLength: uint32;
  const aStartPhaseAngle: integer = 90): uint32;

implementation

{$IFDEF FPC}
uses Math;
{$ENDIF}

{$IFDEF DCC}
Uses system.Math;
{$ENDIF}
(*
  n = sample number
  p = period in samples
  n %p = triangle wave
*)


{ #todo -oB : Amplitude needs to change to 0 to 100 percent like other functions!  Currently uses Max of Int16 values.
 }


function triangleWave(var aPCM: TwavePCM; const aHertz: integer;
  const aAmp: int16; const aSampleRate: integer; const aMilliSecLength: uint32;
  const aStartPhaseAngle: integer = 90): uint32;
var
  phase, phaseStep, tau: double;
  numSamples: uint32;
  Count: uint32;
begin
  tau := 2 * PI;
  phase := DegToRad(aStartPhaseAngle);
  numSamples := trunc(aMilliSecLength / 1000 * aSampleRate);
  PhaseStep := 2 * PI * aHertz / aSampleRate;
  Count := 0;
  setLength(aPCM, numSamples);
  while Count < High(aPCM) do
  begin
    Phase := fmod(Phase, tau);

    if Phase < PI then
      aPCM[Count] := round(aAmp * (2 / PI * (Phase - PI / 2)))
    else
      aPCM[Count] := round(aAmp * (-2 / PI * (Phase - 3 * PI / 2)));

    Phase := Phase + PhaseStep;
    Inc(Count);
  end;
  Result := Count;
end;

   (*

   program TriangleWave;

{$mode objfpc}

uses
  SysUtils;

// Structure for the WAV file header
type
  TWaveHeader = packed record
    riffID: array[0..3] of Char;
    fileSize: dword;
    waveID: array[0..3] of Char;
    fmtID: array[0..3] of Char;
    fmtSize: dword;
    audioFormat: word;
    numChannels: word;
    sampleRate: dword;
    byteRate: dword;
    blockAlign: word;
    bitsPerSample: word;
    dataID: array[0..3] of Char;
    dataSize: dword;
  end;

const
  // Audio parameters
  SampleRate = 44100;
  BitDepth = 16;
  NumChannels = 1; // Mono
  Frequency = 440; // Hz
  Duration = 5; // seconds

var
  WaveFile: file;
  Header: TWaveHeader;
  Samples: array of smallint;
  NumSamples, i: longint;
  Amplitude: longint;
  Phase, PhaseStep: double;
  Filename: string;

begin
  Filename := 'triangle_wave.wav';
  NumSamples := SampleRate * Duration;
  SetLength(Samples, NumSamples);

  // Maximum amplitude for 16-bit signed integer
  Amplitude := high(smallint);

  // Phase step per sample for 440 Hz
  PhaseStep := 2 * PI * Frequency / SampleRate;
  Phase := 0;

  // Generate the triangle wave samples
  for i := 0 to NumSamples - 1 do
  begin
    // Create a sawtooth wave
    // Use `fmod` to keep phase in [0, 2*PI]
    Phase := fmod(Phase, 2 * PI);

    // Convert sawtooth to triangle wave
    // First, map phase to [-1, 1] range
    if Phase < PI then
      Samples[i] := round(Amplitude * (2 / PI * (Phase - PI / 2)))
    else
      Samples[i] := round(Amplitude * (-2 / PI * (Phase - 3 * PI / 2)));

    // Advance phase
    Phase := Phase + PhaseStep;
  end;

  // Create and write the WAV file
  AssignFile(WaveFile, Filename);
  Rewrite(WaveFile, 1); // Open in binary mode

  // Populate the WAV header
  Move('RIFF', Header.riffID, 4);
  Header.fileSize := SizeOf(TWaveHeader) - 8 + NumSamples * SizeOf(smallint);
  Move('WAVE', Header.waveID, 4);
  Move('fmt ', Header.fmtID, 4);
  Header.fmtSize := 16;
  Header.audioFormat := 1; // PCM
  Header.numChannels := NumChannels;
  Header.sampleRate := SampleRate;
  Header.byteRate := SampleRate * NumChannels * (BitDepth div 8);
  Header.blockAlign := NumChannels * (BitDepth div 8);
  Header.bitsPerSample := BitDepth;
  Move('data', Header.dataID, 4);
  Header.dataSize := NumSamples * SizeOf(smallint);

  // Write header to file
  BlockWrite(WaveFile, Header, SizeOf(Header));

  // Write sample data to file
  BlockWrite(WaveFile, Samples[0], NumSamples * SizeOf(smallint));

  // Close file
  CloseFile(WaveFile);

  writeln('Triangle wave file "', Filename, '" created successfully.');
end.
   *)




end.
