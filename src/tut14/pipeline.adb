pragma License (Modified_GPL);
------------------------------------------------------------------------------
-- EMAIL: <darkestkhan@gmail.com>                                           --
-- License: Modified GNU GPLv3 or any later as published by Free Software   --
--  Foundation (GMGPL, see COPYING file).                                   --
--                                                                          --
--                    Copyright © 2014 darkestkhan                          --
------------------------------------------------------------------------------
--  This Program is Free Software: You can redistribute it and/or modify    --
--  it under the terms of The GNU General Public License as published by    --
--    the Free Software Foundation: either version 3 of the license, or     --
--                 (at your option) any later version.                      --
--                                                                          --
--      This Program is distributed in the hope that it will be useful,     --
--      but WITHOUT ANY WARRANTY; without even the implied warranty of      --
--      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the        --
--              GNU General Public License for more details.                --
--                                                                          --
--    You should have received a copy of the GNU General Public License     --
--   along with this program.  If not, see <http://www.gnu.org/licenses/>.  --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
------------------------------------------------------------------------------
with Ada.Numerics.Elementary_Functions;

with Math;
use Math;
package body Pipeline is

  ---------------------------------------------------------------------------

  package EF renames Ada.Numerics.Elementary_Functions;

  ---------------------------------------------------------------------------

  procedure Scale
    ( This: in  out Pipeline;
      X   : in      Float;
      Y   : in      Float;
      Z   : in      Float
    )
  is
  begin
    This.Scale (1)  := X;
    This.Scale (2)  := Y;
    This.Scale (3)  := Z;
    This.Changed    := True;
  end Scale;

  ---------------------------------------------------------------------------

  procedure World_Pos
    ( This: in  out Pipeline;
      X   : in      Float;
      Y   : in      Float;
      Z   : in      Float
    )
  is
  begin
    This.World_Pos (1)  := X;
    This.World_Pos (2)  := Y;
    This.World_Pos (3)  := Z;
    This.Changed        := True;
  end World_Pos;

  ---------------------------------------------------------------------------

  procedure Rotate
    ( This    : in  out Pipeline;
      RotateX : in      Float;
      RotateY : in      Float;
      RotateZ : in      Float
    )
  is
  begin
    This.Rotate_Info (1) := RotateX;
    This.Rotate_Info (2) := RotateY;
    This.Rotate_Info (3) := RotateZ;
    This.Changed    := True;
  end Rotate;

  ---------------------------------------------------------------------------

  procedure Set_Camera
    ( This  : in  out Pipeline;
      Pos   : in      GL.Floats_3;
      Target: in      GL.Floats_3;
      Up    : in      GL.Floats_3
    )
  is
  begin
    This.Changed        := True;
    This.Camera.Pos     := Pos;
    This.Camera.Target  := Target;
    This.Camera.Up      := Up;
  end Set_Camera;

  ---------------------------------------------------------------------------

  procedure Set_Perspective
    ( This  : in  out Pipeline;
      FOV   : in      Float;
      Width : in      Float;
      Height: in      Float;
      Z_Near: in      Float;
      Z_Far : in      Float
    )
  is
  begin
    This.Perspective.FOV    := FOV;
    This.Perspective.Width  := Width;
    This.Perspective.Height := Height;
    This.Perspective.Z_Near := Z_Near;
    This.Perspective.Z_Far  := Z_Far;
    This.Changed            := True;
  end Set_Perspective;

  ---------------------------------------------------------------------------

  procedure Init_Scale_Transform
    ( This: in      Pipeline;
      M   :     out GL.Float_Matrix
    )
  is
  begin
    M (1, 1) := This.Scale (1);
    M (1, 2) := 0.0;
    M (1, 3) := 0.0;
    M (1, 4) := 0.0;

    M (2, 1) := 0.0;
    M (2, 2) := This.Scale (2);
    M (2, 3) := 0.0;
    M (2, 4) := 0.0;

    M (3, 1) := 0.0;
    M (3, 2) := 0.0;
    M (3, 3) := This.Scale (3);
    M (3, 4) := 0.0;

    M (4, 1) := 0.0;
    M (4, 2) := 0.0;
    M (4, 3) := 0.0;
    M (4, 4) := 1.0;
  end Init_Scale_Transform;

  ---------------------------------------------------------------------------

  procedure Init_Rotate_Transform
    ( This: in      Pipeline;
      M   :     out GL.Float_Matrix
    )
  is
    RX, RY, RZ: GL.Float_Matrix := (others => (others => 0.0));
  begin
    RX (1, 1) := 1.0;
    RX (2, 2) := EF.Cos (This.Rotate_Info (1), 360.0);
    RX (2, 3) := (-EF.Sin (This.Rotate_Info (1), 360.0));
    RX (3, 2) := EF.Sin (This.Rotate_Info (1), 360.0);
    RX (3, 3) := EF.Cos (This.Rotate_Info (1), 360.0);
    RX (4, 4) := 1.0;

    RY (1, 1) := EF.Cos (This.Rotate_Info (2), 360.0);
    RY (1, 3) := (-EF.Sin (This.Rotate_Info (2), 360.0));
    RY (2, 2) := 1.0;
    RY (3, 1) := EF.Sin (This.Rotate_Info (2), 360.0);
    RY (3, 3) := EF.Cos (This.Rotate_Info (2), 360.0);
    RY (4, 4) := 1.0;

    RZ (1, 1) := EF.Cos (This.Rotate_Info (3), 360.0);
    RZ (1, 2) := (-EF.Sin (This.Rotate_Info (3), 360.0));
    RZ (2, 1) := EF.Sin (This.Rotate_Info (3), 360.0);
    RZ (2, 2) := EF.Cos (This.Rotate_Info (3), 360.0);
    RZ (3, 3) := 1.0;
    RZ (4, 4) := 1.0;

    M := RZ * RY * RX;
  end Init_Rotate_Transform;

  ---------------------------------------------------------------------------

  procedure Init_Translation_Transform
    ( This: in      Pipeline;
      M   :     out GL.Float_Matrix
    )
  is
  begin
    M (1, 1) := 1.0;
    M (1, 2) := 0.0;
    M (1, 3) := 0.0;
    M (1, 4) := This.World_Pos (1);

    M (2, 1) := 0.0;
    M (2, 2) := 1.0;
    M (2, 3) := 0.0;
    M (2, 4) := This.World_Pos (2);

    M (3, 1) := 0.0;
    M (3, 2) := 0.0;
    M (3, 3) := 1.0;
    M (3, 4) := This.World_Pos (3);

    M (4, 1) := 0.0;
    M (4, 2) := 0.0;
    M (4, 3) := 0.0;
    M (4, 4) := 1.0;
  end Init_Translation_Transform;

  ---------------------------------------------------------------------------

  procedure Init_Perspective_Projection
    ( This: in      Pipeline;
      M   :     out GL.Float_Matrix
    )
  is
    AR: constant Float := This.Perspective.Width / This.Perspective.Height;
    Z_Near: constant Float := This.Perspective.Z_Near;
    Z_Far : constant Float := This.Perspective.Z_Far;
    Z_Range: constant Float := Z_Near - Z_Far;
    Tan_Half_FOV: constant Float := EF.Tan (This.Perspective.FOV / 2.0, 360.0);
  begin
    M (1, 1) := 1.0 / (Tan_Half_FOV * AR);
    M (1, 2) := 0.0;
    M (1, 3) := 0.0;
    M (1, 4) := 0.0;

    M (2, 1) := 0.0;
    M (2, 2) := 1.0 / Tan_Half_FOV;
    M (2, 3) := 0.0;
    M (2, 4) := 0.0;

    M (3, 1) := 0.0;
    M (3, 2) := 0.0;
    M (3, 3) := (-Z_Near - Z_Far) / Z_Range;
    M (3, 4) := 2.0 * Z_Far * Z_Near / Z_Range;

    M (4, 1) := 0.0;
    M (4, 2) := 0.0;
    M (4, 3) := 1.0;
    M (4, 4) := 0.0;
  end Init_Perspective_Projection;

  ---------------------------------------------------------------------------

  procedure Init_Camera_Transform
    ( This: in  out Pipeline;
      M   :     out GL.Float_Matrix
    )
  is
    N: constant GL.Floats_3 := Normalize (This.Camera.Target);
    U: constant GL.Floats_3 := Cross (Normalize (This.Camera.Up), N);
    V: constant GL.Floats_3 := Cross (N, U);
  begin
    M (1, 1) := U (1);
    M (1, 2) := U (2);
    M (1, 3) := U (3);
    M (1, 4) := 0.0;

    M (2, 1) := V (1);
    M (2, 2) := V (2);
    M (2, 3) := V (3);
    M (2, 4) := 0.0;

    M (3, 1) := N (1);
    M (3, 2) := N (2);
    M (3, 3) := N (3);
    M (3, 4) := 0.0;

    M (4, 1) := 0.0;
    M (4, 2) := 0.0;
    M (4, 3) := 0.0;
    M (4, 4) := 1.0;
  end Init_Camera_Transform;

  ---------------------------------------------------------------------------

  procedure Init_Camera_Translation
    ( This: in  out Pipeline;
      M   :     out GL.Float_Matrix
    )
  is
  begin
    M (1, 1) := 1.0;
    M (1, 2) := 0.0;
    M (1, 3) := 0.0;
    M (1, 4) := -This.Camera.Pos (1);

    M (2, 1) := 0.0;
    M (2, 2) := 1.0;
    M (2, 3) := 0.0;
    M (2, 4) := -This.Camera.Pos (2);

    M (3, 1) := 0.0;
    M (3, 2) := 0.0;
    M (3, 3) := 1.0;
    M (3, 4) := -This.Camera.Pos (3);

    M (4, 1) := 0.0;
    M (4, 2) := 0.0;
    M (4, 3) := 0.0;
    M (4, 4) := 1.0;
  end Init_Camera_Translation;

  ---------------------------------------------------------------------------

  procedure Get_Trans
    ( This  : in  out Pipeline;
      Trans :     out GL.Float_Matrix
    )
  is
    Scale_Trans, Rotate_Trans, Translation_Trans: GL.Float_Matrix;
    Pers_Proj_Trans, Camera_Translation_Trans   : GL.Float_Matrix;
    Camera_Rotation_Trans                       : GL.Float_Matrix;

  begin
    if This.Changed then
      Init_Scale_Transform (This, Scale_Trans);
      Init_Rotate_Transform (This, Rotate_Trans);
      Init_Translation_Transform (This, Translation_Trans);
      Init_Perspective_Projection (This, Pers_Proj_Trans);
      Init_Camera_Transform (This, Camera_Rotation_Trans);
      Init_Camera_Translation (This, Camera_Translation_Trans);

      This.Transformation :=
        Pers_Proj_Trans * Camera_Rotation_Trans * Camera_Translation_Trans *
        Translation_Trans * Rotate_Trans * Scale_Trans;
      This.Changed        := False;
      Trans               := This.Transformation;
    else
      Trans := This.Transformation;
    end if;
  end Get_Trans;

  ---------------------------------------------------------------------------

end Pipeline;
