unit Material.Controls.Scrim;

interface

uses
  FMX.Objects, FMX.Forms, FMX.Graphics, System.UITypes, System.Classes,
  FMX.Types;

type

  TScrim = class(TRectangle)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TScrim }

constructor TScrim.Create(AOwner: TComponent);
begin
  inherited;
  Self.Opacity := 0.32;
  Self.Align:= TAlignLayout.Client;
  Self.Stroke.Kind := TBrushKind.None;
  Self.Fill.Color := $FF232F34;
end;

end.
