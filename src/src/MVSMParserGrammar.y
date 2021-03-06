%include 
{
	#include <iostream>
	#include <assert.h> 
	#include <stdio.h>
	#include <string.h>
	#include <memory>
	#include <map>
	#include <set>
	#include <string>
	#include <algorithm>
	
	#include "Token.h"
	#include "Domain.h"
	#include "Tree.h"
	#include "Predicate.h"
	#include "FactCompletion.h"
	#include "RuleCompletion.h"
	#include "Head.h"
	#include "Body.h"
	#include "BodyDef.h"
	

	#include "exceptions/undefined_predicate.h"
	#include "exceptions/syntax_exception.h"


	using namespace std;

	#define SPACE " "
	#define COMMENT "//"

	#define YYNOERRORRECOVERY 
	#undef YYERRORSYMBOL

	struct cmp{
		bool operator()(const std::pair<std::string, std::string>& left, const std::pair<std::string, std::string>& right) const{
			return left.first < right.first;
		}
	};

	RuleCompletion* RuleCompletion_BH(Body*, Head*, Tree*);
	void RuleCompletion_HD_BT(Head*, Tree*);
	void RuleCompletion_HD_BC(Head*, Body*, bool, Tree*);

}

%name MVSMParserGrammar
%start_symbol start
%token_prefix MVSM_PARSE_TOKEN_

%extra_argument {Tree* tree}

%parse_accept {
    std::cout<<("//parsing complete!\n");
}

%parse_failure 
{
    std::cout<<"Giving up.Parser is lost...\n";

}

%syntax_error{
	 // std::cout << ;
    int n = sizeof(yyTokenName) / sizeof(yyTokenName[0]);
    for (int i = 0; i < n; ++i) {
            int a = yy_find_shift_action(yypParser, (YYCODETYPE)i);
            if (a < YYNSTATE + YYNRULE) {
                    // std::cout << "expected " << yyTokenName[i] << std::endl;
            		// yy_parse_failed(yypParser);
                    throw syntax_exception("Syntax Error - Expected " + std::string(yyTokenName[i]) + " Found " + std::string(yyTokenName[yymajor])
+ "\n");
            }
    }
    throw syntax_exception("Parsing Failed. Unexpected sequence of tokens\n");
    
}

%left REVERSE_IMPLICATION.
%nonassoc EQUAL.
%nonassoc COMMA.
%nonassoc LPAREN RPAREN.


%right NEWLINE.
%right CONJUNCTION.
%right DISJUNCTION.

%nonassoc LBRACKET RBRACKET.
%nonassoc IMPLICATION.

%nonassoc SORTS.
%right NEGATION.
%nonassoc WS.

%token_type {Token*}

%type start {Tree*}

%type prog {Tree*}

%type predicate {Predicate*}

%type decl {Variable*}

%type variables {std::vector<std::string*>*}


start ::= prog.

prog ::= prog SORTS sortdecl.

sortdecl ::= string(S) SEMI_COLON sortdecl.{
	std::string str = S->toString();
	auto it = tree->domainNamesList.find(str);
	if(it != tree->domainNamesList.end())
		throw syntax_exception("Redeclaration of sort "+S->toString()+"\n");
	else
		tree->domainNamesList.insert(S->toString());
}

sortdecl ::= NEWLINE sortdecl.

sortdecl ::= string(S) DOT.{
	std::string str = S->toString();
	auto it = tree->domainNamesList.find(str);
	if(it != tree->domainNamesList.end())
		throw syntax_exception("Redeclaration of sort "+S->toString()+"\n");
	else
		tree->domainNamesList.insert(str);	
}

// prog ::= prog NEWLINE sort.

// prog ::= sort.

// sort ::= SORTS.{
// 	if (tree->cdp == Tree::Current_Decl_Part::DECL_NONE){
// 		tree->cdp = Tree::Current_Decl_Part::DECL_SORTS;
// 	}
// 	else{
// 		throw syntax_exception("Expected Sorts.");
// 	}
// }

// sort ::= string(S) DOT.{
// 	if(tree->cdp == Tree::Current_Decl_Part::DECL_SORTS){
// 		std::string str = S->toString();
// 		auto it = tree->domainNamesList.find(str);
// 		if(it != tree->domainNamesList.end())
// 			throw syntax_exception("Redeclaration of sort "+S->toString()+"\n");
// 		else
// 			tree->domainNamesList.insert(str);	
// 	}
// 	else if (tree->cdp == Tree::Current_Decl_Part::DECL_CONSTANTS){
// 		Variable* va = new Variable;
// 		va->setVar(S->toString());
// 		tree->variables.insert(*va);
// 		cout<<va->toString()<<"\n";
// 	}

// 	tree->cdp = Tree::Current_Decl_Part::DECL_NONE;
// }

// sort ::= string(S) SEMI_COLON.{
// 	if(tree->cdp == Tree::Current_Decl_Part::DECL_SORTS){
// 		std::string str = S->toString();
// 		auto it = tree->domainNamesList.find(str);
// 		if(it != tree->domainNamesList.end())
// 			throw syntax_exception("Redeclaration of sort "+S->toString()+"\n");
// 		else
// 			tree->domainNamesList.insert(S->toString());
// 	}
// 	else if (tree->cdp == Tree::Current_Decl_Part::DECL_CONSTANTS){
// 		Variable* va = new Variable;
// 		va->setVar(S->toString());
// 		tree->variables.insert(*va);
// 		cout<<va->toString()<<"\n";	
// 	}
// }

prog ::= prog OBJECTS objectdecl.

objectdecl ::= object SEMI_COLON objectdecl.

objectdecl ::= object DOT.

objectdecl ::= NEWLINE objectdecl.

// prog ::= prog NEWLINE object.

// prog ::= object.

// object ::= OBJECTS.{
// 	if (tree->cdp == Tree::Current_Decl_Part::DECL_NONE){
// 		tree->cdp = Tree::Current_Decl_Part::DECL_OBJECTS;
// 	}
// 	else{
// 		throw syntax_exception("Expected Objects.\n");
// 	}
// }

object ::= variables(Ve) COLON COLON string(S).{
	// if(tree->cdp == Tree::Current_Decl_Part::DECL_OBJECTS){
		auto itr = tree->domainNamesList.find(S->toString());
		if(itr != tree->domainNamesList.end()){
			Domain* d  = new Domain(S->toString());
			d->setVars(*Ve);
			tree->domains.insert(*d);
			for(auto& v : d->getVars()){
				tree->domainList.insert(v);	
			}
			cout<<d->toString(false);
			delete d;
		}
		else{
			throw syntax_exception("Domain " + S->toString() +" not declared.\n");
		}
	// }
	/*For cases like 
	male::bool;
	which is a constant declaration but parsed as object since variables can also be a single string. 
	*/
	// else if(tree->cdp == Tree::Current_Decl_Part::DECL_CONSTANTS){
	// 	Variable* va = new Variable;
	// 	std::map<int, Domain> posMap;
	// 	std::set<Domain>::iterator itr;
	// 	int i=0;
		

	// 	itr = tree->domains.find(S->toString());
	// 	if (itr == tree->domains.end()){
	// 		throw syntax_exception("Syntax Error - Domain " + S->toString() + " not found.\n");
	// 	}
	// 	else{
	// 		posMap[i] = *itr;
	// 		va->setRhsDomain(*itr);
	// 	}

	// 	va->setVar(Ve->at(0));
	// 	va->setPosMap(posMap);
	// 	tree->variables.insert(*va);
	// 	cout<<va->toString();
	// 	delete va;
			
	// }
	delete Ve;
}

// object ::= variables(Ve) COLON COLON string(S).{

// 	if(tree->cdp == Tree::Current_Decl_Part::DECL_OBJECTS){
// 		auto itr = tree->domainNamesList.find(S->toString());
// 		if(itr != tree->domainNamesList.end()){
// 			Domain* d  = new Domain(S->toString());
// 			d->setVars(*Ve);
// 			tree->domains.insert(*d);
// 			for(auto& v : d->getVars()){
// 				tree->domainList.insert(v);	
// 			}
// 			cout<<d->toString(false);
// 			delete d;
// 		}
// 		else{
// 			throw syntax_exception("Domain " + S->toString() +" not declared.\n");
// 		}
// 		tree->cdp = Tree::Current_Decl_Part::DECL_NONE;
// 	}

// 	else if(tree->cdp == Tree::Current_Decl_Part::DECL_CONSTANTS){
// 		Variable* va = new Variable;
// 		std::map<int, Domain> posMap;
// 		std::set<Domain>::iterator itr;
// 		int i=0;
		

// 		itr = tree->domains.find(S->toString());
// 		if (itr == tree->domains.end()){
// 			throw syntax_exception("Syntax Error - Domain " + S->toString() + " not found.\n");
// 		}
// 		else{
// 			posMap[i] = *itr;
// 			va->setRhsDomain(*itr);
// 		}

// 		va->setVar(Ve->at(0));
// 		va->setPosMap(posMap);
// 		tree->variables.insert(*va);
// 		cout<<va->toString();
// 		delete va;
// 	}
// 	delete Ve;
// }

// prog ::= prog NEWLINE constant.

// prog ::= constant.

// constant ::= CONSTANTS.{
// 	if (tree->cdp == Tree::Current_Decl_Part::DECL_NONE){
// 		tree->cdp = Tree::Current_Decl_Part::DECL_CONSTANTS;
// 	}
// 	else{
// 		throw syntax_exception("Expected Constants.");
// 	}
// }

prog ::= prog CONSTANTS constantdecl.

constantdecl ::= constant SEMI_COLON constantdecl.

constantdecl ::= constant DOT.

constantdecl ::= NEWLINE constantdecl. 

constant ::= string(S) LBRACKET variables(Ve) RBRACKET COLON COLON string(S1).{
	Variable* va = new Variable;
	std::map<int, Domain> posMap;
	std::set<Domain>::iterator itr;
	int i=0;
	for(auto& v : *Ve){
		itr = tree->domains.find(*v);
		if (itr == tree->domains.end()){
			// std::cout<<"Error:Domain:"+ *v +" not found.\n";
			throw syntax_exception("Syntax Error - Domain " + *v + " not found.\n");
		}
		else{
			// itr = tree->domains.find(*v);
			// va->setVar(S->token);
			posMap[i++] = *itr;
		}
	}

	itr = tree->domains.find(S1->toString());
	if (itr == tree->domains.end()){
		throw syntax_exception("Syntax Error - Domain " + S1->toString() + " not found.\n");
	}
	else{
		posMap[i] = *itr;
		va->setRhsDomain(*itr);
	}

	va->setVar(S->toString());
	va->setPosMap(posMap);
	tree->variables.insert(*va);
	cout<<va->toString();
	delete va;
	delete Ve;
}

// constant ::= string(S) LBRACKET variables(Ve) RBRACKET COLON COLON string(S1) DOT.{
// 	Variable* va = new Variable;
// 	std::map<int, Domain> posMap;
// 	std::set<Domain>::iterator itr;
// 	int i=0;
// 	for(auto& v : *Ve){
// 		itr = tree->domains.find(*v);
// 		if (itr == tree->domains.end()){
// 			// std::cout<<"Error:Domain:"+ *v +" not found.\n";
// 			throw syntax_exception("Syntax Error - Domain " + *v + " not found.\n");
// 		}
// 		else{
// 			// itr = tree->domains.find(*v);
// 			// D->setVar(S->token);
// 			posMap[i++] = *itr;
// 		}
// 	}

// 	itr = tree->domains.find(S1->toString());
// 	if (itr == tree->domains.end()){
// 		throw syntax_exception("Syntax Error - Domain " + S1->toString() + " not found.\n");
// 	}
// 	else{
// 		posMap[i] = *itr;
// 		va->setRhsDomain(*itr);
// 	}

// 	va->setVar(S->toString());
// 	va->setPosMap(posMap);
// 	tree->variables.insert(*va);
// 	tree->cdp = Tree::Current_Decl_Part::DECL_NONE;
// 	cout<<va->toString();
// 	delete Ve;
// 	delete va;
// }

constant ::= string(S) LBRACKET variables(Ve) RBRACKET.{
	Variable* va = new Variable;
	std::map<int, Domain> posMap;
	std::set<Domain>::iterator itr;
	int i=0;
	for(auto& v : *Ve){
		itr = tree->domains.find(*v);
		if (itr == tree->domains.end()){
			throw syntax_exception("Syntax Error - Domain " + *v + " not found.\n");
		}
		else{
			posMap[i++] = *itr;
		}
	}

	va->setVar(S->toString());
	va->setPosMap(posMap);
	tree->variables.insert(*va);
	cout<<va->toString();
	delete Ve;
	delete va;
}

// constant ::= string(S) LBRACKET variables(Ve) RBRACKET DOT.{
// 	Variable* va = new Variable;
// 	std::map<int, Domain> posMap;
// 	std::set<Domain>::iterator itr;
// 	int i=0;
// 	for(auto& v : *Ve){
// 		itr = tree->domains.find(*v);
// 		if (itr == tree->domains.end()){
// 			throw syntax_exception("Syntax Error - Domain " + *v + " not found.\n");
// 		}
// 		else{
// 			posMap[i++] = *itr;
// 		}
// 	}
// 	va->setVar(S->toString());
// 	va->setPosMap(posMap);
// 	tree->variables.insert(*va);
// 	cout<<va->toString();
// 	tree->cdp = Tree::Current_Decl_Part::DECL_NONE;
// 	delete Ve;
// 	delete va;
// }

constant ::= string(S).{
	Variable* va = new Variable;
	va->setVar(S->toString());
	tree->variables.insert(*va);
	cout<<va->toString()<<"\n";
	delete va;	
}

constant ::= string(S) COLON COLON string(S1).{
	Variable* va = new Variable;
	std::map<int, Domain> posMap;
	std::set<Domain>::iterator itr;
	int i=0;
	

	itr = tree->domains.find(S1->toString());
	if (itr == tree->domains.end()){
		throw syntax_exception("Syntax Error - Domain " + S1->toString() + " not found.\n");
	}
	else{
		posMap[i] = *itr;
		va->setRhsDomain(*itr);
	}

	va->setVar(S->toString());
	va->setPosMap(posMap);
	tree->variables.insert(*va);
	cout<<va->toString();
	delete va;	
}


prog ::= prog NEWLINE predicate(P). { 
	if(P->needsToBeCompleted()){	
		FactCompletion f(*P);
		tree->facts.insert(std::pair<std::string,FactCompletion>(f.getHead().getVar(),f)); 
	}	
	delete P;
}

prog ::= predicate(P). { 
	if(P->needsToBeCompleted()){
		FactCompletion f(*P);
		tree->facts.insert(std::pair<std::string,FactCompletion>(f.getHead().getVar(),f)); 	
	}
	delete P;
}

prog ::= prog NEWLINE rule(R). {
	if((R->isHeadTop == false) && (R->toBeCompleted == true))
		tree->rules.insert(std::pair<std::string,RuleCompletion>(R->getHead().getVar(),*R));
	delete R;
}

prog ::= rule(R).{
	if((R->isHeadTop == false) && (R->toBeCompleted == true))
		tree->rules.insert(std::pair<std::string,RuleCompletion>(R->getHead().getVar(),*R));
	delete R;
}

prog ::= prog NEWLINE.

prog ::= .




%type body {Body*}

%type bodydef {BodyDef*} 
%type bodydef2 {BodyDef*} 

%type head {Head*}



%type rule {RuleCompletion*}

// //RuleU are rules with head bottom
// %type ruleU {RuleCompletion*}

// //ex 0.8536 <= (ruleU)
// //Test case covered
// rule(R) ::= number(N) REVERSE_IMPLICATION LBRACKET ruleU(R1) RBRACKET.{
// 	R = R1;
// 	R->toBeCompleted = false;
// 	if(R1->getBodyType() == BodyType::DISJUNCTION){
// 		throw syntax_exception("Unexpected DISJUNCTION in BODY of RULE.\n");
// 	}
// 	cout<<N->toString()<<SPACE<<"!("<<R1->toString()<<")"<<"\n";
// }

// // //ex 0.8536 (ruleU)
// rule(R) ::= number(N) LBRACKET ruleU(R1) RBRACKET.{
// 	R = R1;
// 	R->toBeCompleted = false;
// 	if(R1->getBodyType() == BodyType::CONJUNCTION){
// 		throw syntax_exception("Unexpected CONJUNCTION in HEAD of RULE.\n");
// 	}
// 	cout<<N->toString()<<SPACE<<"("<<R1->toString()<<")"<<"\n";
// }

// // //ex <= (ruleU).
// // //Test case wrong
// rule(R) ::= REVERSE_IMPLICATION LBRACKET ruleU(R1) RBRACKET DOT.{
// 	R = R1;
// 	R1->toBeCompleted = false;
// 	if(R1->getBodyType() == BodyType::DISJUNCTION){
// 		throw syntax_exception("Unexpected DISJUNCTION in BODY of RULE.\n");
// 	}
// 	cout<<"!("<<R1->toString()<<")."<<"\n";
// }

// // //ex (ruleU).
// // //Test case covered
// rule(R) ::= LBRACKET ruleU(R1) RBRACKET DOT.{
	// R = R1;
	// R->toBeCompleted = false;
	// if(R1->getBodyType() == BodyType::CONJUNCTION){
	// 	throw syntax_exception("Unexpected CONJUNCTION in HEAD of RULE.\n");
	// }
	// cout<<"("<<R1->toString()<<")."<<"\n";
// }


//B=>bottom
// ruleU(R) ::= body(B) CONJUNCTION bodydef(B1).{
// 	R = new RuleCompletion;
// 	B->appendStr(B1->getPredicate().toString(),false,false,true);
// 	R->appendStr(B->toString());
// 	R->setBodyType(BodyType::CONJUNCTION);
// 	delete B;
// 	delete B1;
// }

//ruleU's are all in brackets so no need for DOT, Number
//Top => H
// ruleU(R) ::= head(B) DISJUNCTION bodydef(B1).{
// 	R = new RuleCompletion;	
// 	R->isHeadTop = true;
// 	B->addPredicate(B1->getPredicate());
// 	// RULE_COMPLETION_HEAD_DIS_BODY_TOP(B,B1)
// 	try{
// 		RuleCompletion_HD_BT(B,tree);
// 	}
// 	catch(const std::out_of_range& e){
// 		throw syntax_exception("Error : Invalid number of arguments in some literal in the Rule.\n");
// 	}

// 	B->appendStr(B1->getPredicate().toString(),false,true,false);
// 	R->appendStr(B->toString());
// 	R->setBodyType(BodyType::DISJUNCTION);
// 	delete B;
// 	delete B1;
// }


//Parse Hard rule
//<= B.
//Test case covered
rule(R) ::= REVERSE_IMPLICATION body(B) DOT.{
	R = new RuleCompletion;
	R->isHeadTop = true;
	// B->appendStr(B->getPredicate().toString(),false,false,true);
	std::cout<<"!("<<B->toString()<<")."<<"\n";	
	delete B;
	// delete B1;
}

//Parse Hard rule
//H.
//Test case covered
rule(R) ::= head(B) DISJUNCTION bodydef(B1) DOT.{
	//Doing this 
	R = new RuleCompletion;
	R->isHeadTop = true;
	B->addPredicate(B1->getPredicate());
	// RULE_COMPLETION_HEAD_DIS_BODY_TOP(B,B1)
	try{
		RuleCompletion_HD_BT(B,tree);
	}
	catch(const std::out_of_range& e){
		throw syntax_exception("Error : Invalid number of arguments in some literal in the Rule.\n");
	}
	B->appendStr(B1->getPredicate().toString(),false,true,false);
	std::cout<<B->toString()<<"."<<"\n";
	delete B;
	delete B1;
}

//Parse soft rule
//0.8536 H.
//Test case covered
rule(R) ::= number(N) head(B) DISJUNCTION bodydef(B1).{
	//Doing this 
	R = new RuleCompletion;
	R->isHeadTop = true;
	B->addPredicate(B1->getPredicate());
	// RULE_COMPLETION_HEAD_DIS_BODY_TOP(B,B1)
	try{
		RuleCompletion_HD_BT(B,tree);
	}
	catch(const std::out_of_range& e){
		throw syntax_exception("Error : Invalid number of arguments in some literal in the Rule.\n");
	}
	B->appendStr(B1->getPredicate().toString(),false,true,false);
	std::cout<<N->toString()<<SPACE<<B->toString()<<"\n";
	delete B;
	delete B1;
}

//Parse hard rules
//B => H.
//Test case covered
rule(R) ::= head(H) REVERSE_IMPLICATION body(B) DOT.{
	R = new RuleCompletion;

	if (H->getDisjunction()){
		// RULE_COMPLETION_HEAD_DIS_BODY_TOP(H,B)
		R->isHeadTop = true;
		RuleCompletion_HD_BC(H,B,true,tree);
		std::cout<<B->toString()<<" => "<<H->toString()<<"."<<"\n";
		// std::cout << op;
	}
	else{
		// RULE_COMPLETION_BH(B,H);
		// R = new RuleCompletion(H->getPredicate(),predList, resultMap, varMap);
		try{
			R = RuleCompletion_BH(B,H,tree);
		}
		catch(const std::out_of_range& e){
			throw syntax_exception("Error : Invalid number of arguments in some literal in the Rule.\n");
		}
		std::cout<<B->toString()<<" => "<<H->toString()<<"."<<"\n";
	}
	delete B;
	delete H;
}

//Parse soft rules
//0.8536 B => H
//Test case covered
rule(R) ::= number(N) head(H) REVERSE_IMPLICATION body(B). {
	// RULE_COMPLETION_BH(B,H);
	// R = new RuleCompletion(H->getPredicate(),predList, resultMap, varMap);
	try{
		R = RuleCompletion_BH(B,H,tree);
	}
	catch(const std::out_of_range& e){
			throw syntax_exception("Error : Invalid number of arguments in some literal in the Rule.\n");
	}
	std::cout<< N->toString()<<SPACE<<B->toString()<<" => "<<H->toString()<<"\n";
	delete B;
	delete H;
}


//Ex. 0.8536 !!(B => H)
//Test case covered
rule(R) ::= number(N) NEGATION NEGATION LBRACKET head(H) REVERSE_IMPLICATION body(B) RBRACKET. {
	R = new RuleCompletion;
	R->isHeadTop = true;	
	tree->statHasDblNeg = true;
	std::cout<< N->toString() << SPACE <<"!!("<<B->toString()<<" => "<<H->toString()<<"\n"; 
	delete B;
	delete H;
}

rule(R) ::= LPAREN head(H) RPAREN REVERSE_IMPLICATION body(B) DOT.{
	
	if (H->getPredicate().checkEquality() != 0){
		throw syntax_exception("Cannot have equality/Inequlity as a part of choice rule\n");
	}

	// RULE_COMPLETION_BH(B,H);
	// R = new RuleCompletion(H->getPredicate(),predList, resultMap, varMap);
	try{
		R = RuleCompletion_BH(B,H,tree);
	}
	catch(const std::out_of_range& e){
			throw syntax_exception("Error : Invalid number of arguments in some literal in the Rule.\n");
	}
	std::cout<<COMMENT<<B->toString()<<" => "<<H->toString()<<"\n";
	delete B;
	delete H;
}

//Parses body of rules
body(B) ::= body(B1) CONJUNCTION bodydef(Bd).{
	B = B1;
	B1->addPredicate(Bd->getPredicate());
	B->appendStr(Bd->getPredicate().toString(),false,false,true);
	delete Bd;
}

head(H) ::= head(H1) DISJUNCTION bodydef(Hd).{
	H = H1;
	H1->addPredicate(Hd->getPredicate());
	H->appendStr(Hd->getPredicate().toString(),false,true,false);
	H->setDisjunction(true);
	delete Hd;
}

head(H) ::= bodydef(Bd).{
	H = new Head(Bd->getPredicate());
	// H->addPredicate(Bd->getPredicate());
	H->appendStr(Bd->getPredicate().toString(),false,false,false);
	delete Bd;
}

body(B) ::= bodydef(Bd).{
	B = new Body;
	B->addPredicate(Bd->getPredicate());
	B->appendStr(Bd->getPredicate().toString(),false,false,false);
	delete Bd;
}



// BodyDef without negation in front
bodydef(B) ::= literal(L).{	
	B = L;
}

// //BodyDef with negation in front
bodydef(B) ::= NEGATION literal(L).{	
	B = L;
	Predicate p = B->getPredicate();
	p.setSingleNegation(true);
	B->addPredicate(p);
	// B->getPredicate().setSingleNegation(true);
}

// //BodyDef with double negation in front
bodydef(B) ::= NEGATION NEGATION literal(L).{	
	B = L;
	tree->statHasDblNeg = true;
	B->getPredicate().setDoubleNegation(true);
}


// // BodyDef with double negation in front
// // Bodydefs of the form (!!Load(A,B)) => Load(A,B). which needs to be completed. 
bodydef(B) ::= LBRACKET NEGATION NEGATION literal(L) RBRACKET.{	
	B = L;
	tree->statHasDblNeg = true;
	B->getPredicate().setDoubleNegation(true);
}

//parses bodydef of the form a=b
bodydef(B) ::= string(S) EQUAL string(S1).{
	B = new BodyDef;
	auto itr = tree->variables.find(*(S->token));
	if (itr != tree->variables.end()){
		/*Treat it as a bodydef with 1 variable*/

		/* 
		Check if S1 is a valid value of it's domain.
		If it is not throw syntax_exception.
		Why? It could be a variable also which is not a part of the domain. 
		Not required in this case.
		*/

		// Domain d = itr->getRhsDomain();

		// if(std::find(d.getVars().begin(),d.getVars().end(),*(S1->token)) == d.getVars().end())
		// 	throw syntax_exception("The value on RHS does not belong to the Domain "+ d.getDomainVar() + ".\n");	
		
		std::vector<std::string> vars;
		vars.push_back(*(S1->token));
		Predicate p(S->token, vars);
		B->addPredicate(p);
		int expectedArgs = (tree->variables.find(*(S->token)))->getSize();
		if (expectedArgs != vars.size()){
			delete B;
			throw invalid_arguments(expectedArgs, vars.size(), *(S->token));
		}
	}
	
	else{
		Predicate p(S->token,S1->token);
		p.setEquality();
		B->addPredicate(p);
	}
}

//not HiddenIn=P1
bodydef(B) ::= NEGATION string(S) EQUAL string(S1).{
	std::vector<std::string> vars;
	vars.push_back(S1->toString());
	Predicate p(S->token, vars);
	p.setSingleNegation(true);
	B = new BodyDef;
	B->addPredicate(p);
	// delete Ve;
	int expectedArgs = (tree->variables.find(*(S->token)))->getSize();
	if (expectedArgs != vars.size()){
		delete B;
		throw invalid_arguments(expectedArgs, vars.size(), *(S->token));
	}
}
//parses bodydef of the form a!=b
bodydef(B) ::= string(S) NEGATION EQUAL string(S1).{
	
	/*check if S is declared in constant section
	 if it is then it's a syntax error 
	 Cannot have HiddeIn != P1 */
	auto itr = tree->variables.find(*(S->token));
	if (itr != tree->variables.end()){
		throw syntax_exception("!= cannot be used with a constant on LHS.\n");
	}

	Predicate p(S->token,S1->token);
	p.setInEquality();
	B = new BodyDef;
	B->addPredicate(p);
}


%type literal{BodyDef*}

literal(L) ::= string(S) LBRACKET variables(Ve) RBRACKET EQUAL variable(R).{
	std::vector<std::string> vars;
	for(auto& v : *Ve)
		vars.push_back(*v);
	vars.push_back(*(R->token));
	Predicate p(S->token, vars);
	L = new BodyDef;
	L->addPredicate(p);
	auto itr = tree->variables.find(S->toString());
	if(itr == tree->variables.end()){
		delete L;
		throw syntax_exception("Literal "+ S->toString() + " not found.\n");
	}
	delete Ve;
	int expectedArgs = (tree->variables.find(S->toString()))->getSize();
	if (expectedArgs != vars.size()){
		delete L;
		throw invalid_arguments(expectedArgs, vars.size(), *(S->token));
	}
}

literal(L) ::= string(S) LBRACKET variables(Ve) RBRACKET.{
	std::vector<std::string> vars;
	for(auto& v : *Ve)
		vars.push_back(*v);
	Predicate p(S->token, vars);
	L = new BodyDef;
	L->addPredicate(p);
	delete Ve;
	auto itr = tree->variables.find(S->toString());
	if(itr == tree->variables.end()){
		delete L;
		throw syntax_exception("Literal "+ S->toString() + " not found.\n");
	}
	int expectedArgs = itr->getSize();
	if (expectedArgs != vars.size()){
		delete L;
		throw invalid_arguments(expectedArgs, vars.size(), *(S->token));
	}	
}

literal(L) ::= variable(V).{
	Predicate p(V->token);
	auto itr = tree->variables.find(V->toString());
	// if(itr == tree->variables.end()){
	// 	throw syntax_exception("Literal "+ V->toString() + " not found.\n");
	// }
	L = new BodyDef;
	L->addPredicate(p);
}


predicate(P) ::= literal(L) DOT.{
	P = new Predicate;
	*P = L->getPredicate();
	std::string s1;
	cout<<P->toString(s1,true);
	delete L;
}
predicate(P) ::= number(N) literal(L).{
	P = new Predicate;
	*P = L->getPredicate();
	cout<<P->toString(N->toString()+SPACE, false);
	delete L;
}

predicate(P) ::= number(N) NEGATION NEGATION literal(L).{
	P = new Predicate;
	*P = L->getPredicate();
	P->notToBeCompleted();
	tree->statHasDblNeg = true;
	cout<<P->toString(N->toString()+SPACE, false);
	delete L;
}


predicate(P) ::= number(N) NEGATION literal(L).{
	P = new Predicate;
	*P = L->getPredicate();
	P->notToBeCompleted();
	cout<<P->toString(N->toString()+SPACE, false);
	delete L;
}


predicate(P) ::= NEGATION NEGATION literal(L) DOT.{
	P = new Predicate;
	*P = L->getPredicate();
	P->notToBeCompleted();
	tree->statHasDblNeg = true;
	std::string s1; 
	cout<<P->toString(s1, false);
	delete L;	
}



//Parses hard facts ex. next(0,1).
// predicate(P) ::=  string(S) LBRACKET variables(Ve) RBRACKET DOT. {
// 	// P = P1;
// 	P = new Predicate;
// 	P->setVar(S->token);
// 	P->setTokens(*Ve);
// 	// P->insertToken(*(R->token));
// 	std::string s1;
// 	cout<<P->toString(s1,true);
// 	delete Ve;
// }

// //Parses weighted/soft facts ex. 12 next(0,1)
// predicate(P) ::= number(N) string(S) LBRACKET variables(Ve) RBRACKET. {
// 	// P = P1;
// 	P = new Predicate;
// 	P->setVar(S->token);
// 	P->setTokens(*Ve);
// 	P->insertToken(*(R->token));
// 	cout<<P->toString(N->toString()+SPACE, false);
// 	delete Ve;
// }

// //Parses weighted/soft constraints ex. 
// // 0.4536 !!next(0,1)
// predicate(P) ::= number(N) NEGATION NEGATION string(S) LBRACKET variables(Ve) RBRACKET . {
// 	// P = P1;
// 	P = new Predicate;
// 	P->notToBeCompleted();
// 	tree->statHasDblNeg = true;
// 	P->setVar(S->token);
// 	P->setTokens(*Ve);
// 	// P->insertToken(*(R->token));
// 	cout<<P->toString(N->toString()+SPACE, false);
// 	delete Ve;
// }

// //0.8536 !load(T,T)
// predicate(P) ::= number(N) NEGATION string(S) LBRACKET variables(Ve) RBRACKET. {
// 	// P = P1;
// 	P = new Predicate;
// 	P->notToBeCompleted();
// 	P->setVar(S->token);
// 	P->setTokens(*Ve);
// 	// P->insertToken(*(R->token));
// 	cout<<P->toString(N->toString()+SPACE+"!", false);
// 	delete Ve;
// }
// //!!load(T,T).
// predicate(P) ::= NEGATION NEGATION string(S) LBRACKET variables(Ve) RBRACKET DOT. {
// 	// P = P1;
// 	P = new Predicate;
// 	P->notToBeCompleted();
// 	tree->statHasDblNeg = true;
// 	P->setVar(S->token);
// 	P->setTokens(*Ve);
// 	// P->insertToken(*(R->token));
// 	std::string s1; 
// 	cout<<P->toString(s1, false);
// 	delete Ve;
// }


// /*Next section parses predicates with multi valued domains*/

// //Parses hard facts ex. next(0,1).
// predicate(P) ::=  string(S) LBRACKET variables(Ve) RBRACKET EQUAL string(S1) DOT. {
// 	// P = P1;
// 	P = new Predicate;
// 	P->setVar(S->token);
// 	P->setTokens(*Ve);
// 	P->insertToken(S1->toString());
// 	std::string s1;
// 	cout<<P->toString(s1,true);
// 	delete Ve;
// }

// //Parses weighted/soft facts ex. 12 next(0,1)
// predicate(P) ::= number(N) string(S) LBRACKET variables(Ve) RBRACKET EQUAL string(S1). {
// 	// P = P1;
// 	P = new Predicate;
// 	P->setVar(S->token);
// 	P->setTokens(*Ve);
// 	P->insertToken(S1->toString());
// 	cout<<P->toString(N->toString()+SPACE, false);
// 	delete Ve;
// }

// //Parses weighted/soft constraints ex. 
// // 0.4536 !!next(0,1)
// predicate(P) ::= number(N) NEGATION NEGATION string(S) LBRACKET variables(Ve) RBRACKET EQUAL string(S1). {
// 	// P = P1;
// 	P = new Predicate;
// 	P->notToBeCompleted();
// 	tree->statHasDblNeg = true;
// 	P->setVar(S->token);
// 	P->setTokens(*Ve);
// 	P->insertToken(S1->toString());
// 	cout<<P->toString(N->toString()+SPACE, false);
// 	delete Ve;
// }

// //0.8536 !load(T,T)
// predicate(P) ::= number(N) NEGATION string(S) LBRACKET variables(Ve) RBRACKET EQUAL string(S1). {
// 	// P = P1;
// 	P = new Predicate;
// 	P->notToBeCompleted();
// 	P->setVar(S->token);
// 	P->setTokens(*Ve);
// 	P->insertToken(S1->toString());
// 	cout<<P->toString(N->toString()+SPACE+"!", false);
// 	delete Ve;
// }
// //!!load(T,T).
// predicate(P) ::= NEGATION NEGATION string(S) LBRACKET variables(Ve)  RBRACKET EQUAL string(S1) DOT. {
// 	// P = P1;
// 	P = new Predicate;
// 	P->notToBeCompleted();
// 	tree->statHasDblNeg = true;
// 	P->setVar(S->token);
// 	P->setTokens(*Ve);
// 	P->insertToken(S1->toString());
// 	std::string s1; 
// 	cout<<P->toString(s1, false);
// 	delete Ve;
// }




//Parses domains ex. step={1,2,3}
// domain(D) ::= string(S) EQUAL domains(Ds).{ 
// 	D = Ds;
// 	Ds->setDomainVar(S->token);
// }


//Parses RHS of domains
// domains(D) ::= LPAREN variables(Ve) RPAREN.{
// 	D = new Domain();
// 	D->setVars(*Ve);
// 	delete Ve;
// }

//Parses variables between () or {}
variables(Ve) ::= variable(V).{
	Ve = new std::vector<std::string*>();
	Ve->push_back(V->token);
}

variables(Ve) ::= variables(Ve2) COMMA variable(V).{
	Ve = Ve2;
	Ve2->push_back(V->token);
}

variable(V) ::= string(S). { V=S;}  
variable(V) ::= number(N). { V=N;} 

// variable(V) ::= PLUS string(S). { V=S;}  

string(S) ::= STRING(S1).{ S=S1;}


number(N) ::= NUMBER(N1).{ N=N1; }

