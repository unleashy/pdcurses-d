// curses.h -> curses.d with dstep, adjusted by unleashy //
module pdcurses.curses;

/* Public Domain Curses */

/* $Id: curses.h,v 1.295 2008/07/15 17:13:25 wmcbrine Exp $ */

/*----------------------------------------------------------------------*
 *                              PDCurses                                *
 *----------------------------------------------------------------------*/

import core.stdc.config,
       core.stdc.stdio,
       core.stdc.stdarg;

extern (C) nothrow:

enum __PDCURSES__ = 1;

/*man-start**************************************************************

PDCurses definitions list:  (Only define those needed)

    XCURSES         True if compiling for X11.
    PDC_RGB         True if you want to use RGB color definitions
                    (Red = 1, Green = 2, Blue = 4) instead of BGR.
    PDC_WIDE        True if building wide-character support.
    PDC_DLL_BUILD   True if building a Win32 DLL.
    NCURSES_MOUSE_VERSION   Use the ncurses mouse API instead
                            of PDCurses' traditional mouse API.

PDCurses portable platform definitions list:

    PDC_BUILD       Defines API build version.
    PDCURSES        Enables access to PDCurses-only routines.
    XOPEN           Always true.
    SYSVcurses      True if you are compiling for SYSV portability.
    BSDcurses       True if you are compiling for BSD portability.

**man-end****************************************************************/

enum PDC_BUILD = 3401;

version = PDCURSES;    /* PDCurses-only routines */
version = XOPEN;       /* X/Open Curses routines */
version = SYSVcurses;  /* System V Curses routines */
version = BSDcurses;   /* BSD Curses routines */
version = CHTYPE_LONG; /* size of chtype; long */

/*----------------------------------------------------------------------*/

/* Required by X/Open usage below */

/*----------------------------------------------------------------------
 *
 *  PDCurses Manifest Constants
 *
 */

enum ERR = -1;
enum OK = 0;

/*----------------------------------------------------------------------
 *
 *  PDCurses Type Declarations
 *
 */

alias chtype = c_ulong; /* 16-bit attr + 16-bit char */

alias attr_t = chtype;

/*----------------------------------------------------------------------
 *
 *  PDCurses Mouse Interface -- SYSVR4, with extensions
 *
 */

struct MOUSE_STATUS
{
    int x; /* absolute column, 0 based, measured in characters */
    int y; /* absolute row, 0 based, measured in characters */
    short[3] button; /* state of each button */
    int changes; /* flags indicating what has changed with the mouse */
}

enum BUTTON_RELEASED       = 0x0000;
enum BUTTON_PRESSED        = 0x0001;
enum BUTTON_CLICKED        = 0x0002;
enum BUTTON_DOUBLE_CLICKED = 0x0003;
enum BUTTON_TRIPLE_CLICKED = 0x0004;
enum BUTTON_MOVED          = 0x0005; /* PDCurses */
enum WHEEL_SCROLLED        = 0x0006; /* PDCurses */
enum BUTTON_ACTION_MASK    = 0x0007; /* PDCurses */

enum PDC_BUTTON_SHIFT     = 0x0008; /* PDCurses */
enum PDC_BUTTON_CONTROL   = 0x0010; /* PDCurses */
enum PDC_BUTTON_ALT       = 0x0020; /* PDCurses */
enum BUTTON_MODIFIER_MASK = 0x0038; /* PDCurses */

extern (D) pragma (inline, true)
auto MOUSE_X_POS()
{
    return Mouse_status.x;
}

extern (D) pragma (inline, true)
auto MOUSE_Y_POS()
{
    return Mouse_status.y;
}

/*
 * Bits associated with the .changes field:
 *   3         2         1         0
 * 210987654321098765432109876543210
 *                                 1 <- button 1 has changed
 *                                10 <- button 2 has changed
 *                               100 <- button 3 has changed
 *                              1000 <- mouse has moved
 *                             10000 <- mouse position report
 *                            100000 <- mouse wheel up
 *                           1000000 <- mouse wheel down
 */

enum PDC_MOUSE_MOVED      = 0x0008;
enum PDC_MOUSE_POSITION   = 0x0010;
enum PDC_MOUSE_WHEEL_UP   = 0x0020;
enum PDC_MOUSE_WHEEL_DOWN = 0x0040;

extern (D) pragma (inline, true)
auto A_BUTTON_CHANGED()
{
    return Mouse_status.changes & 7;
}

extern (D) pragma (inline, true)
auto MOUSE_MOVED()
{
    return Mouse_status.changes & PDC_MOUSE_MOVED;
}

extern (D) pragma (inline, true)
auto MOUSE_POS_REPORT()
{
    return Mouse_status.changes & PDC_MOUSE_POSITION;
}

extern (D) pragma (inline, true)
auto BUTTON_CHANGED(T)(auto ref T x)
{
    return Mouse_status.changes & (1 << (x - 1));
}

extern (D) pragma (inline, true)
auto BUTTON_STATUS(T)(auto ref T x)
{
    return Mouse_status.button[x - 1];
}

extern (D) pragma (inline, true)
auto MOUSE_WHEEL_UP()
{
    return Mouse_status.changes & PDC_MOUSE_WHEEL_UP;
}

extern (D) pragma (inline, true)
auto MOUSE_WHEEL_DOWN()
{
    return Mouse_status.changes & PDC_MOUSE_WHEEL_DOWN;
}

/* mouse bit-masks */

enum BUTTON1_RELEASED       = 0x00000001L;
enum BUTTON1_PRESSED        = 0x00000002L;
enum BUTTON1_CLICKED        = 0x00000004L;
enum BUTTON1_DOUBLE_CLICKED = 0x00000008L;
enum BUTTON1_TRIPLE_CLICKED = 0x00000010L;
enum BUTTON1_MOVED          = 0x00000010L; /* PDCurses */

enum BUTTON2_RELEASED       = 0x00000020L;
enum BUTTON2_PRESSED        = 0x00000040L;
enum BUTTON2_CLICKED        = 0x00000080L;
enum BUTTON2_DOUBLE_CLICKED = 0x00000100L;
enum BUTTON2_TRIPLE_CLICKED = 0x00000200L;
enum BUTTON2_MOVED          = 0x00000200L; /* PDCurses */

enum BUTTON3_RELEASED       = 0x00000400L;
enum BUTTON3_PRESSED        = 0x00000800L;
enum BUTTON3_CLICKED        = 0x00001000L;
enum BUTTON3_DOUBLE_CLICKED = 0x00002000L;
enum BUTTON3_TRIPLE_CLICKED = 0x00004000L;
enum BUTTON3_MOVED          = 0x00004000L; /* PDCurses */

/* For the ncurses-compatible functions only, BUTTON4_PRESSED and
   BUTTON5_PRESSED are returned for mouse scroll wheel up and down;
   otherwise PDCurses doesn't support buttons 4 and 5 */

enum BUTTON4_RELEASED       = 0x00008000L;
enum BUTTON4_PRESSED        = 0x00010000L;
enum BUTTON4_CLICKED        = 0x00020000L;
enum BUTTON4_DOUBLE_CLICKED = 0x00040000L;
enum BUTTON4_TRIPLE_CLICKED = 0x00080000L;

enum BUTTON5_RELEASED       = 0x00100000L;
enum BUTTON5_PRESSED        = 0x00200000L;
enum BUTTON5_CLICKED        = 0x00400000L;
enum BUTTON5_DOUBLE_CLICKED = 0x00800000L;
enum BUTTON5_TRIPLE_CLICKED = 0x01000000L;

enum MOUSE_WHEEL_SCROLL      = 0x02000000L; /* PDCurses */
enum BUTTON_MODIFIER_SHIFT   = 0x04000000L; /* PDCurses */
enum BUTTON_MODIFIER_CONTROL = 0x08000000L; /* PDCurses */
enum BUTTON_MODIFIER_ALT     = 0x10000000L; /* PDCurses */

enum ALL_MOUSE_EVENTS      = 0x1fffffffL;
enum REPORT_MOUSE_POSITION = 0x20000000L;

/* ncurses mouse interface */

alias mmask_t = c_ulong;

struct MEVENT
{
    short id;       /* unused, always 0 */
    int x;
    int y;
    int z;          /* x, y same as MOUSE_STATUS; z unused */
    mmask_t bstate; /* equivalent to changes + button[], but
                       in the same format as used for mousemask() */
}

enum BUTTON_SHIFT   = PDC_BUTTON_SHIFT;
enum BUTTON_CONTROL = PDC_BUTTON_CONTROL;
enum BUTTON_ALT     = PDC_BUTTON_ALT;

/*----------------------------------------------------------------------
 *
 *  PDCurses Structure Definitions
 *
 */

struct _win               /* definition of a window */
{
    int      _cury;       /* current pseudo-cursor */
    int      _curx;
    int      _maxy;       /* max window coordinates */
    int      _maxx;
    int      _begy;       /* origin on screen */
    int      _begx;
    int      _flags;      /* window properties */
    chtype   _attrs;      /* standard attributes and colors */
    chtype   _bkgd;       /* background, normally blank */
    bool     _clear;      /* causes clear at next refresh */
    bool     _leaveit;    /* leaves cursor where it is */
    bool     _scroll;     /* allows window scrolling */
    bool     _nodelay;    /* input character wait flag */
    bool     _immed;      /* immediate update flag */
    bool     _sync;       /* synchronise window ancestors */
    bool     _use_keypad; /* flags keypad key mode active */
    chtype** _y;          /* pointer to line pointer array */
    int*     _firstch;    /* first changed character in line */
    int*     _lastch;     /* last changed character in line */
    int      _tmarg;      /* top of scrolling region */
    int      _bmarg;      /* bottom of scrolling region */
    int      _delayms;    /* milliseconds of delay for getch() */
    int      _parx;
    int      _pary;       /* coords relative to parent (0,0) */
    _win*    _parent;     /* subwin's pointer to parent win */
}

alias WINDOW = _win;

/* Avoid using the SCREEN struct directly -- use the corresponding
   functions if possible. This struct may eventually be made private. */

struct SCREEN
{
    bool  alive;       /* if initscr() called, and not endwin() */
    bool  autocr;      /* if cr -> lf */
    bool  cbreak;      /* if terminal unbuffered */
    bool  echo;        /* if terminal echo */
    bool  raw_inp;     /* raw input mode (v. cooked input) */
    bool  raw_out;     /* raw output mode (7 v. 8 bits) */
    bool  audible;     /* FALSE if the bell is visual */
    bool  mono;        /* TRUE if current screen is mono */
    bool  resized;     /* TRUE if TERM has been resized */
    bool  orig_attr;   /* TRUE if we have the original colors */
    short orig_fore;   /* original screen foreground color */
    short orig_back;   /* original screen foreground color */
    int   cursrow;     /* position of physical cursor */
    int   curscol;     /* position of physical cursor */
    int   visibility;  /* visibility of cursor */
    int   orig_cursor; /* original cursor size */
    int   lines;       /* new value for LINES */
    int   cols;        /* new value for COLS */
    c_ulong _trap_mbe;         /* trap these mouse button events */
    c_ulong _map_mbe_to_key;   /* map mouse buttons to slk */
    int     mouse_wait;        /* time to wait (in ms) for a
                                  button release after a press, in
                                  order to count it as a click */
    int     slklines;          /* lines in use by slk_init() */
    WINDOW* slk_winptr;        /* window for slk */
    int linesrippedoff;        /* lines ripped off via ripoffline() */
    int linesrippedoffontop;   /* lines ripped off on
                                  top via ripoffline() */
    int delaytenths;           /* 1/10ths second to wait block
                                  getch() for */
    bool _preserve;            /* TRUE if screen background
                                  to be preserved */
    int _restore;              /* specifies if screen background
                                  to be restored, and how */
    bool save_key_modifiers;   /* TRUE if each key modifiers saved
                                  with each key press */
    bool return_key_modifiers; /* TRUE if modifier keys are
                                  returned as "real" keys */
    bool key_code;             /* TRUE if last key is a special key;
                                  used internally by get_wch() */

    version (XCURSES) {
        int   XcurscrSize;    /* size of Xcurscr shared memory block */
        bool  sb_on;
        int   sb_viewport_y;
        int   sb_viewport_x;
        int   sb_total_y;
        int   sb_total_x;
        int   sb_cur_y;
        int   sb_cur_x;
    }

    short line_color; /* color of line attributes - default -1 */
}

/*----------------------------------------------------------------------
 *
 *  PDCurses External Variables
 *
 */

extern __gshared int          LINES;        /* terminal height */
extern __gshared int          COLS;         /* terminal width */
extern __gshared WINDOW*      stdscr;       /* the default screen window */
extern __gshared WINDOW*      curscr;       /* the current screen image */
extern __gshared SCREEN*      SP;           /* curses variables */
extern __gshared MOUSE_STATUS Mouse_status;
extern __gshared int          COLORS;
extern __gshared int          COLOR_PAIRS;
extern __gshared int          TABSIZE;
extern __gshared chtype[]     acs_map;      /* alternate character set map */
extern __gshared char[]       ttytype;      /* terminal name/description */

/*man-start**************************************************************

PDCurses Text Attributes
========================

Originally, PDCurses used a short (16 bits) for its chtype. To include
color, a number of things had to be sacrificed from the strict Unix and
System V support. The main problem was fitting all character attributes
and color into an unsigned char (all 8 bits!).

Today, PDCurses by default uses a long (32 bits) for its chtype, as in
System V. The short chtype is still available, by undefining CHTYPE_LONG
and rebuilding the library.

The following is the structure of a win->_attrs chtype:

short form:

-------------------------------------------------
|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
-------------------------------------------------
  color number |  attrs |   character eg 'a'

The available non-color attributes are bold, reverse and blink. Others
have no effect. The high order char is an index into an array of
physical colors (defined in color.c) -- 32 foreground/background color
pairs (5 bits) plus 3 bits for other attributes.

long form:

----------------------------------------------------------------------------
|31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|..| 3| 2| 1| 0|
----------------------------------------------------------------------------
      color number      |     modifiers         |      character eg 'a'

The available non-color attributes are bold, underline, invisible,
right-line, left-line, protect, reverse and blink. 256 color pairs (8
bits), 8 bits for other attributes, and 16 bits for character data.

**man-end****************************************************************/

/*** Video attribute macros ***/

enum A_NORMAL     = cast(chtype) 0;

enum A_ALTCHARSET = cast(chtype) 0x00010000;
enum A_RIGHTLINE  = cast(chtype) 0x00020000;
enum A_LEFTLINE   = cast(chtype) 0x00040000;
enum A_INVIS      = cast(chtype) 0x00080000;
enum A_UNDERLINE  = cast(chtype) 0x00100000;
enum A_REVERSE    = cast(chtype) 0x00200000;
enum A_BLINK      = cast(chtype) 0x00400000;
enum A_BOLD       = cast(chtype) 0x00800000;

enum A_ATTRIBUTES = cast(chtype) 0xffff0000;
enum A_CHARTEXT   = cast(chtype) 0x0000ffff;
enum A_COLOR      = cast(chtype) 0xff000000;

enum A_ITALIC     = A_INVIS;
enum A_PROTECT    = A_UNDERLINE | A_LEFTLINE | A_RIGHTLINE;

enum PDC_ATTR_SHIFT  = 19;
enum PDC_COLOR_SHIFT = 24;

enum A_STANDOUT = A_REVERSE | A_BOLD; /* X/Open */
enum A_DIM      = A_NORMAL;

enum CHR_MSK = A_CHARTEXT; /* Obsolete */
enum ATR_MSK = A_ATTRIBUTES; /* Obsolete */
enum ATR_NRM = A_NORMAL; /* Obsolete */

/* For use with attr_t -- X/Open says, "these shall be distinct", so
   this is a non-conforming implementation. */

enum WA_ALTCHARSET = A_ALTCHARSET;
enum WA_BLINK      = A_BLINK;
enum WA_BOLD       = A_BOLD;
enum WA_DIM        = A_DIM;
enum WA_INVIS      = A_INVIS;
enum WA_LEFT       = A_LEFTLINE;
enum WA_PROTECT    = A_PROTECT;
enum WA_REVERSE    = A_REVERSE;
enum WA_RIGHT      = A_RIGHTLINE;
enum WA_STANDOUT   = A_STANDOUT;
enum WA_UNDERLINE  = A_UNDERLINE;

enum WA_HORIZONTAL = A_NORMAL;
enum WA_LOW        = A_NORMAL;
enum WA_TOP        = A_NORMAL;
enum WA_VERTICAL   = A_NORMAL;

/*** Alternate character set macros ***/

/* 'w' = 32-bit chtype; acs_map[] index | A_ALTCHARSET
   'n' = 16-bit chtype; it gets the fallback set because no bit is
         available for A_ALTCHARSET */

extern (D) pragma (inline, true)
auto ACS_PICK(T0, T1)(auto ref T0 w, auto ref T1 n)
{
    return cast(chtype) w | A_ALTCHARSET;
}

/* VT100-compatible symbols -- box chars */

enum ACS_ULCORNER = ACS_PICK('l', '+');
enum ACS_LLCORNER = ACS_PICK('m', '+');
enum ACS_URCORNER = ACS_PICK('k', '+');
enum ACS_LRCORNER = ACS_PICK('j', '+');
enum ACS_RTEE     = ACS_PICK('u', '+');
enum ACS_LTEE     = ACS_PICK('t', '+');
enum ACS_BTEE     = ACS_PICK('v', '+');
enum ACS_TTEE     = ACS_PICK('w', '+');
enum ACS_HLINE    = ACS_PICK('q', '-');
enum ACS_VLINE    = ACS_PICK('x', '|');
enum ACS_PLUS     = ACS_PICK('n', '+');

/* VT100-compatible symbols -- other */

enum ACS_S1      = ACS_PICK('o', '-');
enum ACS_S9      = ACS_PICK('s', '_');
enum ACS_DIAMOND = ACS_PICK('`', '+');
enum ACS_CKBOARD = ACS_PICK('a', ':');
enum ACS_DEGREE  = ACS_PICK('f', '\'');
enum ACS_PLMINUS = ACS_PICK('g', '#');
enum ACS_BULLET  = ACS_PICK('~', 'o');

/* Teletype 5410v1 symbols -- these are defined in SysV curses, but
   are not well-supported by most terminals. Stick to VT100 characters
   for optimum portability. */

enum ACS_LARROW  = ACS_PICK(',', '<');
enum ACS_RARROW  = ACS_PICK('+', '>');
enum ACS_DARROW  = ACS_PICK('.', 'v');
enum ACS_UARROW  = ACS_PICK('-', '^');
enum ACS_BOARD   = ACS_PICK('h', '#');
enum ACS_LANTERN = ACS_PICK('i', '*');
enum ACS_BLOCK   = ACS_PICK('0', '#');

/* That goes double for these -- undocumented SysV symbols. Don't use
   them. */

enum ACS_S3       = ACS_PICK('p', '-');
enum ACS_S7       = ACS_PICK('r', '-');
enum ACS_LEQUAL   = ACS_PICK('y', '<');
enum ACS_GEQUAL   = ACS_PICK('z', '>');
enum ACS_PI       = ACS_PICK('{', 'n');
enum ACS_NEQUAL   = ACS_PICK('|', '+');
enum ACS_STERLING = ACS_PICK('}', 'L');

/* Box char aliases */

enum ACS_BSSB = ACS_ULCORNER;
enum ACS_SSBB = ACS_LLCORNER;
enum ACS_BBSS = ACS_URCORNER;
enum ACS_SBBS = ACS_LRCORNER;
enum ACS_SBSS = ACS_RTEE;
enum ACS_SSSB = ACS_LTEE;
enum ACS_SSBS = ACS_BTEE;
enum ACS_BSSS = ACS_TTEE;
enum ACS_BSBS = ACS_HLINE;
enum ACS_SBSB = ACS_VLINE;
enum ACS_SSSS = ACS_PLUS;

/* cchar_t aliases */

/*** Color macros ***/

enum short COLOR_BLACK = 0;

version (PDC_RGB) {
    /* RGB */
    enum short COLOR_RED   = 1;
    enum short COLOR_GREEN = 2;
    enum short COLOR_BLUE  = 4;
} else {
    /* BGR */
    enum short COLOR_BLUE  = 1;
    enum short COLOR_GREEN = 2;
    enum short COLOR_RED   = 4;
}

enum short COLOR_CYAN    = COLOR_BLUE | COLOR_GREEN;
enum short COLOR_MAGENTA = COLOR_RED | COLOR_BLUE;
enum short COLOR_YELLOW  = COLOR_RED | COLOR_GREEN;

enum short COLOR_WHITE = 7;

/*----------------------------------------------------------------------
 *
 *  Function and Keypad Key Definitions.
 *  Many are just for compatibility.
 *
 */

enum KEY_CODE_YES = 0x100; /* If get_wch() gives a key code */

enum KEY_BREAK     = 0x101; /* Not on PC KBD */
enum KEY_DOWN      = 0x102; /* Down arrow key */
enum KEY_UP        = 0x103; /* Up arrow key */
enum KEY_LEFT      = 0x104; /* Left arrow key */
enum KEY_RIGHT     = 0x105; /* Right arrow key */
enum KEY_HOME      = 0x106; /* home key */
enum KEY_BACKSPACE = 0x107; /* not on pc */
enum KEY_F0        = 0x108; /* function keys; 64 reserved */

enum KEY_DL        = 0x148; /* delete line */
enum KEY_IL        = 0x149; /* insert line */
enum KEY_DC        = 0x14a; /* delete character */
enum KEY_IC        = 0x14b; /* insert char or enter ins mode */
enum KEY_EIC       = 0x14c; /* exit insert char mode */
enum KEY_CLEAR     = 0x14d; /* clear screen */
enum KEY_EOS       = 0x14e; /* clear to end of screen */
enum KEY_EOL       = 0x14f; /* clear to end of line */
enum KEY_SF        = 0x150; /* scroll 1 line forward */
enum KEY_SR        = 0x151; /* scroll 1 line back (reverse) */
enum KEY_NPAGE     = 0x152; /* next page */
enum KEY_PPAGE     = 0x153; /* previous page */
enum KEY_STAB      = 0x154; /* set tab */
enum KEY_CTAB      = 0x155; /* clear tab */
enum KEY_CATAB     = 0x156; /* clear all tabs */
enum KEY_ENTER     = 0x157; /* enter or send (unreliable) */
enum KEY_SRESET    = 0x158; /* soft/reset (partial/unreliable) */
enum KEY_RESET     = 0x159; /* reset/hard reset (unreliable) */
enum KEY_PRINT     = 0x15a; /* print/copy */
enum KEY_LL        = 0x15b; /* home down/bottom (lower left) */
enum KEY_ABORT     = 0x15c; /* abort/terminate key (any) */
enum KEY_SHELP     = 0x15d; /* short help */
enum KEY_LHELP     = 0x15e; /* long help */
enum KEY_BTAB      = 0x15f; /* Back tab key */
enum KEY_BEG       = 0x160; /* beg(inning) key */
enum KEY_CANCEL    = 0x161; /* cancel key */
enum KEY_CLOSE     = 0x162; /* close key */
enum KEY_COMMAND   = 0x163; /* cmd (command) key */
enum KEY_COPY      = 0x164; /* copy key */
enum KEY_CREATE    = 0x165; /* create key */
enum KEY_END       = 0x166; /* end key */
enum KEY_EXIT      = 0x167; /* exit key */
enum KEY_FIND      = 0x168; /* find key */
enum KEY_HELP      = 0x169; /* help key */
enum KEY_MARK      = 0x16a; /* mark key */
enum KEY_MESSAGE   = 0x16b; /* message key */
enum KEY_MOVE      = 0x16c; /* move key */
enum KEY_NEXT      = 0x16d; /* next object key */
enum KEY_OPEN      = 0x16e; /* open key */
enum KEY_OPTIONS   = 0x16f; /* options key */
enum KEY_PREVIOUS  = 0x170; /* previous object key */
enum KEY_REDO      = 0x171; /* redo key */
enum KEY_REFERENCE = 0x172; /* ref(erence) key */
enum KEY_REFRESH   = 0x173; /* refresh key */
enum KEY_REPLACE   = 0x174; /* replace key */
enum KEY_RESTART   = 0x175; /* restart key */
enum KEY_RESUME    = 0x176; /* resume key */
enum KEY_SAVE      = 0x177; /* save key */
enum KEY_SBEG      = 0x178; /* shifted beginning key */
enum KEY_SCANCEL   = 0x179; /* shifted cancel key */
enum KEY_SCOMMAND  = 0x17a; /* shifted command key */
enum KEY_SCOPY     = 0x17b; /* shifted copy key */
enum KEY_SCREATE   = 0x17c; /* shifted create key */
enum KEY_SDC       = 0x17d; /* shifted delete char key */
enum KEY_SDL       = 0x17e; /* shifted delete line key */
enum KEY_SELECT    = 0x17f; /* select key */
enum KEY_SEND      = 0x180; /* shifted end key */
enum KEY_SEOL      = 0x181; /* shifted clear line key */
enum KEY_SEXIT     = 0x182; /* shifted exit key */
enum KEY_SFIND     = 0x183; /* shifted find key */
enum KEY_SHOME     = 0x184; /* shifted home key */
enum KEY_SIC       = 0x185; /* shifted input key */

enum KEY_SLEFT     = 0x187; /* shifted left arrow key */
enum KEY_SMESSAGE  = 0x188; /* shifted message key */
enum KEY_SMOVE     = 0x189; /* shifted move key */
enum KEY_SNEXT     = 0x18a; /* shifted next key */
enum KEY_SOPTIONS  = 0x18b; /* shifted options key */
enum KEY_SPREVIOUS = 0x18c; /* shifted prev key */
enum KEY_SPRINT    = 0x18d; /* shifted print key */
enum KEY_SREDO     = 0x18e; /* shifted redo key */
enum KEY_SREPLACE  = 0x18f; /* shifted replace key */
enum KEY_SRIGHT    = 0x190; /* shifted right arrow */
enum KEY_SRSUME    = 0x191; /* shifted resume key */
enum KEY_SSAVE     = 0x192; /* shifted save key */
enum KEY_SSUSPEND  = 0x193; /* shifted suspend key */
enum KEY_SUNDO     = 0x194; /* shifted undo key */
enum KEY_SUSPEND   = 0x195; /* suspend key */
enum KEY_UNDO      = 0x196; /* undo key */

/* PDCurses-specific key definitions -- PC only */

enum ALT_0 = 0x197;
enum ALT_1 = 0x198;
enum ALT_2 = 0x199;
enum ALT_3 = 0x19a;
enum ALT_4 = 0x19b;
enum ALT_5 = 0x19c;
enum ALT_6 = 0x19d;
enum ALT_7 = 0x19e;
enum ALT_8 = 0x19f;
enum ALT_9 = 0x1a0;
enum ALT_A = 0x1a1;
enum ALT_B = 0x1a2;
enum ALT_C = 0x1a3;
enum ALT_D = 0x1a4;
enum ALT_E = 0x1a5;
enum ALT_F = 0x1a6;
enum ALT_G = 0x1a7;
enum ALT_H = 0x1a8;
enum ALT_I = 0x1a9;
enum ALT_J = 0x1aa;
enum ALT_K = 0x1ab;
enum ALT_L = 0x1ac;
enum ALT_M = 0x1ad;
enum ALT_N = 0x1ae;
enum ALT_O = 0x1af;
enum ALT_P = 0x1b0;
enum ALT_Q = 0x1b1;
enum ALT_R = 0x1b2;
enum ALT_S = 0x1b3;
enum ALT_T = 0x1b4;
enum ALT_U = 0x1b5;
enum ALT_V = 0x1b6;
enum ALT_W = 0x1b7;
enum ALT_X = 0x1b8;
enum ALT_Y = 0x1b9;
enum ALT_Z = 0x1ba;

enum CTL_LEFT  = 0x1bb; /* Control-Left-Arrow */
enum CTL_RIGHT = 0x1bc;
enum CTL_PGUP  = 0x1bd;
enum CTL_PGDN  = 0x1be;
enum CTL_HOME  = 0x1bf;
enum CTL_END   = 0x1c0;

enum KEY_A1 = 0x1c1; /* upper left on Virtual keypad */
enum KEY_A2 = 0x1c2; /* upper middle on Virt. keypad */
enum KEY_A3 = 0x1c3; /* upper right on Vir. keypad */
enum KEY_B1 = 0x1c4; /* middle left on Virt. keypad */
enum KEY_B2 = 0x1c5; /* center on Virt. keypad */
enum KEY_B3 = 0x1c6; /* middle right on Vir. keypad */
enum KEY_C1 = 0x1c7; /* lower left on Virt. keypad */
enum KEY_C2 = 0x1c8; /* lower middle on Virt. keypad */
enum KEY_C3 = 0x1c9; /* lower right on Vir. keypad */

enum PADSLASH      = 0x1ca; /* slash on keypad */
enum PADENTER      = 0x1cb; /* enter on keypad */
enum CTL_PADENTER  = 0x1cc; /* ctl-enter on keypad */
enum ALT_PADENTER  = 0x1cd; /* alt-enter on keypad */
enum PADSTOP       = 0x1ce; /* stop on keypad */
enum PADSTAR       = 0x1cf; /* star on keypad */
enum PADMINUS      = 0x1d0; /* minus on keypad */
enum PADPLUS       = 0x1d1; /* plus on keypad */
enum CTL_PADSTOP   = 0x1d2; /* ctl-stop on keypad */
enum CTL_PADCENTER = 0x1d3; /* ctl-enter on keypad */
enum CTL_PADPLUS   = 0x1d4; /* ctl-plus on keypad */
enum CTL_PADMINUS  = 0x1d5; /* ctl-minus on keypad */
enum CTL_PADSLASH  = 0x1d6; /* ctl-slash on keypad */
enum CTL_PADSTAR   = 0x1d7; /* ctl-star on keypad */
enum ALT_PADPLUS   = 0x1d8; /* alt-plus on keypad */
enum ALT_PADMINUS  = 0x1d9; /* alt-minus on keypad */
enum ALT_PADSLASH  = 0x1da; /* alt-slash on keypad */
enum ALT_PADSTAR   = 0x1db; /* alt-star on keypad */
enum ALT_PADSTOP   = 0x1dc; /* alt-stop on keypad */
enum CTL_INS       = 0x1dd; /* ctl-insert */
enum ALT_DEL       = 0x1de; /* alt-delete */
enum ALT_INS       = 0x1df; /* alt-insert */
enum CTL_UP        = 0x1e0; /* ctl-up arrow */
enum CTL_DOWN      = 0x1e1; /* ctl-down arrow */
enum CTL_TAB       = 0x1e2; /* ctl-tab */
enum ALT_TAB       = 0x1e3;
enum ALT_MINUS     = 0x1e4;
enum ALT_EQUAL     = 0x1e5;
enum ALT_HOME      = 0x1e6;
enum ALT_PGUP      = 0x1e7;
enum ALT_PGDN      = 0x1e8;
enum ALT_END       = 0x1e9;
enum ALT_UP        = 0x1ea; /* alt-up arrow */
enum ALT_DOWN      = 0x1eb; /* alt-down arrow */
enum ALT_RIGHT     = 0x1ec; /* alt-right arrow */
enum ALT_LEFT      = 0x1ed; /* alt-left arrow */
enum ALT_ENTER     = 0x1ee; /* alt-enter */
enum ALT_ESC       = 0x1ef; /* alt-escape */
enum ALT_BQUOTE    = 0x1f0; /* alt-back quote */
enum ALT_LBRACKET  = 0x1f1; /* alt-left bracket */
enum ALT_RBRACKET  = 0x1f2; /* alt-right bracket */
enum ALT_SEMICOLON = 0x1f3; /* alt-semi-colon */
enum ALT_FQUOTE    = 0x1f4; /* alt-forward quote */
enum ALT_COMMA     = 0x1f5; /* alt-comma */
enum ALT_STOP      = 0x1f6; /* alt-stop */
enum ALT_FSLASH    = 0x1f7; /* alt-forward slash */
enum ALT_BKSP      = 0x1f8; /* alt-backspace */
enum CTL_BKSP      = 0x1f9; /* ctl-backspace */
enum PAD0          = 0x1fa; /* keypad 0 */

enum CTL_PAD0 = 0x1fb; /* ctl-keypad 0 */
enum CTL_PAD1 = 0x1fc;
enum CTL_PAD2 = 0x1fd;
enum CTL_PAD3 = 0x1fe;
enum CTL_PAD4 = 0x1ff;
enum CTL_PAD5 = 0x200;
enum CTL_PAD6 = 0x201;
enum CTL_PAD7 = 0x202;
enum CTL_PAD8 = 0x203;
enum CTL_PAD9 = 0x204;

enum ALT_PAD0 = 0x205; /* alt-keypad 0 */
enum ALT_PAD1 = 0x206;
enum ALT_PAD2 = 0x207;
enum ALT_PAD3 = 0x208;
enum ALT_PAD4 = 0x209;
enum ALT_PAD5 = 0x20a;
enum ALT_PAD6 = 0x20b;
enum ALT_PAD7 = 0x20c;
enum ALT_PAD8 = 0x20d;
enum ALT_PAD9 = 0x20e;

enum CTL_DEL    = 0x20f; /* clt-delete */
enum ALT_BSLASH = 0x210; /* alt-back slash */
enum CTL_ENTER  = 0x211; /* ctl-enter */

enum SHF_PADENTER = 0x212; /* shift-enter on keypad */
enum SHF_PADSLASH = 0x213; /* shift-slash on keypad */
enum SHF_PADSTAR  = 0x214; /* shift-star  on keypad */
enum SHF_PADPLUS  = 0x215; /* shift-plus  on keypad */
enum SHF_PADMINUS = 0x216; /* shift-minus on keypad */
enum SHF_UP       = 0x217; /* shift-up on keypad */
enum SHF_DOWN     = 0x218; /* shift-down on keypad */
enum SHF_IC       = 0x219; /* shift-insert on keypad */
enum SHF_DC       = 0x21a; /* shift-delete on keypad */

enum KEY_MOUSE     = 0x21b; /* "mouse" key */
enum KEY_SHIFT_L   = 0x21c; /* Left-shift */
enum KEY_SHIFT_R   = 0x21d; /* Right-shift */
enum KEY_CONTROL_L = 0x21e; /* Left-control */
enum KEY_CONTROL_R = 0x21f; /* Right-control */
enum KEY_ALT_L     = 0x220; /* Left-alt */
enum KEY_ALT_R     = 0x221; /* Right-alt */
enum KEY_RESIZE    = 0x222; /* Window resize */
enum KEY_SUP       = 0x223; /* Shifted up arrow */
enum KEY_SDOWN     = 0x224; /* Shifted down arrow */

enum KEY_MIN = KEY_BREAK; /* Minimum curses key value */
enum KEY_MAX = KEY_SDOWN; /* Maximum curses key */

extern (D) pragma(inline, true)
auto KEY_F(T)(auto ref T n)
{
    return KEY_F0 + n;
}

/*----------------------------------------------------------------------
 *
 *  PDCurses Function Declarations
 *
 */

/* Standard */

int     addch (const chtype);
int     addchnstr (const(chtype)*, int);
int     addchstr (const(chtype)*);
int     addnstr (const(char)*, int);
int     addstr (const(char)*);
int     attroff (chtype);
int     attron (chtype);
int     attrset (chtype);
int     attr_get (attr_t*, short*, void*);
int     attr_off (attr_t, void*);
int     attr_on (attr_t, void*);
int     attr_set (attr_t, short, void*);
int     baudrate ();
int     beep ();
int     bkgd (chtype);
void    bkgdset (chtype);
int     border (chtype, chtype, chtype, chtype, chtype, chtype, chtype, chtype);
int     box (WINDOW*, chtype, chtype);
bool    can_change_color ();
int     cbreak ();
int     chgat (int, attr_t, short, const(void)*);
int     clearok (WINDOW*, bool);
int     clear ();
int     clrtobot ();
int     clrtoeol ();
int     color_content (short, short*, short*, short*);
int     color_set (short, void*);
int     copywin (const(WINDOW)*, WINDOW*, int, int, int, int, int, int, int);
int     curs_set (int);
int     def_prog_mode ();
int     def_shell_mode ();
int     delay_output (int);
int     delch ();
int     deleteln ();
void    delscreen (SCREEN*);
int     delwin (WINDOW*);
WINDOW* derwin (WINDOW*, int, int, int, int);
int     doupdate ();
WINDOW* dupwin (WINDOW*);
int     echochar (const chtype);
int     echo ();
int     endwin ();
char    erasechar ();
int     erase ();
void    filter ();
int     flash ();
int     flushinp ();
chtype  getbkgd (WINDOW*);
int     getnstr (char*, int);
int     getstr (char*);
WINDOW* getwin (FILE*);
int     halfdelay (int);
bool    has_colors ();
bool    has_ic ();
bool    has_il ();
int     hline (chtype, int);
void    idcok (WINDOW*, bool);
int     idlok (WINDOW*, bool);
void    immedok (WINDOW*, bool);
int     inchnstr (chtype*, int);
int     inchstr (chtype*);
chtype  inch ();
int     init_color (short, short, short, short);
int     init_pair (short, short, short);
WINDOW* initscr ();
int     innstr (char*, int);
int     insch (chtype);
int     insdelln (int);
int     insertln ();
int     insnstr (const(char)*, int);
int     insstr (const(char)*);
int     instr (char*);
int     intrflush (WINDOW*, bool);
bool    isendwin ();
bool    is_linetouched (WINDOW*, int);
bool    is_wintouched (WINDOW*);
char*   keyname (int);
int     keypad (WINDOW*, bool);
char    killchar ();
int     leaveok (WINDOW*, bool);
char*   longname ();
int     meta (WINDOW*, bool);
int     move (int, int);
int     mvaddch (int, int, const chtype);
int     mvaddchnstr (int, int, const(chtype)*, int);
int     mvaddchstr (int, int, const(chtype)*);
int     mvaddnstr (int, int, const(char)*, int);
int     mvaddstr (int, int, const(char)*);
int     mvchgat (int, int, int, attr_t, short, const(void)*);
int     mvcur (int, int, int, int);
int     mvdelch (int, int);
int     mvderwin (WINDOW*, int, int);
int     mvgetch (int, int);
int     mvgetnstr (int, int, char*, int);
int     mvgetstr (int, int, char*);
int     mvhline (int, int, chtype, int);
chtype  mvinch (int, int);
int     mvinchnstr (int, int, chtype*, int);
int     mvinchstr (int, int, chtype*);
int     mvinnstr (int, int, char*, int);
int     mvinsch (int, int, chtype);
int     mvinsnstr (int, int, const(char)*, int);
int     mvinsstr (int, int, const(char)*);
int     mvinstr (int, int, char*);
int     mvprintw (int, int, const(char)*, ...);
int     mvscanw (int, int, const(char)*, ...);
int     mvvline (int, int, chtype, int);
int     mvwaddchnstr (WINDOW*, int, int, const(chtype)*, int);
int     mvwaddchstr (WINDOW*, int, int, const(chtype)*);
int     mvwaddch (WINDOW*, int, int, const chtype);
int     mvwaddnstr (WINDOW*, int, int, const(char)*, int);
int     mvwaddstr (WINDOW*, int, int, const(char)*);
int     mvwchgat (WINDOW*, int, int, int, attr_t, short, const(void)*);
int     mvwdelch (WINDOW*, int, int);
int     mvwgetch (WINDOW*, int, int);
int     mvwgetnstr (WINDOW*, int, int, char*, int);
int     mvwgetstr (WINDOW*, int, int, char*);
int     mvwhline (WINDOW*, int, int, chtype, int);
int     mvwinchnstr (WINDOW*, int, int, chtype*, int);
int     mvwinchstr (WINDOW*, int, int, chtype*);
chtype  mvwinch (WINDOW*, int, int);
int     mvwinnstr (WINDOW*, int, int, char*, int);
int     mvwinsch (WINDOW*, int, int, chtype);
int     mvwinsnstr (WINDOW*, int, int, const(char)*, int);
int     mvwinsstr (WINDOW*, int, int, const(char)*);
int     mvwinstr (WINDOW*, int, int, char*);
int     mvwin (WINDOW*, int, int);
int     mvwprintw (WINDOW*, int, int, const(char)*, ...);
int     mvwscanw (WINDOW*, int, int, const(char)*, ...);
int     mvwvline (WINDOW*, int, int, chtype, int);
int     napms (int);
WINDOW* newpad (int, int);
SCREEN* newterm (const(char)*, FILE*, FILE*);
WINDOW* newwin (int, int, int, int);
int     nl ();
int     nocbreak ();
int     nodelay (WINDOW*, bool);
int     noecho ();
int     nonl ();
void    noqiflush ();
int     noraw ();
int     notimeout (WINDOW*, bool);
int     overlay (const(WINDOW)*, WINDOW*);
int     overwrite (const(WINDOW)*, WINDOW*);
int     pair_content (short, short*, short*);
int     pechochar (WINDOW*, chtype);
int     pnoutrefresh (WINDOW*, int, int, int, int, int, int);
int     prefresh (WINDOW*, int, int, int, int, int, int);
int     printw (const(char)*, ...);
int     putwin (WINDOW*, FILE*);
void    qiflush ();
int     raw ();
int     redrawwin (WINDOW*);
int     refresh ();
int     reset_prog_mode ();
int     reset_shell_mode ();
int     resetty ();
int     ripoffline (int, int function (WINDOW*, int));
int     savetty ();
int     scanw (const(char)*, ...);
int     scr_dump (const(char)*);
int     scr_init (const(char)*);
int     scr_restore (const(char)*);
int     scr_set (const(char)*);
int     scrl (int);
int     scroll (WINDOW*);
int     scrollok (WINDOW*, bool);
SCREEN* set_term (SCREEN*);
int     setscrreg (int, int);
int     slk_attroff (const chtype);
int     slk_attr_off (const attr_t, void*);
int     slk_attron (const chtype);
int     slk_attr_on (const attr_t, void*);
int     slk_attrset (const chtype);
int     slk_attr_set (const attr_t, short, void*);
int     slk_clear ();
int     slk_color (short);
int     slk_init (int);
char*   slk_label (int);
int     slk_noutrefresh ();
int     slk_refresh ();
int     slk_restore ();
int     slk_set (int, const(char)*, int);
int     slk_touch ();
int     standend ();
int     standout ();
int     start_color ();
WINDOW* subpad (WINDOW*, int, int, int, int);
WINDOW* subwin (WINDOW*, int, int, int, int);
int     syncok (WINDOW*, bool);
chtype  termattrs ();
attr_t  term_attrs ();
char*   termname ();
void    timeout (int);
int     touchline (WINDOW*, int, int);
int     touchwin (WINDOW*);
int     typeahead (int);
int     untouchwin (WINDOW*);
void    use_env (bool);
int     vidattr (chtype);
int     vid_attr (attr_t, short, void*);
int     vidputs (chtype, int function (int));
int     vid_puts (attr_t, short, void*, int function (int));
int     vline (chtype, int);
int     vw_printw (WINDOW*, const(char)*, va_list);
int     vwprintw (WINDOW*, const(char)*, va_list);
int     vw_scanw (WINDOW*, const(char)*, va_list);
int     vwscanw (WINDOW*, const(char)*, va_list);
int     waddchnstr (WINDOW*, const(chtype)*, int);
int     waddchstr (WINDOW*, const(chtype)*);
int     waddch (WINDOW*, const chtype);
int     waddnstr (WINDOW*, const(char)*, int);
int     waddstr (WINDOW*, const(char)*);
int     wattroff (WINDOW*, chtype);
int     wattron (WINDOW*, chtype);
int     wattrset (WINDOW*, chtype);
int     wattr_get (WINDOW*, attr_t*, short*, void*);
int     wattr_off (WINDOW*, attr_t, void*);
int     wattr_on (WINDOW*, attr_t, void*);
int     wattr_set (WINDOW*, attr_t, short, void*);
void    wbkgdset (WINDOW*, chtype);
int     wbkgd (WINDOW*, chtype);
int     wborder (WINDOW*, chtype, chtype, chtype, chtype, chtype, chtype, chtype, chtype);
int     wchgat (WINDOW*, int, attr_t, short, const(void)*);
int     wclear (WINDOW*);
int     wclrtobot (WINDOW*);
int     wclrtoeol (WINDOW*);
int     wcolor_set (WINDOW*, short, void*);
void    wcursyncup (WINDOW*);
int     wdelch (WINDOW*);
int     wdeleteln (WINDOW*);
int     wechochar (WINDOW*, const chtype);
int     werase (WINDOW*);
int     wgetch (WINDOW*);
int     wgetnstr (WINDOW*, char*, int);
int     wgetstr (WINDOW*, char*);
int     whline (WINDOW*, chtype, int);
int     winchnstr (WINDOW*, chtype*, int);
int     winchstr (WINDOW*, chtype*);
chtype  winch (WINDOW*);
int     winnstr (WINDOW*, char*, int);
int     winsch (WINDOW*, chtype);
int     winsdelln (WINDOW*, int);
int     winsertln (WINDOW*);
int     winsnstr (WINDOW*, const(char)*, int);
int     winsstr (WINDOW*, const(char)*);
int     winstr (WINDOW*, char*);
int     wmove (WINDOW*, int, int);
int     wnoutrefresh (WINDOW*);
int     wprintw (WINDOW*, const(char)*, ...);
int     wredrawln (WINDOW*, int, int);
int     wrefresh (WINDOW*);
int     wscanw (WINDOW*, const(char)*, ...);
int     wscrl (WINDOW*, int);
int     wsetscrreg (WINDOW*, int, int);
int     wstandend (WINDOW*);
int     wstandout (WINDOW*);
void    wsyncdown (WINDOW*);
void    wsyncup (WINDOW*);
void    wtimeout (WINDOW*, int);
int     wtouchln (WINDOW*, int, int, int);
int     wvline (WINDOW*, chtype, int);

/* Quasi-standard */

chtype getattrs (WINDOW*);
int    getbegx (WINDOW*);
int    getbegy (WINDOW*);
int    getmaxx (WINDOW*);
int    getmaxy (WINDOW*);
int    getparx (WINDOW*);
int    getpary (WINDOW*);
int    getcurx (WINDOW*);
int    getcury (WINDOW*);
void   traceoff ();
void   traceon ();
char*  unctrl (chtype);

int crmode ();
int nocrmode ();
int draino (int);
int resetterm ();
int fixterm ();
int saveterm ();
int setsyx (int, int);

int     mouse_set (c_ulong);
int     mouse_on (c_ulong);
int     mouse_off (c_ulong);
int     request_mouse_pos ();
int     map_button (c_ulong);
void    wmouse_position (WINDOW*, int*, int*);
c_ulong getmouse ();
c_ulong getbmap ();

/* ncurses */

int          assume_default_colors (int, int);
const(char)* curses_version ();
bool         has_key (int);
int          use_default_colors ();
int          wresize (WINDOW*, int, int);

int     mouseinterval (int);
mmask_t mousemask (mmask_t, mmask_t*);
bool    mouse_trafo (int*, int*, bool);
int     nc_getmouse (MEVENT*);
int     ungetmouse (MEVENT*);
bool    wenclose (const(WINDOW)*, int, int);
bool    wmouse_trafo (const(WINDOW)*, int*, int*, bool);

/* PDCurses */

int     addrawch (chtype);
int     insrawch (chtype);
bool    is_termresized ();
int     mvaddrawch (int, int, chtype);
int     mvdeleteln (int, int);
int     mvinsertln (int, int);
int     mvinsrawch (int, int, chtype);
int     mvwaddrawch (WINDOW*, int, int, chtype);
int     mvwdeleteln (WINDOW*, int, int);
int     mvwinsertln (WINDOW*, int, int);
int     mvwinsrawch (WINDOW*, int, int, chtype);
int     raw_output (bool);
int     resize_term (int, int);
WINDOW* resize_window (WINDOW*, int, int);
int     waddrawch (WINDOW*, chtype);
int     winsrawch (WINDOW*, chtype);
char    wordchar ();

void PDC_debug (const(char)*, ...);
int  PDC_ungetch (int);
int  PDC_set_blink (bool);
int  PDC_set_line_color (short);
void PDC_set_title (const(char)*);

int PDC_clearclipboard ();
int PDC_freeclipboard (char*);
int PDC_getclipboard (char**, c_long*);
int PDC_setclipboard (const(char)*, c_long);

c_ulong PDC_get_input_fd ();
c_ulong PDC_get_key_modifiers ();
int     PDC_return_key_modifiers (bool);
int     PDC_save_key_modifiers (bool);

/*** Functions defined as macros ***/

/* getch() and ungetch() conflict with some DOS libraries */

extern (D) pragma (inline, true)
auto getch()
{
    return wgetch(stdscr);
}

alias ungetch = PDC_ungetch;

extern (D) pragma (inline, true)
auto COLOR_PAIR(T)(auto ref T n)
{
    return (cast(chtype) n << PDC_COLOR_SHIFT) & A_COLOR;
}

extern (D) pragma (inline, true)
auto PAIR_NUMBER(T)(auto ref T n)
{
    return (n & A_COLOR) >> PDC_COLOR_SHIFT;
}

/* These will _only_ work as macros */

/* return codes from PDC_getclipboard() and PDC_setclipboard() calls */

enum PDC_CLIP_SUCCESS = 0;
enum PDC_CLIP_ACCESS_ERROR = 1;
enum PDC_CLIP_EMPTY = 2;
enum PDC_CLIP_MEMORY_ERROR = 3;

/* PDCurses key modifier masks */

enum PDC_KEY_MODIFIER_SHIFT = 1;
enum PDC_KEY_MODIFIER_CONTROL = 2;
enum PDC_KEY_MODIFIER_ALT = 4;
enum PDC_KEY_MODIFIER_NUMLOCK = 8;

/* __PDCURSES__ */
