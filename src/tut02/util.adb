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
with System;

with Lumen.GL;
package body Util is

  ---------------------------------------------------------------------------

  VBO: GL.UInt;

  ---------------------------------------------------------------------------
  -- Terminate application.
  Terminated            : Boolean := False;

  ---------------------------------------------------------------------------

  procedure Handle_Key_Press
    ( Category  : Lumen.Events.Key_Category;
      Symbol    : Lumen.Events.Key_Symbol;
      Modifiers : Lumen.Events.Modifier_Set
    )
  is
    pragma Unreferenced (Modifiers);
  begin
    case Category is
      when Events.Key_Control .. Events.Key_Graphic =>
        declare
          C: constant Character := Events.To_Character (Symbol);
        begin
          case C is
            when ASCII.ESC  => Terminated := True;
            when others     => null;
          end case;
        end;
      when others => null;
    end case;
  end Handle_Key_Press;

  ---------------------------------------------------------------------------

  procedure Handle_Key_Release
    ( Category  : Lumen.Events.Key_Category;
      Symbol    : Lumen.Events.Key_Symbol;
      Modifiers : Lumen.Events.Modifier_Set
    )
  is
    pragma Unreferenced (Category);
    pragma Unreferenced (Symbol);
    pragma Unreferenced (Modifiers);
  begin
    null;
  end Handle_Key_Release;

  ---------------------------------------------------------------------------

  function New_Frame (Frame_Delta: in Duration) return Boolean
  is
    pragma Unreferenced (Frame_Delta);
  begin
    Update;
    Render (Win);

    return not Terminated;
  end New_Frame;

  ---------------------------------------------------------------------------

  procedure Update
  is
  begin
    null;
  end Update;

  ---------------------------------------------------------------------------

  procedure Render (Win: in Window.Window_Handle)
  is
  begin
    GL.Clear (GL.GL_COLOR_BUFFER_BIT);

    GL.Enable_Vertex_Attrib_Array (0);
    GL.Bind_Buffer (GL.GL_ARRAY_BUFFER, VBO);
    GL.Vertex_Attrib_Pointer
      ( 0,
        3,
        GL.GL_FLOAT,
        GL.GL_FALSE,
        0,
        System'To_Address (0)
      );

    GL.Draw_Arrays (GL.GL_POINTS, 0, 1);

    GL.Disable_Vertex_Attrib_Array (0);

    Window.Swap (Win);
  end Render;

  ---------------------------------------------------------------------------
  -- Initialize OpenGL and various other libraries and variables.
  procedure Init
  is
  begin
    GL.Clear_Color (0.0, 0.0, 0.0, 0.0);

    Create_Vertex_Buffer: declare
      Vertices: constant array (0 .. 2) of Float := (0.0, 0.0, 0.0);
    begin
      GL.Gen_Buffers (1, VBO'Address);
      GL.Bind_Buffer (GL.GL_ARRAY_BUFFER, VBO);
      GL.Buffer_Data
        ( GL.GL_ARRAY_BUFFER,
          Vertices'Length * (Float'Size / 8),
          Vertices'Address,
          GL.GL_STATIC_DRAW
        );
    end Create_Vertex_Buffer;
  end Init;

  ---------------------------------------------------------------------------

end Util;
