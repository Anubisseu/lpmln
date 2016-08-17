/* Generated by re2c 0.16 on Tue Aug 16 20:18:41 2016 */
#line 1 "src/src/ASPLexer.re"
#include "ASPLexer.h"
#include "exceptions/syntax_exception.h"

int ASPLexer::Tokenize(const char * YYCURSOR, int len , lexeme_t* lexeme)
{

 	if (lexeme->current >= (YYCURSOR + len)) {
        return 0;
    }
    lexeme->start = lexeme->current;

    const char * YYMARKER;
	
	// #define YYCTYPE		char
	// #define YYFILL(n)	{}
 //    #define YYLIMIT		YYCURSOR+len
    #define YYCURSOR 	lexeme->current

	
#line 23 "<stdout>"
{
	YYCTYPE yych;
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
	case '<':	goto yy25;
	case '=':	goto yy26;
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
	case 'z':	goto yy28;
	case 'N':	goto yy31;
	case '^':	goto yy32;
	case 'n':	goto yy34;
	case '{':	goto yy35;
	case '}':	goto yy37;
	default:	goto yy4;
	}
yy2:
	++YYCURSOR;
#line 24 "src/src/ASPLexer.re"
	{ return 0; }
#line 114 "<stdout>"
yy4:
	++YYCURSOR;
yy5:
#line 50 "src/src/ASPLexer.re"
	{
									std::string str(--lexeme->current,0,1);
									throw syntax_exception("Syntax Error - Unexpected "+ str +"\n");
								}
#line 123 "<stdout>"
yy6:
	yych = *(YYMARKER = ++YYCURSOR);
	switch (yych) {
	case '\t':
	case '\v':
	case '\f':
	case ' ':	goto yy39;
	case 'v':	goto yy42;
	default:	goto yy7;
	}
yy7:
#line 48 "src/src/ASPLexer.re"
	{ return -1; }
#line 137 "<stdout>"
yy8:
	++YYCURSOR;
#line 49 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_NEWLINE; }
#line 142 "<stdout>"
yy10:
	++YYCURSOR;
#line 46 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_NEGATION;}
#line 147 "<stdout>"
yy12:
	++YYCURSOR;
#line 33 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_LBRACKET; }
#line 152 "<stdout>"
yy14:
	++YYCURSOR;
#line 34 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_RBRACKET; }
#line 157 "<stdout>"
yy16:
	++YYCURSOR;
#line 35 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_COMMA; }
#line 162 "<stdout>"
yy18:
	++YYCURSOR;
#line 44 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_MINUS;}
#line 167 "<stdout>"
yy20:
	++YYCURSOR;
#line 23 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_DOT; }
#line 172 "<stdout>"
yy22:
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
	case '9':	goto yy22;
	default:	goto yy24;
	}
yy24:
#line 25 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_NUMBER; }
#line 193 "<stdout>"
yy25:
	yych = *++YYCURSOR;
	switch (yych) {
	case '=':	goto yy43;
	default:	goto yy5;
	}
yy26:
	++YYCURSOR;
	switch ((yych = *YYCURSOR)) {
	case '>':	goto yy45;
	default:	goto yy27;
	}
yy27:
#line 32 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_EQUAL; }
#line 209 "<stdout>"
yy28:
	++YYCURSOR;
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
	yych = *YYCURSOR;
yy29:
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
	case 'z':	goto yy28;
	default:	goto yy30;
	}
yy30:
#line 27 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_STRING; }
#line 283 "<stdout>"
yy31:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'O':	goto yy47;
	default:	goto yy29;
	}
yy32:
	++YYCURSOR;
#line 36 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_CONJUNCTION; }
#line 294 "<stdout>"
yy34:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'o':	goto yy48;
	default:	goto yy29;
	}
yy35:
	++YYCURSOR;
#line 31 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_LPAREN; }
#line 305 "<stdout>"
yy37:
	++YYCURSOR;
#line 30 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_RPAREN; }
#line 310 "<stdout>"
yy39:
	++YYCURSOR;
	if ((YYLIMIT - YYCURSOR) < 2) YYFILL(2);
	yych = *YYCURSOR;
	switch (yych) {
	case '\t':
	case '\v':
	case '\f':
	case ' ':	goto yy39;
	case 'v':	goto yy42;
	default:	goto yy41;
	}
yy41:
	YYCURSOR = YYMARKER;
	goto yy7;
yy42:
	yych = *++YYCURSOR;
	switch (yych) {
	case '\t':
	case '\v':
	case '\f':
	case ' ':	goto yy49;
	default:	goto yy41;
	}
yy43:
	++YYCURSOR;
#line 29 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_REVERSE_IMPLICATION; }
#line 339 "<stdout>"
yy45:
	++YYCURSOR;
#line 28 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_IMPLICATION; }
#line 344 "<stdout>"
yy47:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'T':	goto yy52;
	default:	goto yy29;
	}
yy48:
	yych = *++YYCURSOR;
	switch (yych) {
	case 't':	goto yy52;
	default:	goto yy29;
	}
yy49:
	++YYCURSOR;
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
	yych = *YYCURSOR;
	switch (yych) {
	case '\t':
	case '\v':
	case '\f':
	case ' ':	goto yy49;
	default:	goto yy51;
	}
yy51:
#line 37 "src/src/ASPLexer.re"
	{
									while(*(lexeme->start) != 'v') lexeme->start++;
									while(*(lexeme->current) != 'v') lexeme->current--;
									lexeme->current++; 
									return ASP_PARSE_TOKEN_DISJUNCTION;
								}
#line 376 "<stdout>"
yy52:
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
	case 'z':	goto yy28;
	default:	goto yy53;
	}
yy53:
#line 26 "src/src/ASPLexer.re"
	{ return ASP_PARSE_TOKEN_NEGATION;}
#line 447 "<stdout>"
}
#line 55 "src/src/ASPLexer.re"


}