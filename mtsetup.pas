unit mtSetup;

{$Mode delphi}
interface

type
  ///<summary> Trange is a record type that holds the first sample and last sample position.  
  ///</summary>
  Trange = record
    firstSample: uint64;
    lastSample: uint64;
  end;

  TrangeP = record
    firstPointer: Pointer;
    lastPointer: Pointer;
  end;

  ///<summary>  Tblock is a dynamic array of the Trange type
  ///</summary>
  Tblocks = array of Trange;

  TblocksP = array of TrangeP;

///<summary> Outputs Tblocks (array of Trange) the size of the numCores (number of CPU cores)
///  This is used to divide and conquer a wave sample across multiple CPU's / Threads.  The Wave length
/// is evenly divided into a number of blocks based on the number of CPU cores/threads that are requested
///</summary>
function calcBlockRanges(const numSamples: uint64; const numCores: byte): Tblocks;

function calcBlockRangesP(const startPointer: Pointer; const numSamples: uint64;
  const numCores: byte): TblocksP;

implementation

function calcBlockRanges(const numSamples: uint64; const numCores: byte): Tblocks;
var
  x, s: uint64;
begin
  x := 1;
  Result := nil;
  setlength(Result, numCores);

  s := trunc(numSamples / numCores);

  Result[0].firstSample := 0;
  Result[0].lastSample := s;
  Result[numCores].firstSample := numSamples - s;
  Result[numCores].lastSample := numSamples;

  repeat
    Result[x].firstSample := (x * s) + 1;
    Result[x].lastSample := (Result[x].firstSample + s) - 1;
    Inc(x);
  until x > numCores - 1;
end;

function calcBlockRangesP(const startPointer: Pointer; const numSamples: uint64;
  const numCores: byte): TblocksP;
var
  x, s: uint64;
begin
  {$POINTERMATH ON}
  x := 1;
  Result := nil;
  setlength(Result, numCores);

  s := trunc(numSamples / numCores);

  Result[0].firstPointer := startPointer;
  Result[0].lastPointer := startPointer + s;

  Result[numCores].firstPointer := startPointer + numSamples - s;
  Result[numCores].lastPointer := startPointer + numSamples;

  repeat
    Result[x].firstPointer := (x * s) + 1 + startPointer;
    Result[x].lastPointer := (Result[x].firstPointer + s) - 1;
    Inc(x);
  until x > numCores - 1;
  {$POINTERMATH OFF}
end;

end.
{example usage}{
var
  x :uInt64;
  z : Tblocks;
const
  cpu = 4;
Begin
  z:= calcBlockRanges(192000, cpu);
  x:=0;
  repeat
    writeln ( x , ':', z[x].firstSample, ' ' , 
    z[x].lastSample);
    inc(x);
  until x = cpu;
  }  
