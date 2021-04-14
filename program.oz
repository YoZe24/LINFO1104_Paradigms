functor
import
    ProjectLib
    Browser
    OS
    System
    Application
define
    CWD = {Atom.toString {OS.getCWD}}#"/"
    Browse = proc {$ Buf} {Browser.browse Buf} end
    Print = proc{$ S} {System.print S} end
    Args = {Application.getArgs record(
        'nogui'(single type:bool default:false optional:true)
        'db'(single type:string default:CWD#"database/database.txt"))} 
in 
    local
        NoGUI = Args.'nogui'
        DB = Args.'db'
        Database = {ProjectLib.loadDatabase file Args.'db'}
        NewCharacter = {ProjectLib.loadCharacter file CWD#"new_character.txt"}

        % Vous devez modifier le code pour que cette variable soit
        % assigné un argument 	
        ListOfAnswersFile = CWD#"test_answers.txt"
        ListOfAnswers = {ProjectLib.loadCharacter file CWD#"test_answers.txt"}

    proc {PrintDatabase Database}
        case Database of nil then {Print nil}
        [] H|T then
            {Print H}
            {PrintDatabase T}
        end
    end

    fun {GetAllCharacters Database L}
        case Database of nil then L
        [] H|T then {GetAllCharacters T H.1|L}
        end
    end

    fun {Length L}
        {LengthAux L 0}
    end

    fun{LengthAux L N}
        case L
        of nil then N
        [] H|T then {LengthAux T N + 1}
        end
    end

    fun {Reverse L}
        {ReverseAux L nil}
    end

    fun {ReverseAux L A}
        case L of nil then A
        [] H|T then {ReverseAux T H|A}
        end
    end 

    fun {InitCounters Questions L}
        case Questions of nil then L
        [] H|T then {InitCounters T 0|L}
        end
    end
    
    fun {GetAnswer Character Question}
        Character.Question
    end 

    fun {GetName Character}
        Character.1
    end

    fun {Head Xs}
        Xs.1
    end

    fun {Tail Xs}
        Xs.2
    end

    fun {Nth L N}
        if N == 0 then {Head L}
        else {Nth {Tail L} N - 1}
        end
    end

    fun {MaxPos L}
        {MaxPosAux L 0 0 0}
    end

    fun {MaxPosAux L N Max Pos}
        case L
        of nil then Pos
        [] H|T then
            if H > Max then {MaxPosAux T N + 1 H N}
            else {MaxPosAux T N + 1 Max Pos}
            end
        end
    end 

    fun {Nearest L}
        {NearestAux L 0 ({Length L} div 2) 99999999 0}
    end

    fun {NearestAux L N Size Near Pos}
        case L
        of nil then Pos
        [] H|T then
            if {Abs Size - H} < Near then {NearestAux T N + 1 Size H N}
            else {NearestAux T N + 1 Size Near Pos}
            end
        end
    end 

    fun {Count Database Question N}
        case Database 
        of nil then N
        [] H|T then 
            if H.Question == true then {Count T Question N + 1}
            else {Count T Question N}
            end
        end
    end

    fun {CountAnswers Database Questions Counters}
        case Questions 
        of nil then Counters
        [] H|T then
            {CountAnswers Database T {Count Database H 0}|Counters}
        end
    end

    fun {CountTuple Database Question N}
        case Database 
        of nil then tup(Question N)
        [] H|T then 
            if H.Question == true then {CountTuple T Question N + 1}
            else {CountTuple T Question N}
            end
        end
    end

    fun {CountAnswersTuple Database Questions Counters}
        case Questions 
        of nil then Counters
        [] H|T then
            {CountAnswersTuple Database T {CountTuple Database H 0}|Counters}
        end
    end

    fun {TupleCreate Key Value}
        tup(Key Value)
    end

    fun {TupleGetValue Tuple}
        Tuple.2
    end

    fun {ListGetTuple L Key}
        case L of nil then {TupleCreate null null}
        [] H|T then 
            if H.1 == Key then H
            else {ListGetTuple T Key}
            end
        end
    end

    fun {ListGetTupleValue L Key}
        {ListGetTuple L Key}.2
    end

    fun {Map L F} 
        case L of nil then nil
        [] H|T then {F H}|{Map T F}
        end
    end

    fun {MapListTupleValue L F}
        case L of nil then nil
        [] H|T then {F {TupleGetValue H}}|{MapListTupleValue T F}
        end
    end

    fun {Contains L E}
        case L
        of nil then false
        [] H|T then
            if H == E then true
            else {Contains T E}
            end
        end
    end

    fun {Abs I}
        if I < 0 then ~I
        else I
        end
    end

    % fun {DeleteFirstAux L E NL}
    %     case L 
    %     of nil then NL
    %     [] H|T then
    %         if H == E then T|NL % erreur 1 2 3 4 5 remove 3 => 4 5 2 1, p-e faire non tail recursiv
    %         else {DeleteFirstAux L E H|NL}
    % end

    % fun {GetCharacter Database Question Answer Characters CharactersAnswer}
    %     case Database 
    %     of nil then CharactersAnswer
    %     [] H|T then
    %         if {Contains CharactersAnswer H.1} then 
    % end

    % fun {BuildDecisionTreeAux Database Counters Questions T}
    %     local Max in
    %         Max = {MaxPos Counters}
    %         {BuildDecisionTreeAux Database Counters}
    %     end

    %     case Counters 
    %     of nil then T
    %     [] H|T then
    %     end
    % end

    % fun {BuildDecisionTree Database}

    % end

    fun {TreeBuilder Database}
        Questions
        Name
        Counters
        Characters
        Test
    in
        Characters = {Reverse {GetAllCharacters Database nil}}
        Questions = {Arity Database.1}.2
        %Counters = {InitCounters Questions nil}
        Counters = {Reverse {CountAnswers Database Questions nil}}
        

        %Test = {TupleCreate aze 2}
        %{Print {TupleGetValue Test aze}}
        %{Print Test}
        Test = {CountAnswersTuple Database Questions Counters}
        %{Print {ListGetTupleValue Test 'Porte-t-il des lunettes ?'}}
        
        {Print Test}
        %{Print {MapListTupleValue Test fun {$ X} X*X end}}
        %{Print {Nearest Counters}}
        %{Print Characters} 
        %{Print Questions}
        %{Print Counters}
        %{Print {MaxPos Counters}}
        %{Print {Nth Questions {MaxPos Counters}}}
        %{Print {GetAnswer Database.1 Questions.1}}
        %{Print {GetName Database.1}}
        %{Print {Nth Database 5}}
        %{PrintDatabase Database}
        leaf(nil)
    end

    fun {GameDriver Tree}
        Result
    in
        Result = aze
        unit
    end
    in
        {ProjectLib.play opts(characters:Database driver:GameDriver 
                            noGUI:NoGUI builder:TreeBuilder 
                            autoPlay:ListOfAnswers newCharacter:NewCharacter)}
        {Application.exit 0}
    end
end
