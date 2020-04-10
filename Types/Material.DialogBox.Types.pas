unit Material.DialogBox.Types;
{$SCOPEDENUMS ON}

interface

type
  TDialogBoxResultCallback<T> = reference to procedure(Sender: TObject; Action: string; Value: T; var CanClose: Boolean);
  TActionClick = reference to procedure(Sender: TObject; Action: string);

  TDialogBoxButtons = (SideBySide, Stacked);

  TDialogBoxOption = (Title, SupportingText);
  TDialogBoxOptions = set of TDialogBoxOption;

implementation

end.
