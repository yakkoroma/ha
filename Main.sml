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

structure Main = struct
	fun getTriple() = 
		( print Messages.insertTriple; Option.valOf(TextIO.inputLine TextIO.stdIn) )
		
	fun parseAll (triple : {preCondition: string, program: string, postCondition: string}) = 
		let
			val program =  ProgramParser.parse( #program(triple) );
			val precondition = LogicParser.parse( #preCondition(triple) );
			val postcondition = LogicParser.parse( #postCondition(triple) );
		in
			{preCondition= precondition, program= program, postCondition= postcondition}
		end
		 
    fun run() =
		let
			(*val triple = TripleParser.parseTriple ("{a},{IF a THEN b ELSE c ; 21 ; true},{a}");*)	
			val triple = TripleParser.parseTriple ( getTriple() )	
			val tripleParsed = parseAll ( triple )
		in
			HoareLogic.validate ( tripleParsed ) 			
		end	
end