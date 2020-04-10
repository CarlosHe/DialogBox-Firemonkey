unit Material.DialogBoxText;

interface

uses
  Material.DialogBox,
  Material.Contracts.Container.TextBox, Material.Container.TextBox,
  Material.DialogBox.Types;

type

  TDialogBoxText = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class procedure Open(ATitle: string; AMessage: string; const AActions: TArray<string> = []; const ACallback: TDialogBoxResultCallback<string> = nil);
  end;

implementation

{ TDialogBoxText }

class procedure TDialogBoxText.Open(ATitle: string; AMessage: string; const AActions: TArray<string> = []; const ACallback: TDialogBoxResultCallback<string> = nil);
var
  LActions: TArray<string>;
  LContainer: ITextBoxContainer;
begin
  LActions := AActions;
  if Length(LActions) = 0 then
    LActions := ['OK'];
  LContainer := TTextBoxContainer.Create.SetText(AMessage);
  TDialogBox<ITextBoxContainer, string>.GetDefaultDialogBox
    .SetTitle(ATitle)
    .SetContainer(LContainer)
    .SetActions(LActions)
    .SetCallback(ACallback)
    .Open;
end;

end.
