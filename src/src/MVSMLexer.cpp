/* Generated by re2c 0.16 on Tue Aug 16 20:19:02 2016 */
#line 1 "MVSMLexer.re"
#include "MVSMLexer.h"
#include "exceptions/syntax_exception.h"

int MVSMLexer::Tokenize(const char * YYCURSOR, int len , lexeme_t* lexeme)
{

 	if (lexeme->current >= (YYCURSOR + len)) {
        return 0;
    }
    lexeme->start = lexeme->current;

    const char * YYMARKER;
	#define YYCURSOR lexeme->current

	
#line 19 "<stdout>"
{
	YYCTYPE yych;
	unsigned int yyaccept = 0;
	if ((YYLIMIT - YYCURSOR) < 4) YYFILL(4);
	yych = *YYCURSOR;
	switch (yych) {
	case 0x00:	goto yy2;
	case '\t':
	case '\v':
	case '\f':
	case ' ':	goto yy6;
	case '\n':	goto yy8;
	case '!':	goto yy10;
	case '(':	goto yy12;
	case ')':	goto yy14;
	case ',':	goto yy16;
	case '-':	goto yy18;
	case '.':	goto yy20;
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':	goto yy22;
	case ':':	goto yy25;
	case ';':	goto yy27;
	case '<':	goto yy29;
	case '=':	goto yy30;
	case 'A':
	case 'B':
	case 'C':
	case 'D':
	case 'E':
	case 'F':
	case 'G':
	case 'H':
	case 'I':
	case 'J':
	case 'K':
	case 'L':
	case 'M':
	case 'O':
	case 'P':
	case 'Q':
	case 'R':
	case 'S':
	case 'T':
	case 'U':
	case 'V':
	case 'W':
	case 'X':
	case 'Y':
	case 'Z':
	case 'a':
	case 'b':
	case 'c':
	case 'd':
	case 'e':
	case 'f':
	case 'g':
	case 'h':
	case 'i':
	case 'j':
	case 'k':
	case 'l':
	case 'm':
	case 'o':
	case 'p':
	case 'q':
	case 'r':
	case 's':
	case 't':
	case 'u':
	case 'v':
	case 'w':
	case 'x':
	case 'y':
	case 'z':	goto yy32;
	case 'N':	goto yy35;
	case '^':	goto yy36;
	case 'n':	goto yy38;
	case '{':	goto yy39;
	case '}':	goto yy41;
	default:	goto yy4;
	}
yy2:
	++YYCURSOR;
#line 20 "MVSMLexer.re"
	{ return 0; }
#line 113 "<stdout>"
yy4:
	++YYCURSOR;
yy5:
#line 55 "MVSMLexer.re"
	{
									std::string str(--lexeme->current,0,1);
									throw syntax_exception("Syntax Error - Unexpected "+ str +"\n");
								}
#line 122 "<stdout>"
yy6:
	yyaccept = 0;
	yych = *(YYMARKER = ++YYCURSOR);
	switch (yych) {
	case '\t':
	case '\v':
	case '\f':
	case ' ':	goto yy43;
	case 'v':	goto yy46;
	default:	goto yy7;
	}
yy7:
#line 53 "MVSMLexer.re"
	{ return -1; }
#line 137 "<stdout>"
yy8:
	++YYCURSOR;
#line 54 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_NEWLINE; }
#line 142 "<stdout>"
yy10:
	++YYCURSOR;
#line 43 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_NEGATION;}
#line 147 "<stdout>"
yy12:
	++YYCURSOR;
#line 30 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_LBRACKET; }
#line 152 "<stdout>"
yy14:
	++YYCURSOR;
#line 31 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_RBRACKET; }
#line 157 "<stdout>"
yy16:
	++YYCURSOR;
#line 32 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_COMMA; }
#line 162 "<stdout>"
yy18:
	++YYCURSOR;
	switch ((yych = *YYCURSOR)) {
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':	goto yy22;
	default:	goto yy19;
	}
yy19:
#line 41 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_MINUS;}
#line 181 "<stdout>"
yy20:
	++YYCURSOR;
#line 19 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_DOT; }
#line 186 "<stdout>"
yy22:
	yyaccept = 1;
	YYMARKER = ++YYCURSOR;
	if ((YYLIMIT - YYCURSOR) < 2) YYFILL(2);
	yych = *YYCURSOR;
	switch (yych) {
	case '.':	goto yy47;
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':	goto yy22;
	default:	goto yy24;
	}
yy24:
#line 22 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_NUMBER; }
#line 209 "<stdout>"
yy25:
	yyaccept = 2;
	yych = *(YYMARKER = ++YYCURSOR);
	switch (yych) {
	case '-':	goto yy48;
	default:	goto yy26;
	}
yy26:
#line 51 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_COLON; }
#line 220 "<stdout>"
yy27:
	++YYCURSOR;
#line 49 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_SEMI_COLON;}
#line 225 "<stdout>"
yy29:
	yych = *++YYCURSOR;
	switch (yych) {
	case '=':	goto yy50;
	default:	goto yy5;
	}
yy30:
	++YYCURSOR;
	switch ((yych = *YYCURSOR)) {
	case '>':	goto yy52;
	default:	goto yy31;
	}
yy31:
#line 29 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_EQUAL; }
#line 241 "<stdout>"
yy32:
	++YYCURSOR;
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
	yych = *YYCURSOR;
yy33:
	switch (yych) {
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':
	case 'A':
	case 'B':
	case 'C':
	case 'D':
	case 'E':
	case 'F':
	case 'G':
	case 'H':
	case 'I':
	case 'J':
	case 'K':
	case 'L':
	case 'M':
	case 'N':
	case 'O':
	case 'P':
	case 'Q':
	case 'R':
	case 'S':
	case 'T':
	case 'U':
	case 'V':
	case 'W':
	case 'X':
	case 'Y':
	case 'Z':
	case 'a':
	case 'b':
	case 'c':
	case 'd':
	case 'e':
	case 'f':
	case 'g':
	case 'h':
	case 'i':
	case 'j':
	case 'k':
	case 'l':
	case 'm':
	case 'n':
	case 'o':
	case 'p':
	case 'q':
	case 'r':
	case 's':
	case 't':
	case 'u':
	case 'v':
	case 'w':
	case 'x':
	case 'y':
	case 'z':	goto yy32;
	default:	goto yy34;
	}
yy34:
#line 24 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_STRING; }
#line 315 "<stdout>"
yy35:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'O':	goto yy54;
	default:	goto yy33;
	}
yy36:
	++YYCURSOR;
#line 33 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_CONJUNCTION; }
#line 326 "<stdout>"
yy38:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'o':	goto yy55;
	default:	goto yy33;
	}
yy39:
	++YYCURSOR;
#line 28 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_LPAREN; }
#line 337 "<stdout>"
yy41:
	++YYCURSOR;
#line 27 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_RPAREN; }
#line 342 "<stdout>"
yy43:
	++YYCURSOR;
	if ((YYLIMIT - YYCURSOR) < 2) YYFILL(2);
	yych = *YYCURSOR;
	switch (yych) {
	case '\t':
	case '\v':
	case '\f':
	case ' ':	goto yy43;
	case 'v':	goto yy46;
	default:	goto yy45;
	}
yy45:
	YYCURSOR = YYMARKER;
	switch (yyaccept) {
	case 0: 	goto yy7;
	case 1: 	goto yy24;
	default:	goto yy26;
	}
yy46:
	yych = *++YYCURSOR;
	switch (yych) {
	case '\t':
	case '\v':
	case '\f':
	case ' ':	goto yy56;
	default:	goto yy45;
	}
yy47:
	yych = *++YYCURSOR;
	switch (yych) {
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':	goto yy59;
	default:	goto yy45;
	}
yy48:
	++YYCURSOR;
	if ((YYLIMIT - YYCURSOR) < 9) YYFILL(9);
	yych = *YYCURSOR;
	switch (yych) {
	case '\t':
	case '\v':
	case '\f':
	case ' ':	goto yy48;
	case 'c':	goto yy61;
	case 'o':	goto yy62;
	case 's':	goto yy63;
	default:	goto yy45;
	}
yy50:
	++YYCURSOR;
#line 26 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_REVERSE_IMPLICATION; }
#line 404 "<stdout>"
yy52:
	++YYCURSOR;
#line 25 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_IMPLICATION; }
#line 409 "<stdout>"
yy54:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'T':	goto yy64;
	default:	goto yy33;
	}
yy55:
	yych = *++YYCURSOR;
	switch (yych) {
	case 't':	goto yy64;
	default:	goto yy33;
	}
yy56:
	++YYCURSOR;
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
	yych = *YYCURSOR;
	switch (yych) {
	case '\t':
	case '\v':
	case '\f':
	case ' ':	goto yy56;
	default:	goto yy58;
	}
yy58:
#line 34 "MVSMLexer.re"
	{
									while(*(lexeme->start) != 'v') lexeme->start++;
									while(*(lexeme->current) != 'v') lexeme->current--;
									lexeme->current++; 
									return MVSM_PARSE_TOKEN_DISJUNCTION;
								}
#line 441 "<stdout>"
yy59:
	++YYCURSOR;
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
	yych = *YYCURSOR;
	switch (yych) {
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':	goto yy59;
	default:	goto yy24;
	}
yy61:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'o':	goto yy66;
	default:	goto yy45;
	}
yy62:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'b':	goto yy67;
	default:	goto yy45;
	}
yy63:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'o':	goto yy68;
	default:	goto yy45;
	}
yy64:
	++YYCURSOR;
	switch ((yych = *YYCURSOR)) {
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':
	case 'A':
	case 'B':
	case 'C':
	case 'D':
	case 'E':
	case 'F':
	case 'G':
	case 'H':
	case 'I':
	case 'J':
	case 'K':
	case 'L':
	case 'M':
	case 'N':
	case 'O':
	case 'P':
	case 'Q':
	case 'R':
	case 'S':
	case 'T':
	case 'U':
	case 'V':
	case 'W':
	case 'X':
	case 'Y':
	case 'Z':
	case 'a':
	case 'b':
	case 'c':
	case 'd':
	case 'e':
	case 'f':
	case 'g':
	case 'h':
	case 'i':
	case 'j':
	case 'k':
	case 'l':
	case 'm':
	case 'n':
	case 'o':
	case 'p':
	case 'q':
	case 'r':
	case 's':
	case 't':
	case 'u':
	case 'v':
	case 'w':
	case 'x':
	case 'y':
	case 'z':	goto yy32;
	default:	goto yy65;
	}
yy65:
#line 23 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_NEGATION;}
#line 547 "<stdout>"
yy66:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'n':	goto yy69;
	default:	goto yy45;
	}
yy67:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'j':	goto yy70;
	default:	goto yy45;
	}
yy68:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'r':	goto yy71;
	default:	goto yy45;
	}
yy69:
	yych = *++YYCURSOR;
	switch (yych) {
	case 's':	goto yy72;
	default:	goto yy45;
	}
yy70:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'e':	goto yy73;
	default:	goto yy45;
	}
yy71:
	yych = *++YYCURSOR;
	switch (yych) {
	case 't':	goto yy74;
	default:	goto yy45;
	}
yy72:
	yych = *++YYCURSOR;
	switch (yych) {
	case 't':	goto yy75;
	default:	goto yy45;
	}
yy73:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'c':	goto yy76;
	default:	goto yy45;
	}
yy74:
	yych = *++YYCURSOR;
	switch (yych) {
	case 's':	goto yy77;
	default:	goto yy45;
	}
yy75:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'a':	goto yy79;
	default:	goto yy45;
	}
yy76:
	yych = *++YYCURSOR;
	switch (yych) {
	case 't':	goto yy80;
	default:	goto yy45;
	}
yy77:
	++YYCURSOR;
#line 45 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_SORTS;}
#line 618 "<stdout>"
yy79:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'n':	goto yy81;
	default:	goto yy45;
	}
yy80:
	yych = *++YYCURSOR;
	switch (yych) {
	case 's':	goto yy82;
	default:	goto yy45;
	}
yy81:
	yych = *++YYCURSOR;
	switch (yych) {
	case 't':	goto yy84;
	default:	goto yy45;
	}
yy82:
	++YYCURSOR;
#line 46 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_OBJECTS;}
#line 641 "<stdout>"
yy84:
	yych = *++YYCURSOR;
	switch (yych) {
	case 's':	goto yy85;
	default:	goto yy45;
	}
yy85:
	++YYCURSOR;
#line 47 "MVSMLexer.re"
	{ return MVSM_PARSE_TOKEN_CONSTANTS;}
#line 652 "<stdout>"
}
#line 60 "MVSMLexer.re"


}