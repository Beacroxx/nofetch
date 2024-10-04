program RandomString;

uses
  SysUtils,
  Classes;

const
  Strings: array[0..7] of string = (
    'probably a computer',
    'there''s probably some ram in there',
    'init should ideally be running',
    'yeah',
    'you should probably go outside',
    'i would be lead to believe that / is mounted',
    'hey, what''s this knob do?',
    'i use arch btw'
  );

var
  rng: Integer;
  rstring, version, rvers: string;
  idx: Integer;
  sl: TStringList;

begin
  Randomize;

  // Get a random string from the array
  rng := Random(Length(Strings));
  rstring := Strings[rng];

  // read /proc/version
  sl := TStringList.Create;
  sl.LoadFromFile('/proc/version');
  rvers := sl[0];

  // Free the string list
  sl.Free;

  // Extract the version string
  idx := Pos('(', rvers);
  if idx = 0 then
    idx := Length(rvers);
  version := Trim(Copy(rvers, 1, idx - 1));

  // Output
  WriteLn;
  WriteLn('> ', rstring);
  WriteLn('> ', version);
  WriteLn;
end.
