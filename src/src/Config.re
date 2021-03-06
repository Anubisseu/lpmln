#include "Config.h"
#include <vector>
#include <sys/stat.h> //To check if the file exists or not
#include <iostream>


Config::Config(int argc, char** argv){
	args = argv;
	if(argc < 2){
		showError(Error::NO_FILE,-1);
		return;
	}

	
	#define YYFILL(n)	{}
    
    

	for (int i = 0; i < argc; ++i)
	{
		const char* YYCTXMARKER;

		char* original = argv[i];

		#define YYCTYPE char
		#define YYFILL(n) {}    
		#define YYCURSOR original
		#define YYLIMIT original+sizeof(original)
		#define YYMARKER YYCURSOR
		#define YYCTXMARKER YYCURSOR 

		/*!re2c


		WS						= [ \t\v\f];

		"\000"					{ continue;}
		"-t"					{
									if(translation == Translation::Translation_None)
										translation = Translation::Tuffy;
									else
										Config::showError(Error::INVALID_T,i);
									continue;  	
								}
		"-m"					{
									if(translation == Translation::Translation_None)
										translation = Translation::Alchemy;
									else
										Config::showError(Error::INVALID_M,i);
									continue;
										
								}

		"-a"					{
									if(parserType == ParserType::PARSER_NONE)
										parserType = ParserType::ASP;
									else
										Config::showError(Error::INVALID_A,i);
									continue;	
								}

		"-p"					{
									if(parserType == ParserType::PARSER_NONE)
										parserType = ParserType::MVSM;
									else
										Config::showError(Error::INVALID_A,i);
									continue;
								}

		"-d"					{
									debug = true;
									continue;
								}								

		"-h"					{
									Config::showHelp();
									help = true;
									return;
								}
		"-v"					{
									Config::showVersion();
									help = true;
									return;
								}

		[a-zA-Z_0-9/-.]+		{
									if(i == 0){
										path = argv[i];
										continue;
									}
									else{
										struct stat buffer;
										if(stat(argv[i],&buffer) == 0){
											file = argv[i];
										}
										else{
											Config::showError(Error::INVALID_FILE,i);
										}
										continue;
									}

								}

		*						{
									Config::showError(Error::UNREGONIZED_OPTION,i);
									continue;
								}
		*/
	}

	/*
		Check if user gave a file
	*/
	if(file.size() == 0){
		showError(Error::EXPECTED_FILE,-1);
	}

	/*
	User did not specify any translation. Default to alchemy.
	*/
	if(translation == Translation::Translation_None)
		translation = Translation::Alchemy;

	if(parserType == ParserType::PARSER_NONE)
		parserType = ParserType::FOL;
		
}


void Config::showError(Error e, int i){
	errors = true;
	switch(e){

		case Error::INVALID_T:
			std::cerr << "Invalid option -t \n"
						"use either of -a or -t not both \n";
			break;

		case Error::INVALID_M:
			std::cerr << "Invalid option -m \n"
						"use either of -m or -t not both \n";
			break;

		case Error::INVALID_FILE:
			std::cerr << "File could not be opened \n"
						"Check whether the file exists at location "<<file <<"\n";		
			break;

		case Error::NO_FILE:
			std::cerr << "No Input file provided.\n"
						"Use option -h for usage\n";
			break;

		case Error::EXPECTED_FILE:
			std::cerr << "Expected an Input file.\n";
			break;

		case Error::INVALID_A:
			std::cerr << "Invalid option -a \n";
			break;

		case Error::UNREGONIZED_OPTION:
			std::cerr << "Unrecognized option "<<args[i] <<"\n";
			break;

		case Error::ERROR_NONE:				
		default:
			break;
	}
}

void Config::showHelp(){
	std::cout<<"LPMLN Version "<< VERSION << "\n"
				"Address Model: 64-bit \n"
				"\n"
				"Usage: lpmln [options] [file]"
				"\n"
				"Options:\n"
				"\n"
				"\t-m\tCompile for Alchemy\n"
				"\t-t\tCompile for Tuffy\n"
				"\t-a\tCompile with input in ASP like syntax\n"
				"\t-h\tShow this Message\n"
				"\t-v\tDisplay Version\n"
				"\n";

}

void Config::showVersion(){
	std::cout<<"LPMLN Version "<< VERSION <<"\n";
}

Config::~Config(){}

