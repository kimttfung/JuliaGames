# VIDEO DEMONSTRATION: https://www.youtube.com/watch?v=iFlwYqjI448

# defining the possible options the user may choose in this game
options = ["rock", "paper", "scissors", "stop", "r", "p", "s"]

#a function allowing the user to define how many rounds they would like in the game
function enterrounds()

    rounds = string(input("Please enter the number of rounds: \n"))

    #tries to convert it to integer
    try
        value = parse(Int64, rounds)

        #when converted, it checks whether the integer is larger than or equal to 1
        (value < 1) ? (

            #restarts the function by recursion if not larger than or equal to 1
            println("Please enter an integer larger than or equal to 1!");
            enterrounds()
        ) : (return value) #else the value is returned
    catch

        #restarts function by recursion if not numeric
        println("Please enter an integer!")
        enterrounds()
    end
end

# function checking whether the input is in the defined array or not
function checkinput(option)

    #asks for input again if the input isn't defined
    while (option in options) == false
        option = lowercase(string(input("Enter Rock (or R), Paper (or P), Scissors (or S), or Stop (to end the game): \n")))
    end
    option
end

# function using ternary operator to check who wins the round
function winner(playermove, aimove)
    (playermove == aimove) ? (return "Tie") : ""
    (playermove == "r" && aimove == "p") ? (return "Computer") : ""
    (playermove == "p" && aimove == "s") ? (return "Computer") : ""
    (playermove == "s" && aimove == "r") ? (return "Computer") : (return "Player")
end

#converts the single-character responses back to full respones to be printed
function myconvert(move)
    (move == "r") ? (return "rock 👊🏻") : ""
    (move == "s") ? (return "scissors ✌🏻") : (return "paper 🖐🏻")
end

#function containing the main gameplay
function main()
    #determining how many rounds the player wants
    rounds = enterrounds()
    playercount = 0
    aicount = 0
    roundscount = 0

    for i in 1:rounds

        roundscount = roundscount + 1
        println()

        #prints the current round number
        println("Round ", string(roundscount))

        #asks for the player's input
        playermove = checkinput(lowercase(string(input("Enter Rock (or R), Paper (or P), Scissors (or S), or Stop (to end the game): \n"))))

        #prints out what the player chose
        println("Player Chose: ", uppercasefirst(myconvert(string(playermove[1]))))

        #check whether the player chose to stop, exits if they did choose to stop
        (playermove == "stop") ? (exit()) : (

            aimove = options[rand(1:3)];

            #prints out what the computer chose
            println("Computer Chose: ", uppercasefirst(myconvert(string(aimove[1]))));

            #determines the winner of the round
            roundwinner = winner(string(playermove[1]), string(aimove[1]));

            #prints out the winner of the round
            println("Round ", string(roundscount), "'s Winner: ",roundwinner);

            #adds 1 to the playercount if the player won
            (roundwinner == "Player") ? (playercount = playercount + 1) : "";

            #adds 1 to the aicount if the computer won
            (roundwinner == "Computer") ? (aicount = aicount + 1) : "";
        )

        #prints out the current statistics so far after each round
        println("Current Statistics:")
        println("   Player Score: ", string(playercount))
        println("   Computer Score: ", string(aicount))
    end
    println()

    #prints out the final result after the whole game is over
    print("RESULT: ")
    (playercount == aicount) ? (println("TIE")) : ""
    (playercount > aicount) ? (println("PLAYER WINS!!!")) : (println("COMPUTER WINS!!!"))

    #asks whether they would like to play again
    playagain()
end

function playagain()

    playagain = lowercase(string(input("Play again? Y/N\n")))

    #ternary operator deciding on whether to continue the game or quit
    (playagain == "y") ? main() : exit()
end

#runs the main function for the first gameplay
main()
