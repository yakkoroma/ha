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

structure Messages = struct
    val insertTriple = "******\n*INSERT A HOARE TRIPLE IN THE FORM {precondition},{program},{postcondition}\n> "    
	val trueRule = "+ True found in postcondition, everything is allowed: triple is valid\n"
    val falseRule = "+ False found in precondition, everything is allowed: triple is valid\n"
	val isConj = "+ Ther's a composition in the program, you should Compose them as first rule [8]\n"
	val isWhile = "+ Ther's a while in the program, you should use it's rule now  [7]\n"
	val isIf = "+ Ther's an if in the program, you should use it's rule now  [6]\n"
	val isAssign = "+ Ther's an assignment in the program, you should use it's rule now  [5]\n"
	val useConj = "* Choose the midcondition\n> "
	val useWhile = "* Choose the invariant\n> "
	fun invariant s: string =  "\n + Hint: try the (" ^ s ^ ") Invariant \n"
	val yourTripleBegin = "----------\n|\n|\tYOUR TRIPLE NOW IS\n| "
	val yourTripleEnd = "\n|\n__________\n"
	val availableRules = "\n****** Chose a rule for the next step\n0) End this branch\n1)x Strongest precondition\n2)x Weaknest postcondition\n3)x And in postcondition\n4)x Or in precondition\n5) Assign\n6) If\n7) While\n8) Composition\n\n\n"
end