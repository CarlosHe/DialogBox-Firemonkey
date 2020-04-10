unit Material.DialogBox;

interface

uses
  Material.Contracts.DialogBox, Material.DialogBox.Types,
  Material.Contracts.DialogContainer, Material.Controls.DialogBox,
  System.SysUtils, FMX.Forms, FMX.Objects, Material.Controls.Scrim, FMX.Layouts,
  FMX.Types, System.UITypes;

type
  TDialogBox<T: IDialogBoxContainer; I> = class(TInterfacedObject, IDialogBox<T, I>)
  private
    { private declarations }
    FIsOpen: Boolean;
    FDialogBoxControl: TDialogBoxControl;
    FScrim: TScrim;
    FDialogBoxContainer: TLayout;
    FContainer: T;
    FOptions: TDialogBoxOptions;
    FButtons: TDialogBoxButtons;
    FTitle: string;
    FActions: TArray<string>;
    FResultCallback: TDialogBoxResultCallback<I>;
    class var FInstance: IDialogBox<T, I>;
  protected
    { protected declarations }
    function ExecuteAction(AAction: string): IDialogBox<T, I>;
    procedure ScrimClick(Sender: TObject);
    procedure ActionClick(Sender: TObject; Action: string);
    procedure DoClose;
    procedure DoOpen;
    procedure DoCallback(Action: string; Value: I);
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
    function SetContainer(AContainer: T): IDialogBox<T, I>;
    function SetOptions(AOptions: TDialogBoxOptions): IDialogBox<T, I>;
    function SetButtons(AButtons: TDialogBoxButtons): IDialogBox<T, I>;
    function SetTitle(ATitle: string): IDialogBox<T, I>;
    function SetActions(AActions: TArray<string>): IDialogBox<T, I>;
    function SetCallback(ACallback: TDialogBoxResultCallback<I>): IDialogBox<T, I>;
    function GetContainer(out AContainer: T): IDialogBox<T, I>;
    function Open: IDialogBox<T, I>;
    function Close: IDialogBox<T, I>;
    class function GetDefaultDialogBox: IDialogBox<T, I>;
  end;

implementation


{ TDialogBox<T,I> }

procedure TDialogBox<T, I>.ActionClick(Sender: TObject; Action: string);
var
  LNone: I;
begin
  DoCallback(Action, LNone);
end;

function TDialogBox<T, I>.Close: IDialogBox<T, I>;
begin
  Result := Self;
  DoClose;
end;

constructor TDialogBox<T, I>.Create;
begin
  FIsOpen := False;
end;

destructor TDialogBox<T, I>.Destroy;
begin
  inherited;
end;

procedure TDialogBox<T, I>.DoCallback(Action: string; Value: I);
var
  LCanClose: Boolean;
begin
  LCanClose := True;
  if Assigned(FResultCallback) then
    FResultCallback(Self, Action, Value, LCanClose);
  if LCanClose then
    DoClose;
end;

procedure TDialogBox<T, I>.DoClose;
begin
  FDialogBoxContainer.Parent := nil;
  FreeAndNil(FDialogBoxContainer);
  FContainer := nil;
  FInstance := nil;
  FIsOpen := False;
end;

procedure TDialogBox<T, I>.DoOpen;
begin
  if not FIsOpen then
  begin
    FIsOpen := True;
    FDialogBoxContainer := TLayout.Create(nil);
    FDialogBoxContainer.Parent := TForm(Screen.ActiveForm);
    FDialogBoxContainer.Position.X := 0;
    FDialogBoxContainer.Position.Y := 0;
    FDialogBoxContainer.Height := Screen.ActiveForm.ClientHeight;
    FDialogBoxContainer.Width := Screen.ActiveForm.ClientWidth;
    FDialogBoxContainer.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];

    FScrim := TScrim.Create(FDialogBoxContainer);
    FScrim.OnClick := ScrimClick;
    FScrim.Parent := FDialogBoxContainer;

    FDialogBoxControl := TDialogBoxControl.Create(FDialogBoxContainer);
    FDialogBoxControl.Title := FTitle;
    FDialogBoxControl.Actions := FActions;
    FDialogBoxControl.Parent := FDialogBoxContainer;
    FDialogBoxControl.OnActionClick := ActionClick;
    FDialogBoxControl.SetContainer(FContainer);
  end;
end;

function TDialogBox<T, I>.ExecuteAction(AAction: string): IDialogBox<T, I>;
begin
  Result := Self;
end;

function TDialogBox<T, I>.GetContainer(out AContainer: T): IDialogBox<T, I>;
begin
  Result := Self;
  AContainer := FContainer;
end;

class function TDialogBox<T, I>.GetDefaultDialogBox: IDialogBox<T, I>;
begin
  if FInstance = nil then
    FInstance := TDialogBox<T, I>.Create;
  Result := FInstance;
end;

function TDialogBox<T, I>.Open: IDialogBox<T, I>;
begin
  Result := Self;
  DoOpen;
end;

procedure TDialogBox<T, I>.ScrimClick(Sender: TObject);
var
  LNone: I;
begin
  DoCallback('CLOSE', LNone)
end;

function TDialogBox<T, I>.SetActions(AActions: TArray<string>): IDialogBox<T, I>;
begin
  Result := Self;
  FActions := AActions;
end;

function TDialogBox<T, I>.SetButtons(AButtons: TDialogBoxButtons): IDialogBox<T, I>;
begin
  Result := Self;
  FButtons := AButtons;
end;

function TDialogBox<T, I>.SetCallback(ACallback: TDialogBoxResultCallback<I>): IDialogBox<T, I>;
begin
  Result := Self;
  FResultCallback := ACallback;
end;

function TDialogBox<T, I>.SetContainer(AContainer: T): IDialogBox<T, I>;
begin
  Result := Self;
  FContainer := AContainer;
end;

function TDialogBox<T, I>.SetOptions(AOptions: TDialogBoxOptions): IDialogBox<T, I>;
begin
  Result := Self;
  FOptions := AOptions;
end;

function TDialogBox<T, I>.SetTitle(ATitle: string): IDialogBox<T, I>;
begin
  Result := Self;
  FTitle := ATitle;
end;

end.
