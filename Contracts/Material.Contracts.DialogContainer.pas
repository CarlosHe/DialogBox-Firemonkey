unit Material.Contracts.DialogContainer;

interface

uses
  FMX.Controls;

type

  IDialogBoxContainer = interface
    ['{4D23F281-C1D5-4FF8-82A6-FAB63C95CC03}']
    function GetContainer: TControl;
    function GetHeight: Single;
  end;

implementation

end.
