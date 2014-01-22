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
with Lumen.Events;
with Lumen.Window;
use Lumen;

package Util is

  ---------------------------------------------------------------------------

  Win: Window.Window_Handle;

  Default_Screen_Width  : constant Natural := 640;
  Default_Screen_Height : constant Natural := 480;
  Default_Screen_FPS    : constant Natural := 60;

  ---------------------------------------------------------------------------

  procedure Handle_Key_Press
    ( Category  : Lumen.Events.Key_Category;
      Symbol    : Lumen.Events.Key_Symbol;
      Modifiers : Lumen.Events.Modifier_Set
    );

  ---------------------------------------------------------------------------

  procedure Handle_Key_Release
    ( Category  : Lumen.Events.Key_Category;
      Symbol    : Lumen.Events.Key_Symbol;
      Modifiers : Lumen.Events.Modifier_Set
    );

  ---------------------------------------------------------------------------

  function New_Frame (Frame_Delta: in Duration) return Boolean;

  ---------------------------------------------------------------------------

  procedure Update;

  ---------------------------------------------------------------------------

  procedure Render (Win: in Window.Window_Handle);

  ---------------------------------------------------------------------------
  -- Initialize OpenGL and various other libraries and variables.
  procedure Init;

  ---------------------------------------------------------------------------

end Util;
