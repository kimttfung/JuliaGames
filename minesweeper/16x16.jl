#Minesweeper 16x16

function placemine(grid) #randomly places a mine in a square in the grid where there isn't already a mine
    row, column = rand(1:16), rand(1:16)
    if grid[row][column]!="*"
        grid[row][column]="*"
    else
        placemine(grid)
    end
end

up_int(str::String) = string(parse(Int64,str)+1)

function update(g, r, c) #add one to the boxes next to a mine; split into sections horizontally
    if r>1
        update_c(g,r-1,c) #update row above
    end
    update_c(g,r,c) #update the same row
    if r<16
        update_c(g,r+1,c) #update row below
    end
end

function update_c(g, r, c) #adds one to the boxes next to a mine, vertically
    row = g[r]
    if c>1 && row[c-1]!="*"
        row[c-1] = up_int(row[c-1]) #update left column
    end
    if row[c]!="*"
        row[c] = up_int(row[c]) #update current column
    end
    if c<16 && row[c+1]!="*"
        row[c+1] = up_int(row[c+1]) #update right column
    end
end

function printgrid(grid) #prints the grid
    println("\n    A   B   C   D   E   F   G   H   I   J   K   L   M   N   O   P")
    println("  ╔═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╗")
    for r=1:16
        if r<10
            println(r," ║ ",grid[r][1]," ║ ",grid[r][2]," ║ ",grid[r][3]," ║ ",grid[r][4]," ║ ",grid[r][5]," ║ ",grid[r][6]," ║ ",grid[r][7]," ║ ",grid[r][8]," ║ ",grid[r][9]," ║ ",grid[r][10]," ║ ",grid[r][11]," ║ ",grid[r][12]," ║ ",grid[r][13]," ║ ",grid[r][14]," ║ ",grid[r][15]," ║ ",grid[r][16]," ║ ")
        else
            println(r,"║ ",grid[r][1]," ║ ",grid[r][2]," ║ ",grid[r][3]," ║ ",grid[r][4]," ║ ",grid[r][5]," ║ ",grid[r][6]," ║ ",grid[r][7]," ║ ",grid[r][8]," ║ ",grid[r][9]," ║ ",grid[r][10]," ║ ",grid[r][11]," ║ ",grid[r][12]," ║ ",grid[r][13]," ║ ",grid[r][14]," ║ ",grid[r][15]," ║ ",grid[r][16]," ║ ")
        end
        if r != 16
            println("  ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣")
        end
    end
    println("  ╚═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╝")
end

function search(letters, loc) #returns the index of the letter (from the input) in the array letters
    for i=1:length(letters)
        if letters[i] == string(loc[1])
            return i
        end
    end
end

function play(g, kg) #the main function that is called for every move
    letters = String["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]
    loc = lowercase(string(input("Choose a square to reveal. (eg. F4)\n")))
    r = parse(Int64,loc[2]) #the number corresponds to the row
    c = search(letters,loc) #the letter corresponds to the column
    value = g[r][c]
    if value == "*"
        printgrid(g)
        println("You Lose.")
        playagain = lowercase(string(input("Play again? Y/N\n")))
        if playagain == "y"
            restart()
        else
            exit()
        end
    end
    kg[r][c] = value
    if value == "0"
        checkzeros(kg, g, r, c)
    end
    printgrid(kg)
    remaining = 0
    for x=1:16
        for y in kg[x]
            if y == " "
                remaining = remaining + 1
            end
        end
    end
    if remaining <= 20
        printboard(g)
        println("You Win.")
        playagain = lowercase(string(input("Play again? Y/N\n")))
        if playagain == "y"
            restart()
        else
            exit()
        end
    end
    play(g,kg)
end

function checkzeros(kg, g, r, c) #function that checks that every square around each 0 is open
    oldkg = deepcopy(kg)
    openzero(kg, g, r, c)
    if oldkg==kg #check if there are any changes in the grid
        return
    end
    while true #loops through the grid to open any other 0s we find, creating a chain reaction
        oldkg = deepcopy(kg)
        for x=1:16
            for y=1:16
                if kg[x][y]=="0"
                    openzero(kg, g, x, y)
                end
            end
        end
        if oldkg==kg
            return
        end
    end
end

function openzero(kg, g, r, c) #opens all the squares around when 0 is found
    #Row above
    if r>1
        row = kg[r-1]
        if c>1
            row[c-1] = g[r-1][c-1]
        end
        row[c] = g[r-1][c]
        if c<16
            row[c+1] = g[r-1][c+1]
        end
    end
    #Same row
    row = kg[r]
    if c>1
        row[c-1] = g[r][c-1]
    end
    if c<16
        row[c+1] = g[r][c+1]
    end
    #Row below
    if r<16
        row = kg[r+1]
        if c>1
            row[c-1] = g[r+1][c-1]
        end
        row[c] = g[r+1][c]
        if c<16
            row[c+1] = g[r+1][c+1]
        end
    end
end

function restart() #the main function that initiates every game
    println("Welcome to Minesweeper by kfung.")
    println("Your goal is to find 20 mines(*) that are located in an 16x16 grid.")
    println("In each go, type to coordinates of the square you want to uncover, eg. G3")
    println("You lose if you choose a square with a mine.")
    println("Otherwise, the number of mines adjacent to a square (including diagonals) will be revealed.")
    println("Squares around 0 will be automatically reveal because they are no adjacent mines.")
    println("LET'S BEGIN!")
    grid = [["0" for j in 1:16] for k in 1:16]
    knowngrid = [[" " for j in 1:16] for k in 1:16]
    for i=1:20
        placemine(grid)
    end
    for row=1:16
        for column=1:16
            if grid[row][column] == "*"
                update(grid, row, column)
            end
        end
    end
    printgrid(knowngrid)
    play(grid, knowngrid)
end

restart()
