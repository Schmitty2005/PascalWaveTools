{$MODE DELPHI}
Unit uadsrProcedures;

Interface

Uses uadsrTypes;

Procedure adsrEnvelope (aPCM : Array Of Int16; aAdsrSettings : TadsrSettings);

//setSampleRate must be called first! 
procedure setSampleRate(aSampleRate: uInt64);

Implementation

Var 
  env : TadsrSettings;
  sr : uInt64;
  x,c : uInt64;

procedure setSampleRate(aSampleRate: uInt64);
begin
  sr:=aSampleRate;
end;

Procedure attackEnvelope ( aPCM : Array Of Int16; aAttack : uInt64);
Begin
End;

Procedure decayEnvelope ( aPCM : Array Of Int16; aAttack : uInt64);
Begin
End;

Procedure sustainEnvelope ( aPCM : Array Of Int16; aAttack : uInt64);
Begin
End;

Procedure releaseEnvelope ( aPCM : Array Of Int16; aAttack : uInt64);
Begin
End;

Procedure adsrEnvelope (aPCM : Array Of Int16; aAdsrSettings : TadsrSettings);
Begin
  env := aAdsrsettings;
  attackEnvelope(aPCM,env.Attack);
  decayEnvelope(aPCM, env.Decay);
  sustainEnvelope(aPCM, env.Sustain);
  releaseEnvelope(aPCM, env.Release);
End;

End.
