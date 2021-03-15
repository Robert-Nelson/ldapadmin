  {      LDAPAdmin - Schema.pas
  *      Copyright (C) 2005 Alexander Sokoloff
  *
  *      Author: Alexander Sokoloff
  *
  *
  * This file is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This file is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  }

unit Schema;

interface
uses Classes, LDAPClasses, WinLDAP, SysUtils, Contnrs;

type

  TAttributeUsage=(au_userApplications, au_directoryOperation, au_distributedOperation, au_dSAOperation);

  TLDAPSchemaAttribute=class
  private
    FCollective:          boolean;
    FNoUserModification:  boolean;
    FSingleValue:         boolean;
    FObsolete:            boolean;
    FLength:              integer;
    FSyntax:              string;
    FName:                TStringList;
    FDescription:         string;
    FSuperior:            string;
    FOid:                 string;
    FUsage:               TAttributeUsage;
    FOrdering:            string;
    FEquality:            string;
    FSubstr:              string;
  public
    constructor           Create(const LDAPString: string); reintroduce;
    destructor            Destroy; override;
    property              Oid: string read FOid;
    property              Name: TStringList read FName;
    property              Description: string read FDescription;
    property              Obsolete: boolean read FObsolete;
    property              Superior: string read FSuperior;
    property              Equality: string read FEquality;
    property              Ordering: string read FOrdering;
    property              Substr: string read FSubstr;
    property              Syntax: string read FSyntax;
    property              SingleValue: boolean read FSingleValue;
    property              Collective: boolean read FCollective;
    property              NoUserModification: boolean read FNoUserModification;
    property              Usage: TAttributeUsage read FUsage;
    property              Length: integer read FLength;
  end;

  TLDAPClassKind=(lck_Abstract, lck_Structural, lck_Auxiliary);

  TLDAPSchemaClass=class
  private
    FObsolete:            boolean;
    FDescription:         string;
    FOid:                 string;
    FName:                TStringList;
    FKind:                TLDAPClassKind;
    FSup:                 string;
    FMust:                TStringList;
    FMay:                 TStringList;
  public                  
    constructor           Create(const LDAPString: string); reintroduce;
    destructor            Destroy; override;
    property              Name: TStringList read FName;
    property              Description: string read FDescription;
    property              Obsolete: boolean read FObsolete;
    property              Sup: string read FSup;
    property              Kind: TLDAPClassKind read FKind;
    property              Must: TStringList read FMust;
    property              May: TStringList read FMay;
    property              Oid: string read FOid;
  end;

  TLDAPSchemaSynax=class
  private
    FOid:                 string;
    FDescription:         string;
  public
    constructor           Create(const LDAPString: string); reintroduce;
    property              Oid: string read FOid;
    property              Description: string read FDescription;
  end;

  TLDAPSchemaAttributes=class(TObjectList)
  private
    function              GetItems(Index: Integer): TLDAPSchemaAttribute;
  protected
    procedure             Load(const Attribute: TLdapAttribute);
  public
    property              Items[Index: integer]: TLDAPSchemaAttribute read GetItems; default;
  end;

  TLDAPSchemaClasses=class(TObjectList)
  private
    function              GetItems(Index: Integer): TLDAPSchemaClass;
  protected
    procedure             Load(const Attribute: TLdapAttribute);
  public
    property              Items[Index: integer]: TLDAPSchemaClass read GetItems; default;
  end;

  TLDAPSchemaSyntaxes=class(TObjectList)
  private
    function              GetItems(Index: Integer): TLDAPSchemaSynax;
  protected
    procedure             Load(const Attribute: TLdapAttribute);
  public
    property              Items[Index: integer]: TLDAPSchemaSynax read GetItems; default;
  end;

  TLDAPSchemaMatchingRule=class
  private
    FObsolete:            boolean;
    FDescription:         string;
    FOid:                 string;
    FName:                string;
    FSyntax:              string;
  public
    constructor           Create(const LDAPString: string); reintroduce;
    property              Oid: string read FOid;
    property              Name: string read FName;
    property              Description: string read FDescription;
    property              Obsolete: boolean read FObsolete;
    property              Syntax: string read FSyntax;
  end;

  TLDAPSchemaMatchingRules=class(TObjectList)
  private
    function              GetItems(Index: Integer): TLDAPSchemaMatchingRule;
  protected
    procedure             Load(const Attribute: TLdapAttribute);
  public
    property              Items[Index: integer]: TLDAPSchemaMatchingRule read GetItems; default;
  end;

  TLDAPSchemaMatchingRuleUse=class
  private
    FObsolete:            boolean;
    FDescription:         string;
    FOid:                 string;
    FName:                string;
    FApplies:             TStringList;
  public
    constructor           Create(const LDAPString: string); reintroduce;
    destructor            Destroy; override;
    property              Oid: string read FOid;
    property              Name: string read FName;
    property              Description: string read FDescription;
    property              Obsolete: boolean read FObsolete;
    property              Applies: TStringList read FApplies;
  end;

  TLDAPSchemaMatchingRuleUses=class(TObjectList)
  private
    function              GetItems(Index: Integer): TLDAPSchemaMatchingRuleUse;
  protected
    procedure             Load(const Attribute: TLdapAttribute);
  public
    property              Items[Index: integer]: TLDAPSchemaMatchingRuleUse read GetItems; default;
  end;

  TLDAPSchema=class
  private
    FSession:             TLDAPSession;
    FAttributes:          TLDAPSchemaAttributes;
    FObjectClasses:       TLDAPSchemaClasses;
    FSyntaxes:            TLDAPSchemaSyntaxes;
    FMatchingRules:       TLDAPSchemaMatchingRules;
    FMatchingRuleUses:    TLDAPSchemaMatchingRuleUses;
    FLoaded:              boolean;
    procedure             Read;
  public
    constructor           Create(const ASession: TLDAPSEssion); reintroduce;
    destructor            Destroy; override;
    procedure             Clear;
    property              Session: TLDAPSession read FSession;
    property              OBjectClasses: TLDAPSchemaClasses read FObjectClasses;
    property              Attributes: TLDAPSchemaAttributes read FAttributes;
    property              Syntaxes: TLDAPSchemaSyntaxes read FSyntaxes;
    property              MatchingRules: TLDAPSchemaMatchingRules read FMatchingRules;
    property              MatchingRuleUses: TLDAPSchemaMatchingRuleUses read FMatchingRuleUses;
    property              Loaded: boolean read FLoaded;
  end;


implementation
uses TypInfo;

{ Procedures }

function PosChar(const Pattern: char; S: string; Offset: cardinal=1): integer;
var
  i: integer;
begin
  for i:=Offset to length(S) do
    if S[i]=Pattern then begin
      result:=i;
      exit;
    end;
  result:=0;
end;

function GetOid(const S: string): string;
var
  n: integer;
begin
  n:=PosChar(' ',S,3);
  result:=copy(S,3,n-3);
end;

function GetString(const S, Name: string): string;
var
  n1,n2: integer;
  EndChar: char;
begin
  result:='';
  n1:=Pos(' '+name+' ',S);
  if n1<1 then exit;

  inc(n1,length(name)+2);
  case S[n1] of
    '(':  begin
            EndChar:=')';
            inc(n1);
          end;
    '''': begin
            EndChar:='''';
            inc(n1);
          end;
    else  EndChar:=' ';
  end;

  n2:=PosChar(EndChar,S,n1);

  result:=trim(copy(S,n1,n2-n1));
  if length(result)>0 then begin
    if result[1]='''' then delete(result,1,1);
    if result[length(result)]='''' then delete(result,length(result),1);
    result:=StringReplace(result,''' ''',',',[rfReplaceAll]);
    result:=StringReplace(result,' $ '  ,',',[rfReplaceAll]);
  end;
end;

function GetBoolean(const S, Name: string): boolean;
begin
  result:=Pos(' '+name+' ',S)>0;
end;

{ TLDAPSchema }

constructor TLDAPSchema.Create(const ASession: TLDAPSEssion);
begin
  inherited Create;
  FSession:=ASession;
  FAttributes:=TLDAPSchemaAttributes.Create;
  FObjectClasses:=TLDAPSchemaClasses.Create;
  FSyntaxes:=TLDAPSchemaSyntaxes.Create;
  FMatchingRules:=TLDAPSchemaMatchingRules.Create;
  FMatchingRuleUses:=TLDAPSchemaMatchingRuleUses.Create;
  Read;
end;

destructor TLDAPSchema.Destroy;
begin
  FAttributes.Free;
  FObjectClasses.Free;
  FSyntaxes.Free;
  FMatchingRules.Free;
  FMatchingRuleUses.Free;
  inherited;
end;

procedure TLDAPSchema.Clear;
begin
  FSyntaxes.Clear;
  FAttributes.Clear;
  FObjectClasses.Clear;
  FMatchingRules.Clear;
  FMatchingRuleUses.Clear;
end;

procedure TLDAPSchema.Read;
var
  SubschemaSubentry: string;
  SearchResult: TLdapEntryList;
begin
  FLoaded:=false;
  Clear;

  if FSession=nil then exit;
  SearchResult:=TLdapEntryList.Create;
  try
    // Search path to schema ///////////////////////////////////////////////////
    FSession.Search('objectclass=*','',LDAP_SCOPE_BASE,['subschemaSubentry'],false,SearchResult);
    SubschemaSubentry:=SearchResult[0].AttributesByName['subschemaSubentry'].AsString;
    if SubschemaSubentry='' then raise Exception.Create('Can''t find SubschemaSubentry');


    // Get schema values ///////////////////////////////////////////////////////
    SearchResult.Clear;
    FSession.Search('(objectClass=*)', SubschemaSubentry, LDAP_SCOPE_BASE,
                    ['ldapSyntaxes', 'attributeTypes', 'objectclasses', 'matchingRules', 'matchingRuleUse'],
                    false, SearchResult);

    if SearchResult.Count>0 then begin
      with SearchResult.Items[0] do begin
        FSyntaxes.Load(AttributesByName['ldapSyntaxes']);
        FAttributes.Load(AttributesByName['attributeTypes']);
        FObjectClasses.Load(AttributesByName['objectclasses']);
        FMatchingRules.Load(AttributesByName['matchingRules']);
        FMatchingRuleUses.Load(AttributesByName['matchingRuleUse']);
      end;
    end;
    FLoaded:=true;
  except
    //
  end;
    SearchResult.Free;
end;

{ TLDAPSchemaClass }

constructor TLDAPSchemaClass.Create(const LDAPString: string);
begin
  inherited Create;
  FOid:=GetOid(LDAPString);
  FMay:=TStringList.Create;
  FMust:=TStringList.Create;
  FName:=TStringList.Create;
  FName.CommaText:=GetString(LDAPString,'NAME');
  FDescription:=GetString(LDAPString,'DESC');
  FObsolete:=GetBoolean(LDAPString,'OBSOLETE');

  if GetBoolean(LDAPString,'ABSTRACT') then FKind:=lck_Abstract else
  if GetBoolean(LDAPString,'STRUCTURAL') then FKind:=lck_Structural else
  FKind:=lck_Auxiliary;
  FSup:=GetString(LDAPString,'SUP');
  Must.CommaText:=GetString(LDAPString,'MUST');
  May.CommaText:=GetString(LDAPString,'MAY');
end;

destructor TLDAPSchemaClass.Destroy;
begin
  FMay.Free;
  FMust.Free;
  inherited;
end;

{ TLDAPSchemaAttribute }

constructor TLDAPSchemaAttribute.Create(const LDAPString: string);
var
  n: integer;
  s: string;
begin
  inherited Create;
  FOid:=GetOid(LDAPString);
  FName:=TStringList.Create;
  FName.CommaText:=GetString(LDAPString,'NAME');
  FDescription:=GetString(LDAPString,'DESC');
  FObsolete:=GetBoolean(LDAPString,'OBSOLETE');
  FSuperior:=GetString(LDAPString,'SUP');
  FCollective:=GetBoolean(LDAPString,'COLLECTIVE');
  FNoUserModification:=GetBoolean(LDAPString,'NO-USER-MODIFICATION');
  FSingleValue:=GetBoolean(LDAPString,'SINGLE-VALUE');
  FSyntax:=GetString(LDAPString,'SYNTAX');
  n:=pos('{',Fsyntax);
  if n>0 then begin
    FLength:=StrToIntDef(copy(FSyntax,n+1,system.length(FSyntax)-n-1),0);
    setlength(FSyntax,n-1);
  end else FLength:=0;

  s:=GetString(LDAPString,'USAGE');
  if s='directoryOperation'   then FUsage:=au_directoryOperation   else
  if s='distributedOperation' then FUsage:=au_distributedOperation else
  if s='dSAOperation'         then FUsage:=au_dSAOperation
  else FUsage:=au_userApplications;

  FOrdering:=GetString(LDAPString,'ORDERING');
  FEquality:=GetString(LDAPString,'EQUALITY');
  FSubstr:=GetString(LDAPString,'SUBSTR');
end;

destructor TLDAPSchemaAttribute.Destroy;
begin
  FName.Free;
end;

{ TLDAPSchemaClasses }

function TLDAPSchemaClasses.GetItems(Index: Integer): TLDAPSchemaClass;
begin
  result:= TLDAPSchemaClass(inherited GetItem(Index));
end;

procedure TLDAPSchemaClasses.Load(const Attribute: TLdapAttribute);
var
  i: integer;
begin
  for i:=0 to Attribute.ValueCount-1 do
    Add(TLDAPSchemaClass.Create(Attribute.Values[i].AsString));
end;

{ TLDAPSchemaAttributies }

function TLDAPSchemaAttributes.GetItems(Index: Integer): TLDAPSchemaAttribute;
begin
  result:= TLDAPSchemaAttribute(inherited GetItem(Index));
end;

procedure TLDAPSchemaAttributes.Load(const Attribute: TLdapAttribute);
var
  i: integer;
begin
  for i:=0 to Attribute.ValueCount-1 do
    Add(TLDAPSchemaAttribute.Create(Attribute.Values[i].AsString));
end;

{ TLDAPSchemaSynax }

constructor TLDAPSchemaSynax.Create(const LDAPString: string);
begin
  inherited Create;
  FOid:=GetOid(LDAPString);
  FDescription:=GetString(LDAPString,'DESC');
end;

{ TLDAPSchemaSyntaxes }

function TLDAPSchemaSyntaxes.GetItems(Index: Integer): TLDAPSchemaSynax;
begin
  result:= TLDAPSchemaSynax(inherited GetItem(Index));
end;

procedure TLDAPSchemaSyntaxes.Load(const Attribute: TLdapAttribute);
var
  i: integer;
begin
  for i:=0 to Attribute.ValueCount-1 do
    Add(TLDAPSchemaSynax.Create(Attribute.Values[i].AsString));
end;

{ TLDAPSchemaMatchingRules }

function TLDAPSchemaMatchingRules.GetItems(Index: Integer): TLDAPSchemaMatchingRule;
begin
  result:= TLDAPSchemaMatchingRule(inherited GetItem(Index));
end;

procedure TLDAPSchemaMatchingRules.Load(const Attribute: TLdapAttribute);
var
  i: integer;
begin
  for i:=0 to Attribute.ValueCount-1 do
    Add(TLDAPSchemaMatchingRule.Create(Attribute.Values[i].AsString));
end;

{ TLDAPSchemaMatchingRule }

constructor TLDAPSchemaMatchingRule.Create(const LDAPString: string);
begin
  FOid:=GetOid(LDAPString);
  FName:=GetString(LDAPString,'NAME');
  FDescription:=GetString(LDAPString,'DESC');
  FObsolete:=GetBoolean(LDAPString,'OBSOLETE');
  FSyntax:=GetString(LDAPString,'SYNTAX');
end;

{ TLDAPSchemaMatchingRuleUses }

function TLDAPSchemaMatchingRuleUses.GetItems(Index: Integer): TLDAPSchemaMatchingRuleUse;
begin
   result:= TLDAPSchemaMatchingRuleUse(inherited GetItem(Index));
end;

procedure TLDAPSchemaMatchingRuleUses.Load(const Attribute: TLdapAttribute);
var
  i: integer;
begin
  for i:=0 to Attribute.ValueCount-1 do
    Add(TLDAPSchemaMatchingRuleUse.Create(Attribute.Values[i].AsString));
end;

{ TLDAPSchemaMatchingRuleUse }

constructor TLDAPSchemaMatchingRuleUse.Create(const LDAPString: string);
begin
  FApplies:=TStringList.Create;
  FOid:=GetOid(LDAPString);
  FName:=GetString(LDAPString,'NAME');
  FDescription:=GetString(LDAPString,'DESC');
  FApplies.CommaText:=GetString(LDAPString,'APPLIES');
end;

destructor TLDAPSchemaMatchingRuleUse.Destroy;
begin
  FApplies.Free;
  inherited;
end;

end.
