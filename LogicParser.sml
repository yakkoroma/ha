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

structure LogicParser = struct

fun tokenBreak #" " = true
	  | tokenBreak #"\t" = true      
	  | tokenBreak #"\n" = true
	  | tokenBreak _ = false
		  
	datatype token = LParen | RParen | Or | And | Not | Assign | Impl | BoolConstant of string | IntConstant of string | Variable of string
				   
	fun tokenize nil = nil
      | tokenize (s :: ts) =
		case s of 	      
		   "(" => LParen :: tokenize ts
		  | ")" => RParen :: tokenize ts
		  | "|" => Or :: tokenize ts
		  | "&" => And :: tokenize ts
		  | "!" => Not :: tokenize ts
		  | "=" => Assign :: tokenize ts
		  | "->" => Impl :: tokenize ts
		  | s => 
			(case (Real.fromString s) of
			 NONE => if (case (Bool.fromString s) of NONE => false | SOME r => true)
					 then (BoolConstant (s)) :: tokenize ts
					 else (Variable s) :: tokenize ts
			| SOME r => (IntConstant (Real.toString r)) :: tokenize ts)
	
	fun tokenToString t =
		case t of	    
		   LParen => "(" | RParen => ")"
		  | Assign => "="
		  | And => "&" | Not => "!"
		  | Or => "|" | Impl => "->"
		  | Variable s =>  s	  
		  | BoolConstant s =>  s
		  | IntConstant s =>  s	
	  
	fun parse s = 
		tokenize (String.tokens tokenBreak s);
	
	exception Error
	fun checkToken s nil =
		raise Error
      | checkToken s (t::tokens) =	
		if (s = t) then true 
	else
	    false
		
end