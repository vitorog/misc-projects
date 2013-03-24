#include <GL/glew.h>
#include <GL/gl.h>

#include <SDL/SDL.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>

#include <iostream>
#include <fstream>

int kScreenWidth = 1024;
int kScreenHeight = 768;
int kScreenBpp = 32;

bool InitSdl()
{
  if( SDL_Init(SDL_INIT_EVERYTHING) < 0){
    return false;
  }
  if( SDL_SetVideoMode( kScreenWidth, kScreenHeight, kScreenBpp, SDL_OPENGL) == NULL ){
    return false;
  }
  SDL_WM_SetCaption("OpenGL Screen", NULL);
}

bool InitGl()
{
  GLenum error = glewInit();
  if( error != GLEW_OK ){
    return false;
  }
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  //  glOrtho(0,kScreenWidth,0.0f, kScreenHeight, 1.0f,-1.0f);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glClearColor(0.0f,0.0f,0.0f,1.0f);

  error = glGetError();
  if(error != GL_NO_ERROR){
    return false;
  }

  const GLubyte *renderer = glGetString( GL_RENDERER );
  const GLubyte *vendor = glGetString( GL_VENDOR );
  const GLubyte *glslVersion = glGetString( GL_SHADING_LANGUAGE_VERSION );
  GLint major, minor;
  glGetIntegerv(GL_MAJOR_VERSION, &major);
  glGetIntegerv(GL_MINOR_VERSION, &minor);

  std::cout << "Vendor: " << vendor << std::endl;
  std::cout << "Renderer: " << renderer << std::endl;
  std::cout << "Version: " << major << "." << minor << std::endl;
  std::cout << "GLSL Version: " << glslVersion << std::endl;

  GLint num_extensions;
  glGetIntegerv(GL_NUM_EXTENSIONS, &num_extensions);
  for(int i = 0; i < num_extensions; i++){
    std::cout << glGetStringi( GL_EXTENSIONS, i) << std::endl;
  }

  return true;
}

GLchar* LoadShader(const std::string& path)
{
  std::ifstream shader_file;
  shader_file.open(path.c_str());
  if(shader_file.is_open()){
    std::string line;
    std::string shader_source;
    while(shader_file.good()){
      getline(shader_file, line);
      shader_source.append(line);
      shader_source.append("\n");
    }
    shader_file.close();

    GLchar* shader_source_ptr = new GLchar[shader_source.size()];
    memcpy(shader_source_ptr,shader_source.c_str(),shader_source.size());
    shader_source_ptr[shader_source.size()] = '\0'; //We can replace the last char (a \n) with the NULL-termination char.
    return shader_source_ptr;
  }
  return NULL;
}

GLuint LoadAndCompileShader(const std::string path, GLuint shader_type)
{
  GLuint shader_handler = glCreateShader( shader_type );
  if( shader_handler == 0 ){
    std::cout << "Failed to create shader." << std::endl;
    return shader_handler;
  }
  const GLchar* source = LoadShader(path);
  const GLchar* source_array[] = {source};
  std::cout << source_array[0]<< std::endl;
  if(source_array[0] == NULL){
    std::cout << "Failed to load file." << std::endl;
    return 0;
  }
  glShaderSource( shader_handler, 1, source_array, NULL);
  glCompileShader( shader_handler );
  delete source;
  GLint result;
  glGetShaderiv( shader_handler, GL_COMPILE_STATUS, &result);
  if( GL_FALSE == result ){
    std::cout << "Failed to compile shader" << std::endl;
    GLint log_length;
    glGetShaderiv( shader_handler, GL_INFO_LOG_LENGTH, &log_length);
    if(log_length > 0){
      char* log = new char[log_length];
      GLsizei written;
      glGetShaderInfoLog(shader_handler, log_length, &written, log);
      std::cout << log << std::endl;
      delete[] log;
    }
  }
  return shader_handler;
}

int main()
{
  InitSdl();
  InitGl();
  bool quit = false;
  GLuint vertex_shader = LoadAndCompileShader("/media/Vitor/Development/Projects/Github/misc-projects/glsl_cookbook/GLSL_GeneralProject/basic.vert", GL_VERTEX_SHADER );
  if( vertex_shader == 0){
    std::cout << "Failed to load vertex shader." << std::endl;
  }
  GLuint fragment_shader = LoadAndCompileShader("/media/Vitor/Development/Projects/Github/misc-projects/glsl_cookbook/GLSL_GeneralProject/basic.frag", GL_FRAGMENT_SHADER );
  if( vertex_shader == 0){
    std::cout << "Failed to load fragment shader." << std::endl;
  }

  GLuint shader_program = glCreateProgram();
  if(shader_program == 0){
    std::cout << "Error creating shader object." << std::endl;
  }
  glAttachShader( shader_program, vertex_shader );
  glAttachShader( shader_program, fragment_shader );

  glBindFragDataLocation( shader_program, 0, "frag_color");

  glBindAttribLocation( shader_program, 0, "vertex_position" );
  glBindAttribLocation( shader_program, 1, "vertex_color" );
  glBindAttribLocation( shader_program, 2 , "tex_coords" );

  GLuint vao_handle;

  float positionData[] = {
    -0.8f, -0.8f, 0.0f,
    0.8f, -0.8f, 0.0f,
    0.0f, 0.8f, 0.0f };

  float colorData[] = {
    1.0f, 0.0f, 0.0f,
    0.0f, 1.0f, 0.0f,
    0.0f, 0.0f, 1.0f };

  GLuint vbo_handles[2];
  glGenBuffers(2, vbo_handles);
  GLuint position_buffer_handle = vbo_handles[0];
  GLuint color_buffer_handle = vbo_handles[1];

  glBindBuffer(GL_ARRAY_BUFFER, position_buffer_handle );
  glBufferData(GL_ARRAY_BUFFER, 9 * sizeof(float), positionData, GL_STATIC_DRAW);

  glBindBuffer( GL_ARRAY_BUFFER, color_buffer_handle );
  glBufferData(GL_ARRAY_BUFFER, 9* sizeof(float), colorData, GL_STATIC_DRAW );

  glGenVertexArrays(1, &vao_handle);
  glBindVertexArray(vao_handle);

  glEnableVertexAttribArray(0);
  glEnableVertexAttribArray(1);

  glBindBuffer( GL_ARRAY_BUFFER, position_buffer_handle );
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, (GLubyte*)NULL );

  glBindBuffer( GL_ARRAY_BUFFER, color_buffer_handle );
  glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, (GLubyte*)NULL );


  glLinkProgram( shader_program );


  GLint status;
  glGetProgramiv( shader_program, GL_LINK_STATUS, &status );
  if( status == GL_FALSE ){
    GLint log_length;
    glGetProgramiv(shader_program, GL_INFO_LOG_LENGTH, &log_length);
    if( log_length > 0 ){
      char* log = new char[log_length];
      GLsizei written;
      glGetProgramInfoLog( shader_program, log_length, &written, log);
      std::cout << log << std::endl;
      delete[] log;
    }
  }else{
    {
      GLint max_length, num_attribs;
      glGetProgramiv( shader_program, GL_ACTIVE_ATTRIBUTES, &num_attribs );
      glGetProgramiv( shader_program, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &max_length );
      GLint written, size, location;
      GLenum type;
      GLchar *name = new char[max_length];
      for(int i = 0; i < num_attribs; i++ ){
        glGetActiveAttrib( shader_program, i, max_length, &written, &size, &type, name );
        location = glGetAttribLocation( shader_program, name );
        std::cout << "Attrib: " << name << " - Location: " << location << std::endl;
      }
      delete[] name;
    }


    {
      GLint max_length, num_attribs;
      glGetProgramiv( shader_program, GL_ACTIVE_UNIFORMS, &num_attribs );
      glGetProgramiv( shader_program, GL_ACTIVE_UNIFORM_MAX_LENGTH, &max_length );
      GLint written, size, location;
      GLenum type;
      GLchar *name = new char[max_length];
      for(int i = 0; i < num_attribs; i++ ){
        glGetActiveUniform( shader_program, i, max_length, &written, &size, &type, name );
        location = glGetUniformLocation( shader_program, name );
        std::cout << "Uniform: " << name << " - Location: " << location << std::endl;
      }
      delete[] name;
    }


    glUseProgram( shader_program );
  }

  SDL_Event event;
  while(!quit){
    while( SDL_PollEvent( &event ) )
    {
      if( event.type == SDL_QUIT )
      {
        quit = true;
      }
    }
    glm::mat4 rotation_matrix = glm::rotate(glm::mat4(1.0f), 45.0f, glm::vec3(0.0f,0.0f,1.0f));
    GLuint location = glGetUniformLocation(shader_program, "rotation_matrix");
    if(location >= 0){
      glUniformMatrix4fv(location, 1, GL_FALSE, &rotation_matrix[0][0]);
    }

    glBindVertexArray(vao_handle);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    SDL_GL_SwapBuffers();
  }
  glDeleteShader( vertex_shader );
  glDeleteShader( fragment_shader );

  SDL_Quit();
  return 0;
}

