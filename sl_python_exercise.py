"""
    INFO: This exercise is not timed, and you may use any available resources.
    TODO: Please resolve the comments in the code below.
    TODO: Please refactor the code to make it more maintainable.
        - Add any new comments that you think would help.
"""

import argparse
import os
import re
from dataclasses import dataclass, field





@dataclass()
class Baz:
    """
    TODO: This class needs some documentation.
    @dataclass #This module provides a decorator and functions for automatically adding generated special methods such as __init__() and __repr__() to user-defined classes.
    class Baz is an object, which has attributes :
    p - a string ( used in main to look for sl_.*(* is whatever name).py files), '$' is chosen as the interpolation character
     q - a pattern (filepath type, like C:\\Users\\') r\" " is taking a raw string to avoid unicode problem (\\ or \ issue)
    a,b,c - integers initialized as 0
    and function init that takes arguments self,p,q
    """

    p: str = field(compare=False)
    q: re.Pattern = field(compare=False)

    a: int
    b: int
    c: int

    def __init__(self, p, q):
        """
        TODO: This function needs some documentation.
        self.p,self q - are constructors, and they take p and q values that were passed earlier
        self.a,self b,self c - constructors of ealrier integers
        Self is always pointing to Current Object.
        #a,b,c - integers that count :
        a - counts number of files with demanded extension sl_*.py
        b - counts number of lines in each file
        c- counts number of all characters in the files( including spaces too)
        d - is the name of each file
        e - is a list to be unwrapped
        f - is a list of all .py files in a location
        g - is combined name and location
        h - is the location of each file
        i - is what each file contains strored in a list and thus it is used to count all characters using j
        """

        self.p = p
        self.q = q

        a = b = c = 0

        for d, e, f in os.walk(q):
            for h in f:
                if re.compile(p).findall(h):

                    a += 1
                    # print(re.compile(p).findall(h))
                    # print(q)

                    with open(os.path.join(d, h), 'r') as g:
                        i = g.readlines()
                        b += len(i)
                        # print(e)

                        # print(g)
                        print(i)
                        for j in i:
                            c += len(j)

        self.a = a
        self.b = b
        self.c = c


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', default=r'^sl_.*\.py$')
    parser.add_argument('-q', default=os.getcwd())
    x = parser.parse_args()

    # help(Baz)
    print(Baz(x.p, x.q))


# My proposition of refractoring the code

@dataclass()
class Data:
    file_name: str = field(compare=False)
    file_location: re.Pattern = field(compare=False)

    number_of_files: int
    number_of_lines: int
    number_of_characters: int

    def __init__(self, file_name, file_location):

        self.file_name = file_name
        self.file_location = file_location

        number_of_files = number_of_lines = number_of_characters = 0

        for files, emptylist, files_list in os.walk(file_location):
            for file in files_list:
                if re.compile(file_name).findall(file):

                    number_of_files += 1
                    print(file)

                    with open(os.path.join(files, file), 'r') as file_combined:
                        line = file_combined.readlines()
                        number_of_lines += len(line)

                        for word in line:
                            number_of_characters += len(word)

        self.number_of_files = number_of_files
        self.number_of_lines = number_of_lines
        self.number_of_characters = number_of_characters


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-file_name', default=r'^sl_.*\.py$')
    parser.add_argument('-file_location', default=os.getcwd())
    file_to_search = parser.parse_args()

    help(Data)
    print(Data(file_to_search.file_name, file_to_search.file_location))
