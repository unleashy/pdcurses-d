import std.stdio, std.random, std.math;

import pdcurses.curses;

enum COLOR_TABLE = [
    COLOR_RED, COLOR_BLUE, COLOR_GREEN, COLOR_CYAN,
    COLOR_RED, COLOR_MAGENTA, COLOR_YELLOW, COLOR_WHITE
];

enum DELAYSIZE = 200;

void myrefresh()
{
    napms(DELAYSIZE);
    move(LINES - 1, COLS - 1);
    refresh();
}

void get_color()
{
    chtype bold = uniform(0, 1) == 1 ? A_BOLD : A_NORMAL;
    attrset(COLOR_PAIR(uniform(cast(short) 0, cast(short) 8)) | bold);
}

void explode(int row, int col)
{
    erase();
    mvaddstr(row, col, "-");
    myrefresh();

    --col;

    get_color();
    mvaddstr(row - 1, col, " - ");
    mvaddstr(row,     col, "-+-");
    mvaddstr(row + 1, col, " - ");
    myrefresh();

    --col;

    get_color();
    mvaddstr(row - 2, col, " --- ");
    mvaddstr(row - 1, col, "-+++-");
    mvaddstr(row,     col, "-+#+-");
    mvaddstr(row + 1, col, "-+++-");
    mvaddstr(row + 2, col, " --- ");
    myrefresh();

    get_color();
    mvaddstr(row - 2, col, " +++ ");
    mvaddstr(row - 1, col, "++#++");
    mvaddstr(row,     col, "+# #+");
    mvaddstr(row + 1, col, "++#++");
    mvaddstr(row + 2, col, " +++ ");
    myrefresh();

    get_color();
    mvaddstr(row - 2, col, "  #  ");
    mvaddstr(row - 1, col, "## ##");
    mvaddstr(row,     col, "#   #");
    mvaddstr(row + 1, col, "## ##");
    mvaddstr(row + 2, col, "  #  ");
    myrefresh();

    get_color();
    mvaddstr(row - 2, col, " # # ");
    mvaddstr(row - 1, col, "#   #");
    mvaddstr(row,     col, "     ");
    mvaddstr(row + 1, col, "#   #");
    mvaddstr(row + 2, col, " # # ");
    myrefresh();
}

void main()
{
	initscr();
    scope(exit) endwin();
    
    nodelay(stdscr, true);
    noecho();
    
    if (has_colors()) start_color();
    
    foreach (short i, color; COLOR_TABLE) {
        init_pair(i, color, COLOR_BLACK);
    }
    
    int start, end, diff, row, flag, direction;
    
    while (getch() == ERR) {
        do {
            start = uniform(0, COLS - 3);
            end = uniform(0, COLS - 3);
            start = (start < 2) ? 2 : start;
            end = (end < 2) ? 2 : end;
            direction = (start > end) ? -1 : 1;
            diff = abs(start - end);
        } while (diff < 2 || diff >= LINES - 2);

        attrset(A_NORMAL);

        foreach (r; 0 .. diff) {
            mvaddstr(LINES - r, r * direction + start, (direction < 0) ? "\\" : "/");
            
            if (flag++) {
                myrefresh();
                erase();
                flag = 0;
            }
            
            row = r;
        }
        
        if (flag++) {
            myrefresh();
            flag = 0;
        }

        explode(LINES - row, diff * direction + start);
        erase();
        myrefresh();
    }
}
