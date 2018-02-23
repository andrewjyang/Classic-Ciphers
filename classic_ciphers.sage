"""
This program implements 3 classic ciphers: Affine, Vigenere, and Alphabetic
    Transposition Cipher

CPSC 353-01, Spring 2018
Project: 4
Sources: n/a

@authors: Andrew Yang and Jeb Kilfoyle
@version v1.0 February 23, 2018

Instructions:
    invoke `>>> sage classic_ciphers.sage`
"""
import os.path
import re as regex
import random
import math

# alpha is ordered alphabet
#num are the integers 0:25.
#dict is a dictionary with letters as keys, and numbers as values.
alpha = [chr(i) for i in range (ord('A'),ord('Z')+1)]
num = [i for i in range(26)]
dict = {k: v for k, v in zip(alpha, num)}

def tokenize(raw_file, plain_txt):
    """
    Description: tokenize() parses the raw_file.txt by transforming all alpha
        characters to uppercase, removing all white space, and inserts an end of
        line every fifty characters
    Arguments:
        raw_file(file): raw_file is a file with the message to be encrypted
        plain_txt(file): plain_txt is raw_file with alpha chars transformed to uppercase,
            white space removed, and eol inserted every fifty characters.
    Returns:
        plain_txt(file): plain_txt is raw_file with alpha chars transformed to uppercase,
            white space removed, and eol inserted every fifty characters.
    """
    if not os.path.isfile(raw_file):
        print "Error: no such file exists"
    else:
        with open(raw_file, 'r') as raw_text:
            rt_string = raw_text.read().replace('\n','').replace(" ", "").upper()
            rt_string = regex.sub("(.{50})", "\\1\n", rt_string, 0, regex.DOTALL)
            clean_rt_string = regex.sub(r'[\W_]+', '', rt_string)
    if not os.path.isfile(plain_txt):
        print "Error: no such file exists"
    else:
        with open(plain_txt, 'w') as plain_text:
            plain_text.write("tokenized plain text: " + clean_rt_string + "\n")
            plain_txt = clean_rt_string
    print "plain text: " + plain_txt
    return plain_txt

"""
Vigenere Cipher
"""
#returns a randomly generated vigenere key of length, "key_length"
def key_gen_vig(key_length):
    key = []
    for x in xrange(0, key_length):
        key.append(Permutations(alpha).random_element()[0])
    print "vigenere cipher key: " + str(key)
    return key
# reads and encrypts plain_txt using the vigenere cipher and key.
# writes the output to the file cipher_txt
def enc_vig(key, plain_txt, cipher_txt):
    key_l = list(key)
    #use tokenise to get plain_txt, will finish when tokenise done, for now use string
    p_txt_l = list(plain_txt)
    c_txt_l = []
    for i in xrange(0, len(p_txt_l)):
            val = (dict[p_txt_l[i]]+dict[key_l[i%len(key_l)]])%26
            c_txt_l.append(alpha[val])
    print c_txt_l
#reads and decrypts cipher_txt using the vigenere cipher and key.
# writes the output to the file plain_txt
def dec_vig(key, plain_txt, cipher_txt):
    key_l = list(key)
    p_txt_l = []
    c_txt_l = list(cipher_txt)
    for i in xrange(0, len(c_txt_l)):
        val = (dict[c_txt_l[i]]-dict[key_l[i%len(key_l)]])%26
        p_txt_l.append(alpha[val])
    print p_txt_l

"""
Alphabetic Transposition Cipher
"""
def key_gen_trans():
    """
    Description: key_gen_trans() generates randomly generated upper-case alphabet,
        and a randomly generated integer from the range 0 to 25
    Arguments: n/a
    Returns:
        rand_alpha_num(list): rand_alpha_num is a randomly generated list of characters
            consisting of the letters A to Z and integers 0 to 9
        key(int): key is a randomly generated integer from the range of 0 to 25
    """
    rand_alpha_num = [chr(i) for i in range(ord('A'),ord('Z')+1)]
    rand_alpha_num = [letter.upper() for letter in rand_alpha_num]
    rand_alpha_num += [str(i) for i in range(0,10)]
    rand_alpha_num = Permutations(rand_alpha_num).random_element()

    print "random alphabet:"
    print rand_alpha_num

    key = random.randint(0,25)
    print "transposition cipher key: " + str(key)

    return rand_alpha_num, key

def shift_alpha(rand_alpha_num, key):
    """
    Description: shift_alpha() generates a list that shifts the characters in
        rand_alpha_num to the left 'key' times
    Arguments:
        rand_alpha_num(list): rand_alpha_num is a randomly generated list of characters
            consisting of the letters A to Z and integers 0 to 9
        key(int): key is a randomly generated integer from the range of 0 to 25
    Returns:
        shift_alphabet(list): shift_alphabet is a copy of the the rand_alpha_num
            list with its character shifted to the left 'key' times
    """
    key = key % len(rand_alpha_num)
    shift_alphabet = rand_alpha_num[key:] + rand_alpha_num[:key]

    return shift_alphabet

def enc_trans(rand_alpha_num, shift_alphabet, plain_txt, cipher_txt):
    """
    Description: enc_trans() reads and encrypts plain_txt using the transpositon
        cipher
    Arguments:
        rand_alpha_num(list): rand_alpha_num is a randomly generated list of characters
            consisting of the letters A to Z and integers 0 to 9
        shift_alphabet(list): shift_alphabet is a copy of the the rand_alpha_num
            list with its character shifted to the left 'key' times
        plain_txt(String): plain_txt is a String of the message to be encrypted
        cipher_txt(String): cipher_txt is an empty String
    Returns:
        cipher_txt(String): cipher_txt is a String of the encrypted message
    """
    plain_txt_list = list(plain_txt)
    for chars in plain_txt_list:
        index = rand_alpha_num.index(chars)
        cipher_txt += shift_alphabet[index]
    print "encrypted text: " + str(cipher_txt)

    if not os.path.isfile("cipher_text.txt"):
        print "Error: no such file exists"
    else:
        with open("cipher_text.txt", 'w') as cipher_text:
            cipher_text.write("--- transposition cipher ---\nencrypted text: " + str(cipher_txt) + "\n")

    return cipher_txt

def dec_trans(rand_alpha_num, shift_alphabet, cipher_txt):
    """
    Description: dec_trans() reads and decrypts cipher_txt using the transpositon
        cipher
    Arguments:
        rand_alpha_num(list): rand_alpha_num is a randomly generated list of characters
            consisting of the letters A to Z and integers 0 to 9
        shift_alphabet(list): shift_alphabet is a copy of the the rand_alpha_num
            list with its character shifted to the left 'key' times
        cipher_txt(String): cipher_txt is a String of the encrypted message
    Returns:
        plain_txt(String): plain_txt is a String of the decrypted message
    """
    cipher_txt_list = list(cipher_txt)
    plain_txt = ""
    for chars in cipher_txt_list:
        index = shift_alphabet.index(chars)
        plain_txt += rand_alpha_num[index]
    print "decrypted text: " + str(plain_txt)

    if not os.path.isfile("plain_txt.txt"):
        print "Error: no such file exists"
    else:
        with open("plain_txt.txt", 'w') as cipher_text:
            cipher_text.write("--- transposition cipher ---\ndecrypted text: " + str(plain_txt) + "\n")

    return plain_txt

if(__name__ == "__main__"):
    """
    Description:
        main() drives the 3 classic ciphers: Affine, Vigenere, and Alphabetic
    Arguments: n/a
    Returns: n/a
    """
    raw_file = "raw_file.txt"
    plain_txt = "plain_txt.txt"
    cipher_txt = ""
    print "-----------------------------------------------------------"
    print "               Welcome to Vigenere Cipher"
    print "-----------------------------------------------------------"
    # key_length = 5
    # vig_key = key_gen_vig(key_length)
    # enc_vig(key)


    print "-----------------------------------------------------------"
    print "              Welcome to Transposition Cipher"
    print "-----------------------------------------------------------"
    rand_alpha_num, trans_key = key_gen_trans()
    shift_alphabet = shift_alpha(rand_alpha_num, trans_key)

    plain_txt = tokenize(raw_file, plain_txt)
    cipher_txt = enc_trans(rand_alpha_num, shift_alphabet, plain_txt, cipher_txt)
    plain_txt = dec_trans(rand_alpha_num, shift_alphabet, cipher_txt)
