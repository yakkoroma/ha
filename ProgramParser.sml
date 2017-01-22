(*
 This file is part of HA - Hoare logic proof Assistant.

    HA is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    HA is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with HA.  If not, see <http://www.gnu.org/licenses/>.
	
	For more information read the note in the ha.cm file
*)

structure ProgramParser = struct

	fun tokenBreak #" " = true
		  | tokenBreak #"\t" = true      
		  | tokenBreak #"\n" = true
		  | tokenBreak _ = false
		  
	datatype token = LParen | RParen | If | Then | Else | While | Do | Skip | Assign | Conj 
                   | Eq | Minor | Plus | Implicate | Variable of string | IntConstant of string | BoolConstant of string
				   
	fun tokenize nil = nil
      | tokenize (s :: ts) =
	case s of 
	    "IF" => If :: tokenize ts	  
	  | "(" => LParen :: tokenize ts
	  | ")" => RParen :: tokenize ts
	  | "THEN" => Then :: tokenize ts
	  | "ELSE" => Else :: tokenize ts
	  | "WHILE" => While :: tokenize ts
	  | "DO" => Do :: tokenize ts
	  | "SKIP" => Skip :: tokenize ts
	  | ":=" => Assign :: tokenize ts
	  | ";" => Conj :: tokenize ts
	  | "=" => Eq :: tokenize ts
	  | "<" => Minor :: tokenize ts
	  | "+" => Plus :: tokenize ts	  	  
	  | s => 
	    (case (Real.fromString s) of
		 NONE => if (case (Bool.fromString s) of NONE => false | SOME r => true)
				then (BoolConstant (s)) :: tokenize ts
		 else (Variable s) :: tokenize ts
	       | SOME r => (IntConstant (Real.toString r)) :: tokenize ts)
		
	fun tokenToString t =
	case t of
	    If => "IF"	  
	  | LParen => "(" | RParen => ")"
	  | Then => "THEN" | Else => "ELSE"
	  | While => "WHILE" | Do => "DO" |  Skip => "SKIP" | Eq => "=" | Assign => ":="
	  | Conj => ";" | Minor => "<"
	  | Plus => "+" | Implicate => "->"
	  | Variable s => s (*more readable with "var" ^ s, but give trouble with destructuration in HoareLogic package*)
	  | IntConstant s =>  s
	  | BoolConstant s =>  s	  

	(* these ugly function are for List.exists purpose, it should be used another function taking in input the type 
	we are looking for and not just the element, or define the type as a function returning a boolean *)
	fun isConj s  =
		 case s of
			Conj => true
		 | s => false
		 
	fun isWhile s = 
		case s of
			While => true
		| s => false
	
	fun isIf s = 
		case s of
			If => true
		| s => false

	fun isAssign s = 
		case s of
			Assign => true
		| s => false
	
	fun parse s = 
		tokenize (String.tokens tokenBreak s);
end