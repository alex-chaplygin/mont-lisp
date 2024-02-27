#include <stdlib.h>
#include <SDL.h>
typedef unsigned char byte;
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200

int window_width;	/**< размеры окна */
int window_height;
byte *video_buffer;		/**< видео буфер экрана*/
SDL_Window *window;		/**< окно SDL */
SDL_Renderer *renderer;		/**< устройство вывода */
SDL_Surface *screen;		/**< поверхность экрана без курсора мыши */
byte palette[4*3] = {
    0,0,0, //черный
    0, 0xaa, 0, //зеленый
    0xaa, 0, 0, //красный
    0xaa, 0x55, 0 // коричневый
}; /**< палитра 4 цвета CGA*/

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
  SDL_Color colors[4];
  byte *dst = palette;
  for(int i = 0; i < 4; i++) {
    colors[i].r = *dst++;
    colors[i].g = *dst++;
    colors[i].b = *dst++;
  }
  if (SDL_SetPaletteColors(screen->format->palette, colors, 0, 4))
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
void video_update(byte *map, int screen_width, int screen_height, byte *tiles_data)
{
    byte *dst;
    byte *data;
    for (int j = 0; j < screen_height; j++) {
	for (int i = 0; i < screen_width; i++) {
	    dst = video_buffer + j * (SCREEN_WIDTH << 3) + (i << 3); // установка позиции в начало строчки тайлов
	    data = tiles_data + (*map++ << 4); // каждый тайл - 16 байт
	    for (int row = 0; row < 8; row++) { // цикл по строкам тайла
		for (int k = 0; k < 2; k++) { // 2 раза по 4 пикселя
		    *dst++ = *data >> 6 & 3;
		    *dst++ = *data >> 4 & 3;
		    *dst++ = *data >> 2 & 3;
		    *dst++ = *data++ & 3;
		}
		dst = dst - 8 + SCREEN_WIDTH; // возврат назад и переход на следующую строку
	    }
	    //dst = dst - (SCREEN_WIDTH << 3) + 8; // возврат вверх на 8 строк и переход на тайл справа
	}
    }
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

