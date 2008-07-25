{
  @cvs($Date$)
  @author(Johannes Berg <johannes@sipsolutions.de>)
  a few stream utility functions
}
unit PasDoc_StreamUtils;

interface

uses
  Classes;
  
{$I pasdoc_versions.inc}  

function StreamReadLine(const AStream: TStream): string;

{ Write AString contents, then LineEnding to AStream }
procedure StreamWriteLine(const AStream: TStream; const AString: string);

{ Just write AString contents to AStream }
procedure StreamWriteString(const AStream: TStream; const AString: string);

implementation

uses
  PasDoc_Types, // for whitespace sets - move to Utils?
  PasDoc_Utils; // for LineEnding in Kylix/Delphi

function StreamReadLine(const AStream: TStream): string;
// totally junky implementation!!
var
  c: Char;
  l: Integer;
begin
  l := 0;
  SetLength(Result, 100);
  c := #0;
  //read up to and including the whole line ending (until #10)
  //while (AStream.Position < AStream.Size) and (c <> #13) and (c <> #10) do begin
  while (AStream.Position < AStream.Size) and (c <> #10) do begin
    AStream.Read(c, 1);
    Inc(l);
    if l > Length(Result) then SetLength(Result, Length(Result) + 100);
    Result[l] := c;
  end;
{$IFDEF old}
  if (c = #13) then begin
    AStream.Read(c, 1);
    if c <> #10 then begin
      AStream.Seek(-1, soFromCurrent);
    end;
  end;
  SetLength(Result, l);
{$ELSE}
  SetLength(Result, l);
  //replace the last char by the proper line ending?
  if c in WhiteSpaceNL then begin
  //last char at [l]
    if (l > 1) and (Result[l-1] = #13) then
      dec(l, 2) //cr+lf
    else  //lf only
      dec(l, 1);
    SetLength(Result, l);
    Result := Result + LineEnding;
  end;
{$ENDIF}
end;

procedure StreamWriteLine(const AStream: TStream; const AString: string);
var
 LineTerminator: string;
begin
  if length(AString) > 0 then begin
    AStream.WriteBuffer(AString[1], Length(AString));
  end;
  LineTerminator := LineEnding;
  AStream.Write(LineTerminator[1], Length(LineTerminator));
end;

procedure StreamWriteString(const AStream: TStream; const AString: string);
begin
  if length(AString) > 0 then begin
    AStream.WriteBuffer(AString[1], Length(AString));
  end;
end;

end.
