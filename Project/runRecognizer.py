from recognizer import Recognizer

def main(filename):
    r = Recognizer(filename)
    r.parse()

main("program.txt")
# main("bad_program.txt")