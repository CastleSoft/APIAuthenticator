{------------------------------------------------------------------------------}
{                                                                              }
{             Delphi REST Client Framework                                     }
{             Custom API Authenticator   X-API-KEY and  X-API-TENANT           }
{                                                                              }
{ REST.Authenticator.API                                                       }
{ =========================                                                    }
{                                                                              }
{ Description:  Custom API Authenticator for REST                              }
{                                                                              }
{ This source code is coprighted material.                                     }
{                                                                              }
{ Copyright (c) CastleSoft Pty Ltd. 1995-2020. All rights reserved.            }
{                                                                              }
{ MIT License                                                                  }
{                                                                              }
{ Permission is hereby granted, free of charge, to any person obtaining a copy }
{ of this software and associated documentation files (the "Software"), to     }
{ deal in the Software without restriction, including without limitation the   }
{ rights to use, copy, modify, merge, publish, distribute, sublicense, and/or  }
{ sell copies of the Software, and to permit persons to whom the Software is   }
{ furnished to do so, subject to the following conditions:                     }
{                                                                              }
{ The above copyright notice and this permission notice shall be included in   }
{ all copies or substantial portions of the Software.                          }
{                                                                              }
{ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   }
{ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     }
{ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  }
{ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       }
{ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,}
{ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN    }
{ THE SOFTWARE.                                                                }
{                                                                              }
{                                                                              }
{ Version       Date          Description               Modified by            }
{ ---------------------------------------------------------------------------- }
{  1.0.0        30-Apr-2020   Initial Release           Andrew Tierney         }
{------------------------------------------------------------------------------}
unit REST.Authenticator.API;

interface

uses
  System.SysUtils, System.Classes, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client,
  REST.Types,
  REST.Consts,
  REST.BindSource;

type
  TSubAPIAuthenticatorBindSource = class;

  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator32 or pidiOSDevice32 or pidiOSDevice64 or pidAndroid32Arm)]
  TAPIAuthenticator = class(TCustomAuthenticator)
  private
    { Private declarations }
    FX_API_KEY: string;
    FX_API_TENANT: string;
    FBindSource: TSubAPIAuthenticatorBindSource;
    procedure SetAPIKey(const AValue: string);
    procedure SetTENANT(const AValue: string);
  protected
    { Protected declarations }
    procedure DoAuthenticate(ARequest: TCustomRESTRequest); override;
    function CreateBindSource: TBaseObjectBindSource; override;
  public
    { Public declarations }
  published
    { Published declarations }
    property X_API_KEY: string read FX_API_KEY write SetAPIKey;
    property X_API_TENANT: string read FX_API_TENANT write SetTENANT;
    property BindSource: TSubAPIAuthenticatorBindSource read FBindSource;
  end;

  TSubAPIAuthenticatorBindSource = class
    (TRESTAuthenticatorBindSource<TAPIAuthenticator>)
  protected
    function CreateAdapterT
      : TRESTAuthenticatorAdapter<TAPIAuthenticator>; override;
  end;

  TAPIAuthenticatorAdapter = class(TRESTAuthenticatorAdapter<TAPIAuthenticator>)
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('REST Client', [TAPIAuthenticator]);
end;

{ TSubAPIAuthenticatorBindSource }

function TSubAPIAuthenticatorBindSource.CreateAdapterT: TRESTAuthenticatorAdapter<TAPIAuthenticator>;
begin
  result := TAPIAuthenticatorAdapter.Create(Self);
end;

function TAPIAuthenticator.CreateBindSource: TBaseObjectBindSource;
begin
  FBindSource := TSubAPIAuthenticatorBindSource.Create(Self);
  FBindSource.Name := 'BindSource'; { Do not localize }
  FBindSource.SetSubComponent(True);
  FBindSource.Authenticator := Self;

  result := FBindSource;
end;

procedure TAPIAuthenticator.DoAuthenticate(ARequest: TCustomRESTRequest);
begin
  inherited;

  ARequest.Params.BeginUpdate;
  try
    ARequest.AddParameter('X-API-KEY', FX_API_KEY,
      TRESTRequestParameterKind.pkHTTPHEADER,
      [TRESTRequestParameterOption.poDoNotEncode]);
    ARequest.AddParameter('X-API-TENANT', FX_API_TENANT,
      TRESTRequestParameterKind.pkHTTPHEADER,
      [TRESTRequestParameterOption.poDoNotEncode]);
  finally
    ARequest.Params.EndUpdate;
  end;
end;

procedure TAPIAuthenticator.SetAPIKey(const AValue: string);
begin
     if (AValue <> FX_API_KEY) then
     begin
         FX_API_KEY := AValue;
         PropertyValueChanged;
     end;
end;

procedure TAPIAuthenticator.SetTENANT(const AValue: string);
begin
    if (AValue <> FX_API_TENANT) then
    begin
      FX_API_TENANT := AValue;
      PropertyValueChanged;
    end;
end;


end.
