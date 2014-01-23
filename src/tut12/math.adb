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

package body Math is

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

end Math;
