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

package Camera is

  ---------------------------------------------------------------------------

  type Camera is private;

  ---------------------------------------------------------------------------

  procedure Set_Camera
    ( This    : in  out Camera;
      Position: in      GL.Floats_3;
      Target  : in      GL.Floats_3;
      Up      : in      GL.Floats_3
    );

  ---------------------------------------------------------------------------

  function Get_Position (This: in Camera) return GL.Floats_3;

  ---------------------------------------------------------------------------

  function Get_Up       (This: in Camera) return GL.Floats_3;

  ---------------------------------------------------------------------------

  function Get_Target   (This: in Camera) return GL.Floats_3;

  ---------------------------------------------------------------------------

  procedure Move (This: in out Camera; Forward: in Float; Side: in Float);

  ---------------------------------------------------------------------------

private

  ---------------------------------------------------------------------------

  type Camera is
  record
    Position: GL.Floats_3 := (others => 0.0);
    Target  : GL.Floats_3 := (0.0, 0.0, 1.0);
    Up      : GL.Floats_3 := (0.0, 1.0, 0.0);
  end record;

  ---------------------------------------------------------------------------

end Camera;
