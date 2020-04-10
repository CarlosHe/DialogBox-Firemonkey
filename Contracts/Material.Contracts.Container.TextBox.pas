unit Material.Contracts.Container.TextBox;

interface

uses
  Material.Contracts.DialogContainer;

type

  ITextBoxContainer = interface(IDialogBoxContainer)
    ['{B7D30FFE-0D2C-4CCC-A7F1-4AD86BB627AA}']
    function SetText(AText: string): ITextBoxContainer;
  end;

implementation

end.
