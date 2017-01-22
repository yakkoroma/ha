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

structure TripleParser = struct 
    
    structure MT = MatchTree
    structure RE = RegExpFn (structure P = AwkSyntax structure E = BackTrackEngine)     
	
    fun testRegularExp(compiler, target) =
        let         
            val pattern = RE.compileString compiler
        in
            StringCvt.scanString (RE.find pattern) target
        end
    
    exception Null
    fun getCompiler ("Triple") =  "\\{([^,}]*)\\},\\{([^,}]*)\\},\\{([^,}]*)\\}"		
        | getCompiler ("") = raise Null (* Just to test the exception engine *)
        | getCompiler (_) = raise Null;
        
  
    fun getMatcher(compiler, target) =
        let         
            val compiler = getCompiler(compiler)
            val pattern = RE.compileString compiler
        in
            StringCvt.scanString (RE.find pattern) target           
        end
        
    exception notValidTriple
    fun parseTriple(target) =        
        let             
            val matcher = getMatcher("Triple", target)          
        in      
            if(Option.isSome( matcher ) ) then
                let 
                    val matchString = Option.valOf(matcher)
                    val preConditionMatch = MT.nth (matchString, 1)
                    val programMatch = MT.nth (matchString, 2)
                    val postConditionMatch = MT.nth (matchString, 3)                     
                in
                    { 
                      preCondition= String.extract(target, #pos(preConditionMatch) : int, SOME (#len(preConditionMatch))) ,
                      program= String.extract(target, #pos(programMatch) : int, SOME (#len(programMatch))),
                      postCondition= String.extract(target,#pos(postConditionMatch) : int, SOME (#len(postConditionMatch)))
                    }
                end
            else raise notValidTriple           
        end     
end