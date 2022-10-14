from time import sleep
from os import system,name,get_terminal_size
from random import randrange

verdes = ["1;32;40","2;32;40","3;32;40","3;36;40","1;37;102"]

def printVerde(txt,qual):
    verde = verdes[qual]
    return "\x1b[{}m{}\x1b[0m".format(verde,txt)

def limpar():
    print("\033[H")

print("\033[2J")
# Get the size
# of the terminal
size = get_terminal_size()
lines = size.lines
columns = size.columns

letters = [  {} for x in range(int(columns/4))]

for y in range(len(letters)):
    letters[y]["pos_x"] = randrange(0,columns-1)
    letters[y]["pos_y"] = randrange(0,lines-1)
    letters[y]["txt"] = ""

while True:
    limpar()
    entireTerminal = [[" " for y in range(lines-1)] for x in range(columns-1)]
    for column in letters:
        letra = chr(randrange(33, 127))

        if randrange(0,int(lines/2)) != 0:
            column["txt"] = column["txt"]+letra
        else:
            column["pos_x"] = randrange(0,columns-1)
            column["pos_y"] = randrange(0,lines-1)
            column["txt"] = letra

        pos_x = column["pos_x"]
        pos_y = column["pos_y"]
        for i,c in enumerate(column["txt"]):
            if i == len(column["txt"]) -1:
                formatedChar = printVerde(c,4)
            else:
                formatedChar = printVerde(c,randrange(0,4))
            entireTerminal[pos_x][(pos_y+i)%(lines-2)] = formatedChar
    for x in range(lines-1):
        for y in range(columns-1):
            letra = entireTerminal[y][x]
            print(letra,end="")
        print()
    sleep(0.1)