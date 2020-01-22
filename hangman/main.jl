include("graphics.jl")

function p1() #Player 1 gets to enter the word they want
    word = string(input("Player 1: Please enter the word to be guessed by Player 2\n"))
    for char in word
        if isnumeric(char)
            println("Please enter a word with no numbers!")
            p1()
        end
    end
    return lowercase(word)
end

function p2guess(already_guessed) #Function where P2 guesses a letter
    guess = string(input("Player 2: Please guess a letter\n"))
    if length(guess) != 1 #check whether its length is more or less than 1
        println("Please enter a letter, not word!")
        p2guess(already_guessed)
    end
    for char in guess #check whether it has numbers
        if isnumeric(char)
            println("Please enter a letter, not number!")
            p2guess(already_guessed)
        end
    end
    if guess in already_guessed #check whether the letter is already guessed
        println("Please enter a letter that's not guessed yet!")
        p2guess(already_guessed)
    end
    return lowercase(guess)
end


function display_hangman(lives, correctletters, incorrectletters)
    println(hangman[length(incorrectletters)+1]) #prints the correct hangman picture from graphics.jl
    println("\nLives left: $(lives)") #prints the lives left
    blanks = ["_" for i in 1:length(word)]
    for num in 1:length(word)
        letter = string(word[num])
        for i in correctletters
            if i == letter
                tempblanks = blanks[(num+1):end]
                blanks = append!(blanks[1:num-1], [letter])
                blanks = append!(blanks, tempblanks) #creating the new blanks array with correctletters filled in
            end
        end

    end
    print("Word: ")
    for j in blanks
        print(j, " ")
    end
    println()
    print("Missed Letters: ")
    for h in incorrectletters
        print(h, ", ")
    end
    println()
end


function playagain() #play again functionality
    playagain = lowercase(string(input("Do you want to play again? (Y/N)\n")))
    if playagain == "y"
        return true
    else
        return false
    end
end

function main()
    global word = p1()
    correctletters = []
    incorrectletters = []
    lettersinword = unique(split(word, ""))
    lives = 6
    gamedone = false
    run(`clear`)
    while true
        display_hangman(lives, correctletters, incorrectletters)
        guess = p2guess(append!(correctletters, incorrectletters))
        if (guess in lettersinword)
            push!(correctletters, guess)
            #checks whether all the letters have been found or not
            allfound = true #assuming that it is true until an exception is found (ie. whether player2 has won or not)
            for i in 1:length(word)
                if (string(word[i]) in correctletters) == false
                    allfound = false #exception is found here
                    break
                end
            end
            if allfound == true
                println("All letters have been found. Well done!")
                println("Player 2 has won! The word was $(word)!")
                gamedone = true
            end
        else
            push!(incorrectletters, guess)
            lives = lives - 1
            #checks whether they've ran out of lives
            if lives == 0
                display_hangman(lives, correctletters, incorrectletters)
                println("The word is $(word)")
                println("Player 1 has won! Player 2 didn't manage to guess the word!")
                gamedone = true
            end
        end
        #check whether they want to play again
        if gamedone == true
            if playagain()
                global word = p1()
                correctletters = []
                incorrectletters = []
                lettersinword = unique(split(word, ""))
                lives = 6
                gamedone = false
                run(`clear`)
            else
                break
            end
        end
    end
end

main()
