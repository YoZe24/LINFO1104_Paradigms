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

    fun {GetAllCharactersAux Database L}
        case Database of nil then L
        [] H|T then {GetAllCharactersAux T H.1|L}
        end
    end
    
    fun {GetAllCharacters Database}
        {Reverse {GetAllCharactersAux Database nil}}
    end

    fun {GetCharacterName Database Name}
        case Database of nil then nil
        [] H|T then 
            if H == Name then H 
            else {GetCharacterName T Name}
            end
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

    fun {GetQuestions Database}
        {Arity Database.1}.2
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

    fun {MinPos L}
        {MinPosAux L 0 9999999999 0}
    end

    fun {MinPosAux L N Min Pos}
        case L
        of nil then Pos
        [] H|T then
            if H < Min then {MinPosAux T N+1 H N}
            else {MinPosAux T N+1 Min Pos}
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

    fun {CountAnswersAux Database Questions Counters N}
        case Questions 
        of nil then Counters
        [] H|T then
            local Cpt in
                Cpt = {Count Database H 0}
                {CountAnswersAux Database T {Abs Cpt - (N-Cpt)}|Counters N}
                % {CountAnswersAux Database T Cpt|Counters N}
            end
        end
    end

    fun {CountAnswers Database}
        local Questions in
            Questions = {GetQuestions Database}
            {Reverse {CountAnswersAux Database Questions nil {Length Database}} }
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

    fun {DeleteFirstElement L E}
        case L 
        of nil then nil
        [] H|T then
            if H == E then T 
            else H|{DeleteFirstElement T E}
            end
        end
    end

    fun {DeleteInd L I}
        case L 
        of nil then nil
        [] H|T then
            if I == 0 then T 
            else H|{DeleteInd T (I-1)}
            end
        end
    end

    fun {GetCharacter Database Question Answer Characters}
        case Database 
        of nil then nil
        [] H|T then
            if {Contains Characters H.1} then 
                if H.Question == Answer then H.1|{GetCharacter T Question Answer Characters}
                else {GetCharacter T Question Answer Characters}
                end
            else {GetCharacter T Question Answer Characters}
            end
        end
    end

    fun {BuildDecisionTreeAux Database Characters Counters Questions}
        if {Length Questions} < 1 then leaf(1:Characters)
        else    
            if {Length Characters} < 2 then leaf(1:Characters)
            else
                local Min Question CharactersTrue CharactersFalse NewCounters NewQuestions in
                    Min = {MinPos Counters}
                    Question = {Nth Questions Min}
                    NewCounters = {DeleteInd Counters Min}
                    NewQuestions = {DeleteInd Questions Min}

                    CharactersTrue = {GetCharacter Database Question true Characters}
                    CharactersFalse = {GetCharacter Database Question false Characters}

                    question(
                        1:Question 
                        true:{BuildDecisionTreeAux Database CharactersTrue NewCounters NewQuestions}
                        false:{BuildDecisionTreeAux Database CharactersFalse NewCounters NewQuestions}
                    )
                end 
            end
        end
    end

    fun {BuildDecisionTree Database}
        {BuildDecisionTreeAux Database {GetAllCharacters Database} {CountAnswers Database} {GetQuestions Database}}
    end

    % fun {DeleteRecordField Record FieldToDelete Fields R}
    %     case Fields 
    %     of nil then R
    %     [] H|T then
    %         if H == FieldToDelete then {DeleteRecordField Record FieldToDelete T R}
    %         else R.H  {DeleteRecordField Record FieldToDelete T}
    % end
    

    fun {TreeBuilder Database}
        Questions
        Name
        Counters

        Characters
        CharQ1
        Tree
    in
        Characters = {GetAllCharacters Database}
        Questions = {Arity Database.1}.2
        %Counters = {InitCounters Questions nil}
        %Counters ={Reverse {CountAnswers Database Questions nil} nil}
        Counters = {CountAnswers Database}
        CharQ1 = {GetCharacter Database Questions.1 false Characters}
        %Tree = {BuildDecisionTreeAux Database Characters Counters Questions}
        
        Tree = {BuildDecisionTree Database}
        {Print Tree}
        
        % {Print CharQ1}
        % {Print Characters} 
        {Print Questions}
        % {Print {DeleteFirstElement Questions 'Est-ce que c\'est une fille ?'}}
        
        %{Print {Nth Questions {MinPos Counters}}}
        Tree
    end

    fun {GameDriver Tree}
        Result
    in
        if {Label Tree} == 'leaf' then 
            Result = {ProjectLib.found Tree.1}
        elseif {ProjectLib.askQuestion Tree.1} then
            Result = {GameDriver Tree.true}
        else
            Result = {GameDriver Tree.false}
        end
        
        if Result == false then
            {Browse 'Wtf bro'}
        else 
            {Browse Result}
        end

        unit
    end
    in
        {ProjectLib.play opts(
                            characters:Database 
                            driver:GameDriver 
                            noGUI:false 
                            builder:TreeBuilder 
                            autoPlay:ListOfAnswers 
                            %newCharacter:NewCharacter
                            )}
        {Application.exit 0}
    end
end
