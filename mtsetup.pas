unit mtSetup;

{$Mode delphi}
interface

type
  ///<summary> Trange is a record type that holds the first sample and last sample position.  
  ///</summary>
  Trange = record
    firstSample: uInt64;
    lastSample: uInt64;
  end;

  ///<summary>  Tblock is a dynamic array of the Trange type
  ///</summary>
  Tblocks = array of Trange;

///<summary> Outputs Tblocks (array of Trange) the size of the numCores (number of CPU cores)
///  This is used to divide and conquer a wave sample across multiple CPU's / Threads.  The Wave length
/// is evenly divided into a number of blocks based on the number of CPU cores/threads that are requested
///</summary>
function calcBlockRanges(const numSamples: uInt64; const numCores: byte): Tblocks;

implementation

function calcBlockRanges(const numSamples: uInt64; const numCores: byte): Tblocks;
var
  x, s: uInt64;
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