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

structure HoareLogic = struct 
	fun gatherString xs = 
      foldl (fn (x,acc) =>
                acc  ^ " " ^ x) (hd xs) (tl xs)
	fun hint (triple : {preCondition: LogicParser.token list,
						program: ProgramParser.token list, 
						postCondition: LogicParser.token list} )	= 
		(
			let 
				val postcondition = #postCondition(triple)
				val precondition = #preCondition(triple)
				val program = #program(triple)
			in
				if(List.length postcondition = 1) then
						if ( (LogicParser.checkToken (LogicParser.BoolConstant "true") postcondition ) ) 
							then (print Messages.trueRule;true ) 
							else false				
				else
					false			
				;
				if(List.length precondition = 1) then
						if ( (LogicParser.checkToken (LogicParser.BoolConstant "false") precondition  ) ) 
							then (print Messages.falseRule;true ) 
							else false				
				else
					false
				;
				if( List.exists ProgramParser.isConj  program) then
					(print Messages.isConj;true )
				else false
				;
				if( List.exists ProgramParser.isWhile  program) then
					(print Messages.isWhile;true )
				else false
				;
				if( List.exists ProgramParser.isIf  program ) then
					(print Messages.isIf;true )
				else false
				;
				if( List.exists ProgramParser.isAssign  program ) then
					(print Messages.isAssign;true )
				else false
			end
		)
	
	fun printTriple(triple : {preCondition: LogicParser.token list, 
							   program: ProgramParser.token list, 
							   postCondition: LogicParser.token list}) =
			let 
				val precondition = 	List.map LogicParser.tokenToString (#preCondition(triple))
				val program = List.map ProgramParser.tokenToString (#program(triple))
				val postcondition = List.map LogicParser.tokenToString (#postCondition(triple))				
			in
				( 
				print Messages.yourTripleBegin;
				print "{"; List.map print precondition; print "},{";
				List.map print program; print "},{"; List.map print postcondition; print "}";
				print Messages.yourTripleEnd;
				true
				)
			end
							
					
    exception ValueNotFoundInList
	fun indexOf(x, []) = raise ValueNotFoundInList
		| indexOf (x, y::ys) =
			if x = y then 0 else 1 + indexOf (x, ys)
			
			
	exception NoValidOption
	fun validate ( triple : {preCondition: LogicParser.token list, 
							   program: ProgramParser.token list, 
							   postCondition: LogicParser.token list} ) = 
			(*rules application*)				
			(
				print Messages.availableRules;
				hint triple;
				print "\n > " ;
				useRule  ( Option.valOf(TextIO.inputLine TextIO.stdIn) ) triple				
			)					
	and	
	useRule s ( triple : {preCondition: LogicParser.token list,
							  program: ProgramParser.token list,
							  postCondition: LogicParser.token list} ) = 
		case s of 
			  "0\n" => true
			| "5\n" => UseAssign triple
			| "6\n" => UseIf triple
			| "7\n" => UseWhile triple
			| "8\n" => UseConj triple			
		    | s => raise NoValidOption
	and	    
	UseConj  ( triple : {preCondition: LogicParser.token list, 
							   program: ProgramParser.token list, 
							   postCondition: LogicParser.token list} ) = 
		let
			val	program = #program(triple)
			val _ = print Messages.useConj
			val midTerm = Option.valOf(TextIO.inputLine TextIO.stdIn)
			(*it could be easily extend on more than 1 composition for triple*)
			val firstProgram =  List.take ( #program(triple) , indexOf(ProgramParser.Conj, program))
			val secondProgram = List.drop ( #program(triple) , ( indexOf(ProgramParser.Conj, program) + 1 ))
			(* ask for midterm, parse it, and duplicate the triple for derivate both in DFS style*)
			val midTermParsed = LogicParser.parse( midTerm )
			val firstTriple = {preCondition = #preCondition(triple), program = firstProgram, postCondition = midTermParsed }
			val secondTriple = {preCondition = midTermParsed, program = secondProgram, postCondition = #postCondition(triple) }
		in
				(
				printTriple(firstTriple);
				validate(firstTriple);
				printTriple(secondTriple);
				validate(secondTriple);				
				true
				)
		end
	and (*it permforms the sobstitution of the value of the var assigned in program inside the name of the var into the preCondition*)
	UseAssign ( triple : {preCondition: LogicParser.token list, 
							   program: ProgramParser.token list, 
							   postCondition: LogicParser.token list} ) = 
				let 
					val assignPosition = indexOf(ProgramParser.Assign, #program(triple))
					val varName = List.nth ( #program(triple), (assignPosition - 1))
					val varValue = List.drop (#program(triple), (assignPosition + 1))					
					val varInPreCondition = indexOf(LogicParser.Variable (ProgramParser.tokenToString(varName)), #preCondition(triple) )
					val beforeAssign = List.take ( #preCondition(triple) , ( varInPreCondition ) )										
					val afterAssign = List.drop ( #preCondition(triple) ,  ( varInPreCondition + 1 ) )					
					val subList = List.map ProgramParser.tokenToString varValue (*destructurate from ProgramParser datatype*)
					val assignedValue =  LogicParser.parse ( gatherString subList ) (*restructurate on LogicParser datatypes*)
					val triple = {preCondition = beforeAssign @ assignedValue @ afterAssign, 
								  program = #program(triple), 
								  postCondition = #postCondition(triple)}			
				in
					printTriple(triple);validate(triple);true
				end
	and
	UseWhile ( triple : {preCondition: LogicParser.token list, 
							   program: ProgramParser.token list, 
							   postCondition: LogicParser.token list} ) = 
			let
				val whilePosition = indexOf(ProgramParser.While, #program(triple))
				val doPosition = indexOf(ProgramParser.Do, #program(triple))
				val guard = List.drop ( List.take ( #program(triple) , doPosition) , ( whilePosition + 1 ) )
				val body = List.drop ( #program(triple) , (doPosition + 1) )
				val invariantToShow = gatherString (List.map ProgramParser.tokenToString guard)
				val _ = print  ( Messages.invariant invariantToShow )
				val _ = print Messages.useWhile
				val preCondition = #preCondition(triple) @ LogicParser.parse(" & " ^ (Option.valOf(TextIO.inputLine TextIO.stdIn)))
				val triple = {preCondition = preCondition, program = body, postCondition = #postCondition(triple)}
			in (
					printTriple(triple);
					validate(triple);
					true				
				)
			end
	and
	UseIf ( triple : {preCondition: LogicParser.token list, 
							   program: ProgramParser.token list, 
							   postCondition: LogicParser.token list} ) = 
			let
				val ifPosition = indexOf(ProgramParser.If, #program(triple))
				val thenPosition = indexOf(ProgramParser.Then, #program(triple))
				val elsePosition = indexOf(ProgramParser.Else, #program(triple))
				val condition =  List.drop ( List.take ( #program(triple) , thenPosition) , ( ifPosition + 1 ) )
				val positive = List.drop ( List.take ( #program(triple) , elsePosition) , ( thenPosition + 1 ) )
				val negative = List.drop ( #program(triple) , (elsePosition + 1) )
				val firstPrecondition = #preCondition(triple) @ LogicParser.parse(" & " ^ ( gatherString (List.map ProgramParser.tokenToString condition)))
				val secondPrecondition = #preCondition(triple) @ LogicParser.parse(" & ! " ^ (gatherString (List.map ProgramParser.tokenToString condition)))
				val firstTriple = {preCondition= firstPrecondition, program= positive, postCondition= #postCondition(triple)}
				val secondTriple = {preCondition= secondPrecondition, program= negative, postCondition= #postCondition(triple)}
			in
				printTriple(firstTriple);
				validate(firstTriple);
				printTriple(secondTriple);
				validate(secondTriple);				
				true
			end
				
end