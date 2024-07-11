#include <stdlib.h>
#include <SDL.h>

typedef unsigned char byte;

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200
#define NUM_COLORS 16

int window_width;	/**< размеры окна */
int window_height;
byte *video_buffer;		/**< видео буфер экрана*/
SDL_Window *window;		/**< окно SDL */
SDL_Renderer *renderer;		/**< устройство вывода */
SDL_Surface *screen;		/**< поверхность экрана без курсора мыши */

byte palette[NUM_COLORS * 3] = {
    0, 0, 0, //черный
    255, 255, 255,
    136, 0, 0, //красный
    170, 255, 238,
    204, 68, 204,
    0, 204, 85, //зеленый
    0, 0, 170,
    238, 238, 119,
    221, 136, 85,
    102, 68, 0, // коричневый
    255, 119, 119,
    51, 51, 51,
    119, 119, 119,
    170, 255, 102,
    0, 136, 255,
    187, 187, 187
}; /**< палитра */

/** 
 * вывод сообщения об ошибке, аварийный выход
 *
 * @param str сообщение
 */
void error(const char *str)
{
    printf("%s\n", str);
    exit(1);
}

/** 
 * Установка палитры
 */
void set_palette()
{
  SDL_Color colors[NUM_COLORS];
  byte *dst = palette;
  for(int i = 0; i < NUM_COLORS; i++) {
    colors[i].r = *dst++;
    colors[i].g = *dst++;
    colors[i].b = *dst++;
  }
  if (SDL_SetPaletteColors(screen->format->palette, colors, 0, NUM_COLORS))
    error("set palette error");
}

/** 
 * Инициализация графического интерфейса
 */
void video_init(int scale)
{
  window_width = SCREEN_WIDTH * scale;
  window_height = SCREEN_HEIGHT * scale;
  SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS);
  window = SDL_CreateWindow("MONTEZUMA", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, window_width, window_height, SDL_WINDOW_SHOWN);
  if (window == NULL)
    error("Cannot create window");
  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
  if (renderer == NULL)
    error("Cannot create renderer");
  SDL_ShowCursor(SDL_DISABLE);
  screen = SDL_CreateRGBSurface(0, SCREEN_WIDTH, SCREEN_HEIGHT, 8, 0, 0, 0, 0);
  set_palette();
  SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1");
  SDL_LockSurface(screen);
  video_buffer = screen->pixels;
}

/// Обработка событий клавиатуры и мыши
int video_get_events()
{
  SDL_Event e;
  if (SDL_PollEvent(&e)) {
    if (e.type == SDL_QUIT)
      return 0;
    /*   else if (e.type == SDL_KEYDOWN)
      set_key(e.key.keysym.scancode, 1);
    else if (e.type == SDL_KEYUP)
    set_key(e.key.keysym.scancode, 0);*/
  }
  return 1;
}

/** 
 * Обновление графики.
 * Отрисовка экранного буфера.
 */
void video_update(byte *buf)
{
    memcpy(video_buffer, buf, SCREEN_WIDTH * SCREEN_HEIGHT);
    SDL_UnlockSurface(screen);
    SDL_Texture* t = SDL_CreateTextureFromSurface(renderer, screen);
    SDL_RenderCopy(renderer, t, NULL, NULL);
    SDL_DestroyTexture(t);
    SDL_RenderPresent(renderer);
    SDL_LockSurface(screen);
    video_buffer = screen->pixels;
}

/** 
 * Завершение графики, закрытие окна
 */
void video_close()
{
  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);
  SDL_Quit();
}

/// Ожидание одного кадра
void video_sleep(long l)
{
    SDL_Delay(l);
}

