"""
This program implements 3 classic ciphers cipher

CPSC 353-01, Spring 2018
Project: 4
Sources: n/a

@author: Andrew Yang
@version v1.0 February 23, 2018

Instructions:
    invoke `>>> sage classic_ciphers.sage`
"""
import os.path
import re as regex

#tokenize is shared by all functions
#raw_file is a file with the message to be encrypted
#plain_txt is raw_file with alpha chars transformed to uppercase,
#white space removed, and eol inserted every fifty characters.
# def tokenize(raw_file,plain_txt):
def tokenize():
    filename = "raw_file.txt"
    read = 'r'
    write = 'w'

    if not os.path.isfile(filename):
        print "Error: no such file exists"
    else:
        with open(filename, read) as file:
            file_string = file.read().replace('\n','').replace(" ", "").upper()
            file_string = regex.sub(r'[\W_]+', '', file_string)
    print file_string
    return file_string

"""
affine cipher
"""
#returns returns a two-tuple containing alpha and beta, legal
#and randomly generated affine keys
def key_gen_aff():
    pass

#reads and encrypts plain_txt using the affine cipher and key.
#writes the output to the file cipher_txt
def enc_aff(key,plain_txt,cipher_txt):
    pass

#reads and decrypts cipher_txt using the affine cipher and key.
#writes the output to the file plain_txt
def dec_aff(key,cipher_txt,plain_txt):
    pass

if(__name__ == "__main__"):
    tokenize()
