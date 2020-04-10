unit Material.Container.TextBox;

interface

uses
  Material.Contracts.Container.TextBox, Material.Contracts.DialogBox,
  FMX.Controls, FMX.Objects, System.SysUtils, FMX.Types, System.UITypes,
  FMX.Graphics, System.Types, FMX.Forms;

type

  TTextBoxContainer = class(TInterfacedObject, ITextBoxContainer)
  private
    { private declarations }
    // FDialogBoxInstance: IDialogBox<TTextBoxContainer>;
    FText: TText;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
    function SetText(AText: string): ITextBoxContainer;
    function GetContainer: TControl;
    function GetHeight: Single;
  end;

implementation


{ TTextBoxContainer }

constructor TTextBoxContainer.Create;
begin
  FText := TText.Create(nil);
  FText.SetSubComponent(True);
  FText.Height := 0;
  FText.Stored := False;
  FText.TextSettings.VertAlign := TTextAlign.Center;
  FText.TextSettings.HorzAlign := TTextAlign.Leading;
  FText.TextSettings.Font.Size := 16;
  FText.TextSettings.Font.Family := 'Roboto';
  FText.TextSettings.FontColor := $FF000000;
  FText.Opacity := 0.6;
  FText.Margins.Left := 24;
  FText.Margins.Right := 24;
end;

destructor TTextBoxContainer.Destroy;
begin
  FText.Parent:=nil;
  FreeAndNil(FText);
  inherited;
end;

function TTextBoxContainer.GetContainer: TControl;
begin
  Result := FText;
end;

function TTextBoxContainer.GetHeight: Single;
var
  LMeasureTextRect: TRectF;
begin
  FText.RecalcSize;
  LMeasureTextRect := TRectF.Create(0, 0, FText.Width, Screen.Height);
  FText.Canvas.Font.Assign(FText.TextSettings.Font);
  FText.Canvas.MeasureText(LMeasureTextRect, FText.Text, True, [], TTextAlign.Leading, TTextAlign.Center);
  Result := Round(LMeasureTextRect.Height);
end;

function TTextBoxContainer.SetText(AText: string): ITextBoxContainer;
begin
  Result := Self;
  FText.Text := AText;
end;

end.
