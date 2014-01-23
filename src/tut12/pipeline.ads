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
with Lumen.GL;
use Lumen;

package Pipeline is

  ---------------------------------------------------------------------------

  type Pipeline is private;

  ---------------------------------------------------------------------------

  procedure Scale
    ( This: in  out Pipeline;
      X   : in      Float;
      Y   : in      Float;
      Z   : in      Float
    );

  ---------------------------------------------------------------------------

  procedure World_Pos
    ( This: in  out Pipeline;
      X   : in      Float;
      Y   : in      Float;
      Z   : in      Float
    );

  ---------------------------------------------------------------------------

  procedure Rotate
    ( This    : in  out Pipeline;
      RotateX : in      Float;
      RotateY : in      Float;
      RotateZ : in      Float
    );

  ---------------------------------------------------------------------------

  procedure Get_Trans
    ( This  : in  out Pipeline;
      Trans :     out GL.Float_Matrix
    );

  ---------------------------------------------------------------------------

  procedure Set_Perspective
    ( This  : in  out Pipeline;
      FOV   : in      Float;
      Width : in      Float;
      Height: in      Float;
      Z_Near: in      Float;
      Z_Far : in      Float
    );

  ---------------------------------------------------------------------------

private

  ---------------------------------------------------------------------------

  type Perspective_Projection is
  record
    FOV   : Float := 0.0;
    Width : Float := 0.0;
    Height: Float := 0.0;
    Z_Near: Float := 0.0;
    Z_Far : Float := 0.0;
  end record;

  ---------------------------------------------------------------------------

  type Pipeline is
  record
    Scale         : GL.Floats_3     := (others => 1.0);
    World_Pos     : GL.Floats_3     := (others => 0.0);
    Rotate_Info   : GL.Floats_3     := (others => 0.0);
    Transformation: GL.Float_Matrix := (others => (others => 0.0));
    Changed       : Boolean         := True;
    Perspective   : Perspective_Projection;
  end record;

  ---------------------------------------------------------------------------

end Pipeline;
