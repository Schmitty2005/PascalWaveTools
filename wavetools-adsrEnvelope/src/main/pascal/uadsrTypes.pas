{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}
unit uadsrTypes;

interface

///<Summary>Holds all the  settings need to make an ADSR envelope on a sample
///</Summary>
///<param name="attack"> length in milli-seconds of attack envelope</param>
///<param name="decay"> length in mill-seconds of decay envelope</param>
///<param name="sustain">level of sustain amplitude in percentage( 0.0 to 1.00 )</param>
///<param name="release">length in milli-seconds of release envelope</param>
type
  TadsrSettings = record
    attack: uint32;
    decay: uint32;  { #todo -oB : May need an additional parameter for decay slope! }
    sustainLevel: double; //
    Release: uint32;
  end;

implementation

end.
