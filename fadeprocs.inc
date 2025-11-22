  procedure fadeIn<T>(var pcm: array of T; lengthms: uint64; channels: uint8 = 1;
    sampleRate: uint32 = 48000);
  var
    durationSamples: uint64;
    sampleNum: uint64;
    weight: double;
  begin
    durationSamples := round(lengthMs / 1000 * samplerate) * Channels;
    sampleNum := 0;
    //if durationSamples > high(pcm) then durationSamples:= trunc(High(pcm)/2);//In AND Out fade
    if durationSamples > high(pcm) then
      durationSamples := trunc(High(pcm));//In OR Out fade
    repeat
      //  float weight = 0.5 * (1 - cos(M_PI * s / (numFadeSamples - 1)));
      weight := (0.5 * (1 - cos((Pi * sampleNum / (durationSamples - 1)))));
      pcm[sampleNum] := Trunc(pcm[sampleNum] * weight);
      //fade in
      //pcm[high(pcm) - sampleNum] := Trunc(pcm[high(pcm) - sampleNum] * weight)   ;  //fade out
      Inc(sampleNum);
    until sampleNum > durationSamples;
  end;


  procedure fadeOut<T>(var pcm: array of T; lengthms: uint64;
    channels: uint8 = 1; sampleRate: uint32 = 48000);
  var
    durationSamples: uint64;
    sampleNum: uint64;
    weight: double;
  begin
    durationSamples := round(lengthMs / 1000 * samplerate) * Channels;
    sampleNum := 0;
    //if durationSamples > high(pcm) then durationSamples:= trunc(High(pcm)/2);//In AND Out fade
    if durationSamples > high(pcm) then
      durationSamples := trunc(High(pcm));//In OR Out fade
    repeat
      //  float weight = 0.5 * (1 - cos(M_PI * s / (numFadeSamples - 1)));
      weight := (0.5 * (1 - cos((Pi * sampleNum / (durationSamples - 1)))));
      //pcm[sampleNum] := Trunc(pcm[sampleNum] * weight);                          //fade in
      pcm[high(pcm) - sampleNum] := Trunc(pcm[high(pcm) - sampleNum] * weight);
      //fade out
      Inc(sampleNum);
    until sampleNum > durationSamples;
  end;

  { #todo -oB -cTesting : Procedure needs testing! }
{ #todo 1 -oB -cfeature : Break out into FadeIn FadeOut procedures as well as
        interface procedures for uInt16 and uInt8 types}
  procedure fadeInOut<T>(var pcm: array of T; lengthms: uint64;
    channels: uint8 = 1; sampleRate: uint32 = 48000);
  var
    durationSamples: uint64;
    sampleNum: uint64;
    weight: double;
  begin
    durationSamples := round(lengthMs / 1000 * samplerate) * Channels;
    sampleNum := 0;
    if durationSamples > high(pcm) then
      durationSamples := trunc(High(pcm) / 2);//In AND Out fade
    //if durationSamples > high(pcm) then durationSamples:= trunc(High(pcm));//In OR Out fade
    repeat
      //  float weight = 0.5 * (1 - cos(M_PI * s / (numFadeSamples - 1)));
      weight := (0.5 * (1 - cos((Pi * sampleNum / (durationSamples - 1)))));
      pcm[sampleNum] := Trunc(pcm[sampleNum] * weight);
      //fade in
      pcm[high(pcm) - sampleNum] := Trunc(pcm[high(pcm) - sampleNum] * weight);
      //fade out
      Inc(sampleNum);
    until sampleNum > durationSamples;
  end;