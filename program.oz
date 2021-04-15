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
        'db'(single type:string default:CWD#"database/database.txt")
        'ans'(single type:string default:CWD#"autoplay/test_answers.txt"))} 
in 
    local
        NoGUI = Args.'nogui'
        DB = Args.'db'
        ANS = Args.'ans'
        Database = {ProjectLib.loadDatabase file DB}
        ListOfAnswers = {ProjectLib.loadCharacter file ANS}
        NewCharacter = {ProjectLib.loadCharacter file CWD#"new_character/new_character.txt"}

    fun {GetAllCharacters Database}
        {Reverse {GetAllCharactersAux Database nil}}
    end

    fun {GetAllCharactersAux Database L}
        case Database of nil then L
        [] H|T then {GetAllCharactersAux T H.1|L}
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

    fun {GetQuestions Database}
        {Arity Database.1}.2
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

    fun {DeleteInd L I}
        case L 
        of nil then nil
        [] H|T then
            if I == 0 then T 
            else H|{DeleteInd T (I-1)}
            end
        end
    end

    fun {GetCharacterOnName Database CharacterName}
        case Database of nil then nil
        [] H|T then 
            if H.1 == CharacterName then
                H
            else {GetCharacterOnName T CharacterName}
            end
        end
    end

    fun {CharacterContainsQuestion Character Question}
        {Contains {Arity Character} Question}
    end

    fun {GetCharactersOnQA Database Question Answer Characters}
        case Database 
        of nil then nil
        [] H|T then
            if {Contains Characters H.1} then 
                if {CharacterContainsQuestion {GetCharacterOnName Database H.1} Question} then
                    if H.Question == Answer then H.1|{GetCharactersOnQA T Question Answer Characters}
                    else {GetCharactersOnQA T Question Answer Characters}
                    end
                else H.1|{GetCharactersOnQA T Question Answer Characters}
                end
            else {GetCharactersOnQA T Question Answer Characters}
            end
        end
    end

    fun {CountQuestionCharactersFiltered Database CharactersTrue Question N}
        case Database 
        of nil then N
        [] H|T then
            if {Contains CharactersTrue H.1} then
                if {CharacterContainsQuestion {GetCharacterOnName Database H.1} Question} then
                    if H.Question == true then {CountQuestionCharactersFiltered T CharactersTrue Question N + 1}
                    else {CountQuestionCharactersFiltered T CharactersTrue Question N}
                    end
                else {CountQuestionCharactersFiltered T CharactersTrue Question N}
                end
            else 
                {CountQuestionCharactersFiltered T CharactersTrue Question N}
            end
        end
    end

    fun {ComputeCountersAux Database CharactersTrue QuestionsLeft Counters N}
        case QuestionsLeft 
        of nil then Counters
        [] H|T then
            local Cpt in
                Cpt = {CountQuestionCharactersFiltered Database CharactersTrue H 0}
                {ComputeCountersAux Database CharactersTrue T {Abs Cpt - (N-Cpt)}|Counters N}
            end
        end
    end

    fun {ComputeCounters Database CharactersTrue QuestionsLeft}
        {Reverse {ComputeCountersAux Database CharactersTrue QuestionsLeft nil {Length CharactersTrue}}}
    end

    fun {BuildDecisionTreeAux Database Characters Counters Questions}
        if {Length Questions} < 1 then leaf(1:Characters)
        else    
            if {Length Characters} < 2 then leaf(1:Characters)
            else
                local Min Question CharactersTrue CharactersFalse NewCounters NewQuestions in
                    Min = {MinPos Counters}
                    Question = {Nth Questions Min}
                    NewQuestions = {DeleteInd Questions Min}

                    CharactersTrue = {GetCharactersOnQA Database Question true Characters}
                    CharactersFalse = {GetCharactersOnQA Database Question false Characters}

                    %NewCounters = {DeleteInd Counters Min}
                    NewCounters = {ComputeCounters Database CharactersTrue NewQuestions}

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
        local Characters Questions Counters in
            Characters = {GetAllCharacters Database}
            Questions = {GetQuestions Database}
            Counters = {ComputeCounters Database Characters Questions}
            {BuildDecisionTreeAux Database Characters Counters Questions}
        end
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
                            noGUI:NoGUI 
                            builder:BuildDecisionTree 
                            autoPlay:ListOfAnswers 
                            %newCharacter:NewCharacter
                            )}
        {Application.exit 0}
    end
end