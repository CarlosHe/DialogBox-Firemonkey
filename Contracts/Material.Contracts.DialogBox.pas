unit Material.Contracts.DialogBox;

interface

uses
  Material.DialogBox.Types, Material.Contracts.DialogContainer;

type

  IDialogBox<T: IDialogBoxContainer; I> = interface
    ['{ECDF8C51-F66B-4EE2-8FD5-CC38A95CE609}']
    function SetContainer(AContainer: T): IDialogBox<T,I>;
    function SetOptions(AOptions: TDialogBoxOptions): IDialogBox<T,I>;
    function SetButtons(AButtons: TDialogBoxButtons): IDialogBox<T,I>;
    function SetTitle(ATitle: string): IDialogBox<T,I>;
    function SetActions(AActions: TArray<string>): IDialogBox<T,I>;
    function SetCallback(ACallback: TDialogBoxResultCallback<I>): IDialogBox<T,I>;
    function GetContainer(out AContainer: T): IDialogBox<T,I>;
    function ExecuteAction(AAction: string): IDialogBox<T,I>;
    function Open: IDialogBox<T,I>;
    function Close: IDialogBox<T,I>;
  end;

implementation

end.
