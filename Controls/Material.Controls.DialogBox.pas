unit Material.Controls.DialogBox;

interface

uses FMX.Layouts, FMX.Objects, System.Classes, FMX.Types, FMX.Effects,
  Material.Contracts.DialogContainer, System.UITypes, FMX.Ani, FMX.Graphics,
  System.Generics.Collections, MD.Buttons, System.SysUtils,
  Material.DialogBox.Types, FMX.Forms, FMX.Controls;

type

  TDialogBoxControl = class(TRectangle)
  private
    { private declarations }
    FTitle: TText;
    FActions: TArray<string>;
    FActionButtonCollection: TObjectList<TMDFlatButton>;
    FActionArea: TLayout;
    FContainerArea: TLayout;
    FContainer: IDialogBoxContainer;
    FFloatAnimation: TFloatAnimation;
    FShadowEffect: TShadowEffect;
    FOnActionClick: TActionClick;
    procedure SetScale(const Value: Single);
    procedure SetTitle(const Value: string);
    function GetTitle: string;
    procedure SetActions(const Value: TArray<string>);
    function GetActions: TArray<string>;
    procedure SetOnActionClick(const Value: TActionClick);
  protected
    { protected declarations }
    procedure Resize; override;
    procedure ParentChanged; override;
    procedure BuildActionButtons;
    procedure ActionButtonClick(Sender: TObject);
    procedure DoActionClick(AAction: string);
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetContainer(AContainer: IDialogBoxContainer);
  published
    { published declarations }
    property PropScale: Single write SetScale;
    property Title: string read GetTitle write SetTitle;
    property Actions: TArray<string> read GetActions write SetActions;
    property OnActionClick: TActionClick read FOnActionClick write SetOnActionClick;
  end;

implementation

const
  MIN_DIALOG_HEIGHT = 200;
{$IF Defined(MSWINDOWS) or Defined(OSX) }
  MIN_DIALOG_WIDTH = 560;
{$ENDIF}
{$IF Defined(ANDROID) or Defined(IOS) }
  MIN_DIALOG_WIDTH = 280;
{$ENDIF}
  { TDialogBoxControl<T> }

procedure TDialogBoxControl.ActionButtonClick(Sender: TObject);
begin
  if Sender is TMDFlatButton then
    DoActionClick(TMDFlatButton(Sender).StyleName);
end;

procedure TDialogBoxControl.BuildActionButtons;
var
  LMDFlatButton: TMDFlatButton;
  I: Integer;
begin
  FActionButtonCollection.Clear;
  FActionArea.Parent := nil;

  if Length(FActions) > 0 then
  begin
    FActionArea.Parent := Self;

    for I := Low(FActions) to High(FActions) do
    begin
      LMDFlatButton := TMDFlatButton.Create(nil);
      LMDFlatButton.TextSettings.Font.Size := 16;
      LMDFlatButton.CanFocus := False;
      LMDFlatButton.TextSettings.Font.Family := 'Roboto';
      LMDFlatButton.TextSettings.FontColor := $FF232F34;
      LMDFlatButton.Text := FActions[I];
      LMDFlatButton.StyleName := FActions[I];
      LMDFlatButton.OnClick := ActionButtonClick;
      LMDFlatButton.Width := 100;
      LMDFlatButton.Align := TAlignLayout.Right;
      LMDFlatButton.Parent := FActionArea;
      FActionButtonCollection.Add(LMDFlatButton);
    end;

  end;

end;

constructor TDialogBoxControl.Create(AOwner: TComponent);
begin
  inherited;

  Self.Height := MIN_DIALOG_HEIGHT;
  Self.Width := MIN_DIALOG_WIDTH;
  Self.Stroke.Kind := TBrushKind.None;
  Self.Align := TAlignLayout.Center;
  Self.Fill.Color := $FFFFFFFF;
  Self.XRadius := 5;
  Self.YRadius := 5;
  Self.Scale.X := 0.3;
  Self.Scale.Y := 0.3;

  FFloatAnimation := TFloatAnimation.Create(Self);
  FFloatAnimation.AnimationType := TAnimationType.InOut;
  FFloatAnimation.PropertyName := 'PropScale';
  FFloatAnimation.StartValue := 0.3;
  FFloatAnimation.StopValue := 1;
  FFloatAnimation.Duration := 0.2;
  FFloatAnimation.Interpolation := TInterpolationType.Exponential;
  FFloatAnimation.Parent := Self;

  FShadowEffect := TShadowEffect.Create(Self);
  FShadowEffect.Direction := 90;
  FShadowEffect.Distance := 4;
  FShadowEffect.Opacity := 0.6;
  FShadowEffect.Softness := 0.4;
  FShadowEffect.Parent := Self;

  FTitle := TText.Create(Self);
  FTitle.SetSubComponent(True);
  FTitle.Stored := False;
  FTitle.Align := TAlignLayout.Top;
  FTitle.TextSettings.VertAlign := TTextAlign.Center;
  FTitle.TextSettings.HorzAlign := TTextAlign.Leading;
  FTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  FTitle.TextSettings.Font.Size := 21;
  FTitle.TextSettings.Font.Family := 'Roboto';
  FTitle.TextSettings.FontColor := $FF000000;
  FTitle.Opacity := 0.87;
  FTitle.Margins.Top := 8;
  FTitle.Margins.Left := 24;
  FTitle.Margins.Right := 24;
  FTitle.Height := 64;
  FTitle.Parent := Self;

  FActionArea := TLayout.Create(Self);
  FActionArea.SetSubComponent(True);
  FActionArea.Stored := False;
  FActionArea.Align := TAlignLayout.Bottom;
  FActionArea.Height := 52;
  FActionArea.Margins.Left := 8;
  FActionArea.Margins.Right := 8;
  FActionArea.Margins.Top := 8;
  FActionArea.Margins.Bottom := 8;

  FActionButtonCollection := TObjectList<TMDFlatButton>.Create;

  FContainerArea := TLayout.Create(Self);
  FContainerArea.SetSubComponent(True);
  FContainerArea.Stored := False;
  FContainerArea.Align := TAlignLayout.Client;
  FContainerArea.Parent := Self;
end;

destructor TDialogBoxControl.Destroy;
begin
  if FContainer <> nil then
    FContainer.GetContainer.Parent := nil;
  FreeAndNil(FActionButtonCollection);
  inherited;
end;

procedure TDialogBoxControl.DoActionClick(AAction: string);
begin
  if Assigned(FOnActionClick) then
    FOnActionClick(Self, AAction);
end;

function TDialogBoxControl.GetActions: TArray<string>;
begin
  Result := FActions;
end;

function TDialogBoxControl.GetTitle: string;
begin
  Result := FTitle.Text;
end;

procedure TDialogBoxControl.ParentChanged;
begin
  inherited;
  FFloatAnimation.Enabled := True;
  FFloatAnimation.Start;
end;

procedure TDialogBoxControl.Resize;
begin
  inherited;
  if Self.Height < MIN_DIALOG_HEIGHT then
    Self.Height := MIN_DIALOG_HEIGHT;
  if Self.Width < MIN_DIALOG_HEIGHT then
    Self.Width := MIN_DIALOG_HEIGHT;
end;

procedure TDialogBoxControl.SetActions(const Value: TArray<string>);
begin
  FActions := Value;
  BuildActionButtons;
end;

procedure TDialogBoxControl.SetContainer(AContainer: IDialogBoxContainer);
begin
  FContainer := AContainer;
  FContainer.GetContainer.Parent := FContainerArea;
  FContainer.GetContainer.Align := TAlignLayout.Client;
  Self.Height := MIN_DIALOG_HEIGHT + FContainer.GetHeight;
end;

procedure TDialogBoxControl.SetOnActionClick(const Value: TActionClick);
begin
  FOnActionClick := Value;
end;

procedure TDialogBoxControl.SetScale(const Value: Single);
begin
  Self.Scale.X := Value;
  Self.Scale.Y := Value;
  Self.Opacity := FFloatAnimation.CurrentTime * 100 / FFloatAnimation.StopValue;
  Self.RecalcSize;
end;

procedure TDialogBoxControl.SetTitle(const Value: string);
begin
  FTitle.Text := Value;
end;

end.
