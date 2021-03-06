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
with Lumen.Program;
with Lumen.Shader;

with Pipeline;
package body Util is

  ---------------------------------------------------------------------------

  VBO           : GL.UInt;
  IBO           : GL.UInt;
  World_Location: GL.Int;
  Scale         : Float := 0.0;

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
  Pipe: Pipeline.Pipeline;

  procedure Update
  is
  begin
    Scale := Scale + 0.1;

    Pipeline.World_Pos (Pipe, 0.0, 0.0, 5.0);
    Pipeline.Rotate
      ( Pipe,
        0.0,
        Scale,
        0.0
      );

    Pipeline.Set_Perspective
      ( Pipe,
        30.0,
        Float (Window.Width  (Win)),
        Float (Window.Height (Win)),
        1.0,
        100.0
      );
  end Update;

  ---------------------------------------------------------------------------

  procedure Render (Win: in Window.Window_Handle)
  is
    Trans: GL.Float_Matrix;
  begin
    Pipeline.Get_Trans (Pipe, Trans);

    GL.Clear (GL.GL_COLOR_BUFFER_BIT);

    GL.Uniform (World_Location, 1, GL.GL_TRUE, Trans);

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
    GL.Bind_Buffer (GL.GL_ELEMENT_ARRAY_BUFFER, IBO);

    GL.Draw_Elements
      ( GL.GL_TRIANGLES,
        12,
        GL.GL_UNSIGNED_INT,
        System'To_Address (0)
      );

    GL.Disable_Vertex_Attrib_Array (0);

    Window.Swap (Win);
  end Render;

  ---------------------------------------------------------------------------
  -- Initialize all shaders
  procedure Init_Shaders
  is

    -------------------------------------------------------------------------
    -- Helper procedure for loading and compiling shaders and checking errors.
    procedure Add_Shader
      ( Shader_Program: in GL.UInt;
        Path          : in String;
        Shader_Type   : in GL.Enum
      )
    is
      Shader_Error  : exception;
      Shader_Object : GL.UInt;
      Success       : Boolean := False;
    begin
      Shader.From_File (Shader_Type, Path, Shader_Object, Success);

      if not Success then
        raise Shader_Error with "Failed to load shader: " & Path;
      end if;

      GL.Compile_Shader (Shader_Object);
      GL.Attach_Shader  (Shader_Program, Shader_Object);
    end Add_Shader;

    -------------------------------------------------------------------------
    -- Exceptions.
    Link_Error            : exception;
    Uniform_Location_Error: exception;
    Validate_Error        : exception;
    -- Local variables.
    Shader_Program: constant GL.UInt := GL.Create_Program;
    Dir           : constant String := "src/tut12/shaders/";
    Success       : Boolean := False;

    -------------------------------------------------------------------------

  begin
    Add_Shader (Shader_Program, Dir & "triangle.vert", GL.GL_VERTEX_SHADER);
    Add_Shader (Shader_Program, Dir & "triangle.frag", GL.GL_FRAGMENT_SHADER);

    GL.Link_Program (Shader_Program);
    GL.Get_Program  (Shader_Program, GL.GL_LINK_STATUS, Success'Address);
    if not Success then
      raise Link_Error with Program.Get_Info_Log (Shader_Program);
    end if;

    GL.Validate_Program (Shader_Program);
    GL.Get_Program (Shader_Program, GL.GL_VALIDATE_STATUS, Success'Address);
    if not Success then
      raise Validate_Error with Program.Get_Info_Log (Shader_Program);
    end if;

    GL.Use_Program (Shader_Program);

    World_Location := GL.Get_Uniform_Location (Shader_Program, "World");
    if World_Location = -1 then
      raise Uniform_Location_Error with "Couldn't get location of uniform";
    end if;
  end Init_Shaders;

  ---------------------------------------------------------------------------
  -- Initialize OpenGL and various other libraries, shaders and variables.
  procedure Init
  is
  begin
    GL.Clear_Color (0.0, 0.0, 0.0, 0.0);

    Create_Vertex_Buffer: declare
      Vertices: constant array (1 .. 12) of Float :=
        ( -1.0, -1.0, 0.5773,
           0.0, -1.0, -1.15475,
           1.0, -1.0, 0.5773,
           0.0,  1.0, 0.0
        );
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

    Create_Index_Buffer: declare
      Indices: constant array (Natural range <>) of GL.UInt :=
        ( 0, 3, 1,
          1, 3, 2,
          2, 3, 0,
          0, 1, 2
        );
    begin
      GL.Gen_Buffers (1, IBO'Address);
      GL.Bind_Buffer (GL.GL_ELEMENT_ARRAY_BUFFER, IBO);
      GL.Buffer_Data
        ( GL.GL_ELEMENT_ARRAY_BUFFER,
          Indices'Length * (Float'Size / 8),
          Indices'Address,
          GL.GL_STATIC_DRAW
        );
    end Create_Index_Buffer;

    Init_Shaders;
  end Init;

  ---------------------------------------------------------------------------

end Util;
