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

package body Math is

  ---------------------------------------------------------------------------

  package EF renames Ada.Numerics.Elementary_Functions;

  ---------------------------------------------------------------------------

  function Identity return GL.Float_Matrix
  is
  begin
    return R: GL.Float_Matrix := (others => (others => 0.0)) do
      R (1, 1) := 1.0;
      R (2, 2) := 1.0;
      R (3, 3) := 1.0;
      R (4, 4) := 1.0;
    end return;
  end Identity;

  ---------------------------------------------------------------------------

  function "*" (Left, Right: in GL.Float_Matrix) return GL.Float_Matrix
  is
  begin
    return R: GL.Float_Matrix do
      for K in R'Range (1) loop
        for L in R'Range (2) loop
          R (K, L) := Left (K, 1) * Right (1, L) +
                      Left (K, 2) * Right (2, L) +
                      Left (K, 3) * Right (3, L) +
                      Left (K, 4) * Right (4, L);
        end loop;
      end loop;
    end return;
  end "*";

  ---------------------------------------------------------------------------

  function "+" (Left, Right: in GL.Floats_3) return GL.Floats_3
  is
  begin
    return (Left (1) + Right (1), Left (2) + Right (2), Left (3) + Right (3));
  end "+";

  ---------------------------------------------------------------------------

  function "*" (Left: in GL.Floats_3; Right: in Float) return GL.Floats_3
  is
  begin
    return (Left (1) * Right, Left (2) * Right, Left (3) * Right);
  end "*";

  ---------------------------------------------------------------------------

  function Cross (Left, Right: in GL.Floats_3) return GL.Floats_3
  is
    X: constant Float := Left (2) * Right (3) - Left (3) * Right (2);
    Y: constant Float := Left (3) * Right (1) - Left (1) * Right (3);
    Z: constant Float := Left (1) * Right (2) - Left (2) * Right (1);
  begin
    return GL.Floats_3'(X, Y, Z);
  end Cross;

  ---------------------------------------------------------------------------

  function Normalize (This: in GL.Floats_3) return GL.Floats_3
  is
    Length: constant Float :=
      EF.Sqrt (This (1) ** 2 + This (2) ** 2 + This (3) ** 2);
  begin
    return R: GL.Floats_3 := This do
      R (1) := R (1) / Length;
      R (2) := R (2) / Length;
      R (3) := R (3) / Length;
    end return;
  end Normalize;

  ---------------------------------------------------------------------------

  procedure Normalize (This: in out GL.Floats_3)
  is
    Length: constant Float :=
      EF.Sqrt (This (1) ** 2 + This (2) ** 2 + This (3) ** 2);
  begin
    This (1) := This (1) / Length;
    This (2) := This (2) / Length;
    This (3) := This (3) / Length;
  end Normalize;

  ---------------------------------------------------------------------------

end Math;
