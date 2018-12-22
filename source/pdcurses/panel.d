module pdcurses.panel;

import pdcurses.curses;

/* Public Domain Curses */

/*----------------------------------------------------------------------*
 *                         Panels for PDCurses                          *
 *----------------------------------------------------------------------*/

extern (C):

struct panelobs
{
    panelobs* above;
    panel* pan;
}

alias PANELOBS = panelobs;

struct panel
{
    WINDOW* win;
    int wstarty;
    int wendy;
    int wstartx;
    int wendx;
    panel* below;
    panel* above;
    const(void)* user;
    panelobs* obscure;
}

alias PANEL = panel;

int bottom_panel (PANEL* pan);
int del_panel (PANEL* pan);
int hide_panel (PANEL* pan);
int move_panel (PANEL* pan, int starty, int startx);
PANEL* new_panel (WINDOW* win);
PANEL* panel_above (const(PANEL)* pan);
PANEL* panel_below (const(PANEL)* pan);
int panel_hidden (const(PANEL)* pan);
const(void)* panel_userptr (const(PANEL)* pan);
WINDOW* panel_window (const(PANEL)* pan);
int replace_panel (PANEL* pan, WINDOW* win);
int set_panel_userptr (PANEL* pan, const(void)* uptr);
int show_panel (PANEL* pan);
int top_panel (PANEL* pan);
void update_panels ();
