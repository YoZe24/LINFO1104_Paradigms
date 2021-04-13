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

    fun{Length L N}
        case L
        of nil then N
        [] H|T then {Length T N+1}
        end
    end

    fun {Reverse L A}
        case L of nil then A
        [] H|T then {Reverse T H|A}
        end
    end 

    fun {InitCounters Questions L}
        case Questions of nil then L
        [] H|T then {InitCounters T 0|L}
        end
    end

    % fun {CountAnswers Database Questions Counters}
    %     case Database of nil then Counters
    %     [] H|T then 
    %         %case Questions of nil then nil
    %         %[] H|T then {Count }
    %         {Print H}
    %         {Print Questions}
    %         {Print Counters}
    %         Counters
    %         %{CountSub H Questions Counters}
    %         %{CountAnswers T Questions Counters}
    %     end
    % end
    
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
            if H > Max then {MaxPosAux T N+1 H N}
            else {MaxPosAux T N+1 Max Pos}
            end
        end
    end 

    fun {Count Database Question N}
        case Database 
        of nil then N
        [] H|T then 
            if H.Question == true then {Count T Question N+1}
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
        of nil then tup(Question:N)
        [] H|T then 
            if H.Question == true then {CountTuple T Question N+1}
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


    % fun {BuildDecisionTreeAux Database Counters}

    % end

    % fun {BuildDecisionTree Database}

    % end

    

    fun {TreeBuilder Database}
        Questions
        Name
        Counters
        Characters
    in
        Characters = {Reverse {GetAllCharacters Database nil} nil}
        Questions = {Arity Database.1}.2
        %Counters = {InitCounters Questions nil}
        Counters ={Reverse {CountAnswers Database Questions nil} nil}

        {Print Characters} 
        {Print Questions}
        {Print Counters}
        {Print {CountAnswersTuple Database Questions nil}}
        %{Print {MaxPos Counters}}
        %{Print {Nth Questions {MaxPos Counters}}}
        {Print {GetAnswer Database.1 Questions.1}}
        {Print {GetName Database.1}}
        {Print {Nth Database 5}}
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
