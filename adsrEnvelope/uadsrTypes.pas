{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}
unit uadsrTypes;

interface

///<Summary>Holds all the  settings need to make an ADSR envelope on a sample
///</Summary>
///<param name="attack"> length in milli-seconds of attack envelope</param>
///<param name="decay"> length in mill-seconds of decay envelope</param>
///<param name="sustain">length in milli-seconds of sustain period</param>
///<param name="release">length in milli-seconds of release envelope</param>
type
  TadsrSettings = record
    attack: uint32;
    decay: uint32;  { #todo -oB : May need an additional parameter for decay slope! }
    sustain: uint32;
    Release: uint32;
  end;

implementation

end.
