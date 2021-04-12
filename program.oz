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

    fun {CountAnswers Database Questions Counters}
        case Database of nil then Counters
        [] H|T then 
            %case Questions of nil then nil
            %[] H|T then {Count }
            {Print H}
            {Print Questions}
            {Print Counters}
            Counters
            %{CountSub H Questions Counters}
            %{CountAnswers T Questions Counters}
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
        if N == 1 then {Head L}
        elseif N > 1 then
            {Nth {Tail L} N - 1}
        end
    end

    fun {TreeBuilder Database}
        Questions
        Name
        Counters
        Characters
    in
        Characters = {Reverse {GetAllCharacters Database nil} nil}
        Questions = {Arity Database.1}.2
        Counters = {InitCounters Questions nil}
        %Counters = {CountAnswers Database Questions Counters}

        {Print Characters}
        {Print Questions}
        {Print Counters}
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
