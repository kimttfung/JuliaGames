function convert2d(loc)
    if loc == 1 || loc == 2 || loc == 3
        return (1,loc)
    elseif loc == 4 || loc == 5 || loc == 6
        return (2, loc-3)
    elseif loc == 7 || loc == 8 || loc == 9
        return (3, loc-6)
    end
end

function insertchar(char, r, c)
    board[r][c] = char
end

isspacefree(r, c) = board[r][c] == " "

function printboard(board)
    println("╔═══╦═══╦═══╗")
    println("║ "*board[1][1]*" ║ "*board[1][2]*" ║ "*board[1][3]*" ║")
    println("╠═══╬═══╬═══╣")
    println("║ "*board[2][1]*" ║ "*board[2][2]*" ║ "*board[2][3]*" ║")
    println("╠═══╬═══╬═══╣")
    println("║ "*board[3][1]*" ║ "*board[3][2]*" ║ "*board[3][3]*" ║")
    println("╚═══╩═══╩═══╝")
end

function countspaces(a)
    counter = 0
    for element in a
        if element == " "
            counter = counter + 1
        end
    end
    return counter
end

function isboardfull(board)
    if countspaces(board[1]) > 0 || countspaces(board[2]) > 0 || countspaces(board[3]) > 0
        return false
    else
        return true
    end
end

function player1smove()
    whethermove=true
    while whethermove == true
        println(" ")
        println("Player 1 Select position to place X (1-9)")
        movelocation = readline()
        try
            move = parse(Int64,movelocation)
            if move > 0 && move < 10
                if isspacefree(convert2d(move)[1], convert2d(move)[2]) == true
                    whethermove = false
                    return (convert2d(move)[1], convert2d(move)[2])

                else
                    println("This postion is already filled!")
                end
            else
                println("Please type a number between 1-9")
            end
        catch
            println("Please type a number!")
        end
    end
end

function player2smove()
    whethermove=true
    while whethermove == true
        println(" ")
        println("Player 2 Select position to place O (1-9)")
        movelocation = readline()
        try
            move = parse(Int64,movelocation)
            if move > 0 && move < 10
                if isspacefree(convert2d(move)[1], convert2d(move)[2]) == true
                    whethermove = false
                    return (convert2d(move)[1], convert2d(move)[2])
                else
                    println("This postion is already filled!")
                end
            else
                println("Please type a number between 1-9")
            end
        catch
            println("Please type a number!")
        end
    end
end

randommove(list) = rand(list, 1)

function pms(r)
    pm = []
    for i in [x for (x, char) in enumerate(board[r]) if char == " "]
        push!(pm, i+3*(r-1))
    end
    pm
end


function computersmove()
    possiblemoves = append!(append!(pms(1), pms(2)), pms(3)) #list of possible moves
    move = 0

    #see is there is a winning move first
    for element in ["O","X"]
        for i in possiblemoves
            #println(i)
            boardCopy = deepcopy(board)
            boardCopy[(convert2d(i)[1])][(convert2d(i)[2])] = element
            if winner(boardCopy, element) == true
                move = i
                return (convert2d(move[1])[1], convert2d(move[1])[2])
            end
        end
    end

    #see if there is a corner
    cornersavailable = []
    for i in possiblemoves
        if i in [1,3,7,9]
            push!(cornersavailable,i)
        end
    end

    if length(cornersavailable) > 0
        move = randommove(cornersavailable)
        return (convert2d(move[1])[1], convert2d(move[1])[2])
    end

    #see if there is centre
    if 5 in possiblemoves
        move = 5
        return (convert2d(move[1])[1], convert2d(move[1])[2])
    end

    #see if there is an edge
    edgesavailable = []
    for i in possiblemoves
        if i in [2,4,6,8]
            push!(edgesavailable,i)
        end
    end

    if length(edgesavailable) > 0
        move = randommove(edgesavailable)
        return (convert2d(move[1])[1], convert2d(move[1])[2])
    else
        return ()
    end
end

function winner(board,char)
    if board[1][1] == char && board[1][2] == char && board[1][3] == char
        return true
    elseif board[2][1] == char && board[2][2] == char && board[2][3] == char
        return true
    elseif board[3][1] == char && board[3][2] == char && board[3][3] == char
        return true
    elseif board[1][1] == char && board[2][1] == char && board[3][1] == char
        return true
    elseif board[1][2] == char && board[2][2] == char && board[3][2] == char
        return true
    elseif board[1][3] == char && board[2][3] == char && board[3][3] == char
        return true
    elseif board[1][1] == char && board[2][2] == char && board[3][3] == char
        return true
    elseif board[1][3] == char && board[2][2] == char && board[3][1] == char
        return true
    else
        return false
    end
end

function main_ai()
    while !(isboardfull(board))
        if !(winner(board, "O"))
            move = player1smove()
            insertchar("X", move[1], move[2])
            printboard(board)
        else
            println("O's win this time...")
            playagain()
        end
        if !(winner(board, "X"))
            move = computersmove()
            if length(move) == 0
                println(" ")
                println("Game is a Tie! No more spaces left to move.") #a tie must end on the ninth move, after the 4th computersmove (8th move in the game)
                playagain()
            else
                insertchar("O", move[1], move[2])
                println(" ")
                println("Computer placed an O in position ", string((move[2])+3*((move[1])-1)), ":")
                printboard(board)

            end
        else
            println("X's win, good job!")
            playagain()
        end
    end
end

function main_2p()
    while !(isboardfull(board))
        if !(winner(board, "O"))
            move = player1smove()
            insertchar("X", move[1], move[2])
            printboard(board)
        else
            println("Player 2 / O's win, good job!")
            playagain()
        end

        if isboardfull(board)
            println(" ")
            println("Game is a Tie! No more spaces left to move.")
            playagain()
        end

        if !(winner(board, "X"))
            move = player2smove()
            insertchar("O", move[1], move[2])
            printboard(board)
        else
            println("Player 1 / X's win, good job!")
            playagain()

        end
    end
end

function landing()
    global board = [[" " for i in 1:3] for k in 1:3]
    println("Welcome to Tic Tac Toe, to win complete a straight line of your letter (Diagonal, Horizontal, Vertical). The board has positions 1-9 starting at the top left.")
    printboard(board)
    version = lowercase(string(input("Please enter the number of players: 1 or 2\n")))
    while !(version == "1" || version == "2")
        version = lowercase(string(input("Please enter the number of players: 1 or 2\n")))
    end
    if version == "1"
        main_ai()
    elseif version == "2"
        main_2p()
    end
end

function playagain()
    playagain = lowercase(string(input("Play again? Y/N\n")))
    while !(playagain == "y" || playagain == "n")
        playagain = lowercase(string(input("Play again? Y/N\n")))
    end
    if playagain == "y"
        landing()
    elseif playagain == "n"
        exit()
    end
end

landing()
