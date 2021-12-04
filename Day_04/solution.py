class BingoCard:

    def __init__ (self, card):
        num_dict = {}
        row_list = []
        col_list = []
        sum      =  0
        lines = card . rstrip () . split ("\n")
        rc = -1
        for line in lines:
            rc = rc + 1
            row_list . append (0)
            nums = line . strip () . split ()
            cc = -1
            for num in nums:
                cc = cc + 1
                if rc == 0:
                    col_list . append (0)
                num = int (num)
                num_dict [num] = rc, cc
                row_list [rc]  = row_list [rc] + 1
                col_list [cc]  = col_list [cc] + 1
                sum            = sum + num

        self . numbers = num_dict
        self . rows    = row_list
        self . cols    = col_list
        self . bingo   = False
        self . total   = sum  

    def play (self, number):
        if not self . bingo:
            if number in self . numbers:
                rc, cc = self . numbers [number]
                self . rows [rc] = self . rows [rc] - 1
                self . cols [cc] = self . cols [cc] - 1
                if self . rows [rc] == 0 or self . cols [cc] == 0:
                    self . bingo = True
                self . total = self . total - number


input = open ("input", mode = 'r') . read () . split ("\n\n")
balls = map (lambda b: int (b), input [0] . split (","))
cards = map (lambda sheet: BingoCard (sheet), input [1:])

first_score = -1
last_score  = -1
for ball in balls:
    for card in cards:
        card . play (ball)
        if card . bingo:
            if first_score < 0:
                first_score = ball * card . total
            last_score = ball * card . total
    cards = filter (lambda card: card . bingo == 0, cards)

print ("Solution 1: %d" %(first_score))
print ("Solution 2: %d" %(last_score))
