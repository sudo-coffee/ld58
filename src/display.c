#include "SDL3/SDL_init.h"
#include "SDL3/SDL_video.h"

static int width;
static int height;

void init() {
  SDL_Init(SDL_INIT_VIDEO);
  SDL_DisplayID* ids = SDL_GetDisplays(NULL);
  const SDL_DisplayMode* displayMode = SDL_GetDesktopDisplayMode(ids[0]);
  width = displayMode->w * displayMode->pixel_density;
  height = displayMode->h * displayMode->pixel_density;
}

int getWidth() {
  return width;
}

int getHeight() {
  return height;
}
