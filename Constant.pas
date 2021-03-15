unit Constant;

interface

const
  bmRoot           =  0;
  bmRootSel        =  1;
  bmEntry          =  2;
  bmEntrySel       =  3;
  bmPosixUser      =  4;
  bmPosixUserSel   =  4;
  bmSamba3User     =  5;
  bmSamba3UserSel  =  5;
  bmGroup          =  6;
  bmGroupSel       =  6;
  bmComputer       =  7;
  bmComputerSel    =  7;
  bmMailGroup      =  9;
  bmMailGroupSel   =  9;
  bmOu             = 13;
  bmOuSel          = 13;
  bmTransport      = 15;
  bmTransportSel   = 15;
  bmSamba2User     = 19;
  bmSamba2UserSel  = 19;
  bmSudoer         = 21;
  bmSudoerSel      = 21;
  bmHost           = 22;
  bmHostSel        = 22;
  bmNetwork        = 23;
  bmNetworkSel     = 23;
  bmLocality       = 24;
  bmLocalitySel    = 24;
  bmSambaDomain    = 25;
  bmSambaDomainSel = 25;
  bmIdPool         = 26;
  bmIdPoolSel      = 26;
  bmSchema         = 27;
  bmSchemaSel      = 27;
  bmLocked         = 28;
  bmLockedSel      = 28;
  bmUnlocked       = 29;
  bmUnlockedSel    = 29;
  bmGrOfUnqNames   = 35;
  bmGrOfUnqNamesSel= 35;

  ncDummyNode      = -1;

// Registry strings

  REG_KEY = 'Software\LdapAdmin\';
  REG_ACCOUNT = 'Accounts';
  REG_CONFIG = 'Config';

// System

  SAMBA_VERSION2    = 2;
  SAMBA_VERSION3    = 3;
  FIRST_UID         = 1000;
  LAST_UID          = 65534;
  FIRST_GID         = 1000;
  LAST_GID          = 65534;

  START_UID         = 1000;
  START_GID         = 1000;
  NO_GROUP          = 65534;
  COMPUTER_GROUP    = NO_GROUP;

  COMBO_HISTORY     = 10;

type
  TEditMode = (EM_ADD, EM_MODIFY);

const

// Registry names

  rAccountFiles       = 'ConfigFiles';
  rDontCheckProto     = 'DontCheckProto';
  rMwShowValues       = 'MwShowValues';
  rMwShowEntries      = 'MwShowEntries';
  rMwViewSplit        = 'MwVSplit';
  rMwTreeSplit        = 'MwHSplit';
  rEvViewStyle        = 'EvViewStyle';
  rMwLTWidth          = 'MwLTWidth';
  rMwLTIdentObject    = 'MwLTIdObject';
  rMwLTEnfContainer   = 'MwLTEnfContainer';
  rTemplateDir        = 'TemplateDir';
  rTemplateExtensions = 'TemplateExtensions';
  rTemplateAutoload   = 'TemplateAutoload';
  rTemplateProperties = 'TemplateProperites';
  rStartupSession     = 'StartupSession';
  rQuickSearchFilter  = 'QuickSearchFilter';
  rSmartDelete        = 'SmartDelete';
  rEditorSchemaHelp   = 'General\EdSchemaHelp';
  rPosixFirstUID      = 'Posix\FirstUID';
  rPosixLastUID       = 'Posix\LastUID';
  rPosixFirstGID      = 'Posix\FirstGID';
  rPosixLastGID       = 'Posix\LastGID';
  rPosixUserName      = 'Posix\UserName';
  rInetDisplayName    = 'Inet\DisplayName';
  rPosixHomeDir       = 'Posix\HomeDir';
  rPosixLoginShell    = 'Posix\LoginShell';
  rPosixGroup         = 'Posix\Group';
  rPosixGroupOfUnames = 'Posix\PosixGroupOfUniqueNames';
  rSambaNetbiosName   = 'Samba\NetbiosName';
  rSambaDomainName    = 'Samba\DomainName';
  rSambaHomeShare     = 'Samba\HomeShare';
  rSambaHomeDrive     = 'Samba\HomeDrive';
  rSambaScript        = 'Samba\Script';
  rSambaProfilePath   = 'Samba\ProfilePath';
  rPostfixMailAddress = 'Postfix\MailAddress';
  rPostfixMaildrop    = 'Postfix\Maildrop';
  rSearchBase         = 'Search\Base';
  rSearchAttributes   = 'Search\Attributes';
  rSearchScope        = 'Search\Scope';
  rSearchFilters      = 'Search\Filters\';
  rSearchDerefAliases = 'Search\DereferenceAliases';
  rTemplateFormHeight = 'TemplateForm\Height';
  rTemplateFormWidth  = 'TemplateForm\Width';

// Search filters

  sANYCLASS         = '(objectclass=*)';
  sSAMBAACCNT       = '(objectclass=sambaAccount)';
  sPOSIXACCNT       = '(objectclass=posixAccount)';
  sMAILACCNT        = '(objectclass=mailUser)';
  sGROUPS           = '(objectclass=posixGroup)';
  sCOMPUTERS        = '(&'+sPOSIXACCNT+'(uid=*$))';
  sUSERS            = '(&'+sPOSIXACCNT+'(!(uid=*$)))';
  sMAILGROUPS       = '(objectclass=mailGroup)';
  {sMY_GROUP         = '(|(&(objectclass=posixGroup)(memberUid=%s))'  +
                        '(&(objectclass=groupOfNames)(member=%1:s))' +
                        '(&(objectclass=groupOfUniqueNames)(uniqueMember=%1:s)))';}
  sMY_GROUP         = '(&(objectclass=posixGroup)(|(memberUid=%s)(member=%s)(uniqueMember=%1:s)))';
  sMY_POSIX_GROUP   = '(&(objectclass=posixGroup)(memberUid=%s))';
  sMY_MAILGROUP     = '(&(objectclass=mailGroup)(member=%s))';
  sMY_GROUPS        = '(|(&(objectclass=posixGroup)(memberUid=%s))'  +
                        '(&(|(objectclass=groupOfNames)(objectclass=mailGroup))(member=%1:s))' +
                        '(&(objectclass=groupOfUniqueNames)(uniqueMember=%1:s)))';
  sMY_DN_GROUPS     = '(|(&(|(objectclass=groupOfNames)(objectclass=mailGroup))(member=%0:s))' +
                        '(&(objectclass=groupOfUniqueNames)(uniqueMember=%0:s)))';
  sGROUPBYGID       = '(&(objectclass=posixGroup)(gidNumber=%d))';
  sACCNTBYUID       = '(&(objectclass=posixAccount)(uid=%s))';
  sDEFQUICKSRCH     = '(|(cn=*%s*)(uid=*%s*)(displayName=*%s*))';

// Captions

  cAppName          = 'LDAP Admin';
  cAnonymousConn    = 'Anonymous connection';
  cSASLCurrUSer     = 'Use current user credentials';
  cDescription      = 'Description';
  cPickGroups       = 'Choose Groups';
  cPickAccounts     = 'Choose Accounts';
  cNewResource      = 'New Resource';
  cEditResource     = 'Edit Resource';
  cResource         = 'Resource:';
  cPropertiesOf     = 'Properties of %s';
  cAddAddress       = 'Add Address';
  cEditAddress      = 'Edit Address';
  cSmtpAddress      = 'SMTP Address:';
  cConfirm          = 'Confirmation';
  cServer           = 'Server: %s';
  cPath             = 'Path: %s';
  cUser             = 'User: %s';
  cEditEntry        = 'Edit entry';
  cNewEntry         = 'New entry';
  cSurname          = 'Second name';
  cName             = 'Name';
  cIpAddress        = 'IP Address';
  cUsername         = 'Username';
  cHomeDir          = 'Home Directory';
  cMaildrop         = 'Maildrop';
  cAddConn          = 'New connection';
  cRename           = 'Rename';
  cNewName          = 'New name:';
  cDeleting         = 'Deleting:';
  cPreparing        = 'Preparing...';
  cCopyTo           = 'Copy %s to...';
  cMoveTo           = 'Move %s to...';
  cMoving           = 'Moving...';
  cCopying          = 'Copying...';
  cAddHost          = 'Add Host';
  cEditHost         = 'Edit Host';
  cHostName         = 'Host Name:';
  cSambaDomain      = 'Samba Domain';
  cEnterPasswd      = 'Enter password';
  cSearchResults    = 'Search results:';
  cAttribute        = 'Attribute';
  cValue            = 'Value';
  cOldValue         = 'Old value';
  cNewValue         = 'New value';
  cObjectclass      = 'Objectclass';
  cNew              = '<<new>>';
  cSetPassword      = 'Set password...';
  cRegistryCfgName  = 'Private';
  sConnectSuccess   = 'Connection is successful.';
  cAddAttribute     = 'Add attribute...';
  cAttributeName    = 'Attribute name:';
  cProgress         = 'Progress:';
  
// Messages
  stOverwrite       = 'Do you want to overwrite?';
  stLdapError       = 'LDAP error: %s!';
  //stLdapErrorEx     = stLdapError + #10#13 + '%s.';
  stLdapErrorEx     = 'LDAP error! %s: %s.';
  stReqAttr         = 'Attribute %s may not be empty!';
  stReqNoEmpty      = '%s must have a value!';
  stReqMail         = 'At least one E-Mail address must be defined!';
  stPassDiff        = 'Passwords do not match!';
  stPassFor         = 'Password for : %s';
  stAccntNameReq    = 'You have to enter a name for this connection!';
  stGroupNameReq    = 'You have to enter a name for this group!';
  stGroupMailReq    = 'You have to enter at least one mail address for this group!';
  stGidNotSamba     = 'Selected primary group is not a Samba group or it does not map to user domain. Do you still want to continue?';
  stConfirmDel      = 'Delete entry "%s"?';
  stConfirmDelAccnt = 'Delete account "%s"?';
  stConfirmMultiDel = 'Delete %d entries?';
  stRegAccntErr     = 'Could not read account data!';
  stNoMoreNums      = 'No more available numbers for %s!';
  stUnclosedStr     = 'Unclosed string!';
  stObjnRetrvd      = 'Object not yet retrieved!';
  stSmbDomainReq    = 'You have to select samba domain to which this group should be mapped!';
  stDeleteAll       = '"%s"'#10#13'This directory entry is not empty (it contains further leaves). Delete all recursively?';
  stMoveOverlap     = 'Cannot move: Source and destination paths overlap!';
  stAskTreeCopy     = 'Copy %s to %s?';
  stAskTreeMove     = 'Move %s to %s?';
  stNumObjects      = '%d objects';
  stFileReadOnly    = 'File opened in read only mode!';
  stLdifEVer        = 'Invalid version value: %s!';
  stLdifEFold       = 'Line %d: Empty line may not be folded!';
  stLdifENoCol      = 'Line %d: Missing ":".';
  stLdifENoDn       = 'Line %d: dn expected but %s found!';
  stLdifInvChType   = 'Line %d: Invalid changetype "%s"!';
  stLdifInvOp       = 'Line %d: Invalid operation "%s"!';
  stLdifNotExpected = 'Line %d: Expected "%s" but found "%s"!';
  stLdifInvAttrName = 'Line %d: Invalid attribute name, expected "%s" but found "%s"!';
  stLdifSuccess     = '%d Object(s) succesfully imported!';
  stLdifFailure     = '%d Object(s) could not be imported!';
  stLdifEof         = 'End of file reached!';
  stLdifInvalidUrl  = 'Invalid URL!';
  stLdifUrlNotSupp  = 'URL method not supported!';
  stInvalidLdapOp   = 'Invalid Ldap operation!';
  stSkipRecord      = '%s'#10#13'Skip this record?';
  stFileOverwrite   = 'File ''%s'' exists, overwrite?';
  stCertNotFound    = 'Issuer certificate not found';
  stCertSelfSigned  = 'The certificate is self-signed root certificate';
  stCertInvalidSig  = 'Signature check failed!';
  stCertInvalidTime = 'The security certificate has expired or is not yet valid!';
  stCertInvalidName = 'The name of the security certificate is invalid or does not match the server name!';
  stCertConfirmConn = 'The server you are trying to connect to is using a certificate which could not be verified!'#10#13#10#13'%s'#10#13'Do you want to proceed?';
  stExtConfirmAssoc = 'LDAPAdmin is currently not your default LDAP browser.'+#10+'Would you like to make it your default LDAP browser?';
  stResetAutolock   = 'This account has been locked down by SAMBA server! Do you want to reset the autolock flag and enable it now?';
  stDoNotCheckAgain = 'Do not perform this check in the future.';
  stDoNotShowAgain  = 'Do not show this message in the future.';
  stNoRdn           = 'You have to enter the unique name (rdn) for this entry!';
  stRetrieving      = 'Reading: %d objects retrieved. Press ESC to abort...';
  stInserting       = 'Inserting, %d of %d. Press ESC to abort...';
  stDisplaying      = 'Displaying first %d results.';
  stSorting         = 'Sorting...';
  stCntObjects      = '%d object(s) retrieved.';
  stCntSubentries   = '%d subentries';
  stUnclosedParam   = 'Invalid (Unclosed) parameter!';
  stIdentIsnotValid = '"%s" is not a valid %s!';
  stDuplicateEntry  = 'EntryList does not allow duplicates';
  stCantStorPass    = 'This storage does not allow to keep the password';
  stAccntExist      = 'Account with this name already exists.' + #10#13 + stOverwrite;
  stInvalidFilter   = 'Invalid or unsupported filter type!';

implementation

end.
