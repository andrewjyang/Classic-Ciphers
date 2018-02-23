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

alphabet = [chr(i) for i in range (ord('A'),ord('Z')+1)]
num = [i for i in range(26)]
dictionary = {k: v for k, v in zip(alphabet, num)}

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
    print "plain text: "
    return plain_txt


"""
Affine Cipher
"""
#returns a two-tuple containing alpha and beta,
#legal and randomly generated affine keys
def key_gen_aff():
    a_set = {x for x in xrange(2,26) if gcd(x,26) == 1}
    b_set = {y for y in xrange(0,26)}
    rand_tuple = (random.sample(a_set,1)[0],random.sample(b_set,1)[0])
    print "affine cipher key: " + str(rand_tuple)

    return rand_tuple

#reads and encrypts plain_txt using the affine cipher and key.
#writes the output to the file cipher_txt
def enc_aff(key, plain_txt, cipher_txt):
    alpha = key[0]
    beta = key[1]
    plain_txt_list = list(plain_txt)
    cipher_txt_list = []
    for i in xrange(0, len(plain_txt_list)):
        val = (dictionary[plain_txt_list[i]] * alpha + beta) % 26
        cipher_txt_list.append(alphabet[val])
    cipher_txt = ''.join(cipher_txt_list)
    print "encrypted text: "

    if not os.path.isfile("cipher_text.txt"):
        print "Error: no such file exists"
    else:
        with open("cipher_text.txt", 'w') as cipher_text:
            cipher_text.write("--- affine cipher ---\nencrypted text: " + str(cipher_txt) + "\n")

    return cipher_txt

#reads and decrypts cipher_txt using the affine cipher and key. writes the output to the file plain_txt
def dec_aff(key, cipher_txt, plain_txt):
    alpha = key[0]
    beta = key[1]
    alpha_inverse = inverse_mod(alpha,26)
    cipher_txt_list = list(cipher_txt)
    plain_txt_list = []
    for i in xrange(0,len(cipher_txt_list)):
        val = ((dictionary[cipher_txt_list[i]] - beta) * alpha_inverse) % 26
        plain_txt_list.append(alphabet[val])
    plain_txt = ''.join(plain_txt_list)
    print "decrypted text: " + plain_txt

    if not os.path.isfile("plain_txt.txt"):
        print "Error: no such file exists"
    else:
        with open("plain_txt.txt", 'a') as cipher_text:
            cipher_text.write("--- affine cipher ---\ndecrypted text: " + str(plain_txt) + "\n")

    return plain_txt
"""
Vigenere Cipher
"""
#returns a randomly generated vigenere key of length, "key_length"
def key_gen_vig(key_length):
    key = []
    for x in xrange(0, key_length):
        key.append(Permutations(alphabet).random_element()[0])
    key = ''.join(key)
    print "vigenere cipher key: " + key

    return key
# reads and encrypts plain_txt using the vigenere cipher and key.
# writes the output to the file cipher_txt
def enc_vig(key, plain_txt, cipher_txt):
    key_list = list(key)
    plain_txt_list = list(plain_txt)
    cipher_txt_list = []
    for i in xrange(0, len(plain_txt_list)):
            val = (dictionary[plain_txt_list[i]] + dictionary[key_list[i % len(key_list)]]) % 26
            cipher_txt_list.append(alphabet[val])

    cipher_txt = ''.join(cipher_txt_list)

    if not os.path.isfile("cipher_text.txt"):
        print "Error: no such file exists"
    else:
        with open("cipher_text.txt", 'w') as cipher_text:
            cipher_text.write("--- viginere cipher ---\nencrypted text: " + str(cipher_txt) + "\n")

    return cipher_txt

#reads and decrypts cipher_txt using the vigenere cipher and key.
# writes the output to the file plain_txt
def dec_vig(key, cipher_txt, plain_txt):
    key_list = list(key)
    plain_txt_list = []
    cipher_txt_list = list(cipher_txt)
    for i in xrange(0, len(cipher_txt_list)):
        val = (dictionary[cipher_txt_list[i]] - dictionary[key_list[i % len(key_list)]]) % 26
        plain_txt_list.append(alphabet[val])
    plain_txt = ''.join(plain_txt_list)
    print "decrypted text: " + plain_txt

    if not os.path.isfile("plain_txt.txt"):
        print "Error: no such file exists"
    else:
        with open("plain_txt.txt", 'a') as cipher_text:
            cipher_text.write("--- viginere cipher ---\ndecrypted text: " + str(plain_txt) + "\n")

    return plain_txt

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
        with open("cipher_text.txt", 'a') as cipher_text:
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
        with open("plain_txt.txt", 'a') as cipher_text:
            cipher_text.write("--- transposition cipher ---\ndecrypted text: " + str(plain_txt) + "\n")

    return plain_txt

"""
if(__name__ == "__main__"):

    Description:
        main() drives the 3 classic ciphers: Affine, Vigenere, and Alphabetic
    Arguments: n/a
    Returns: n/a

    raw_file = "raw_file.txt"
    plain_txt = "plain_txt.txt"
    cipher_txt = "cipher_text.txt"
    print "-----------------------------------------------------------"
    print "                  Welcome to Affine Cipher"
    print "-----------------------------------------------------------"
    plain_txt = tokenize(raw_file, plain_txt)
    key = key_gen_aff()
    cipher_txt = enc_aff(key, plain_txt, cipher_txt)
    plain_txt = dec_aff(key, cipher_txt, plain_txt)

    print "-----------------------------------------------------------"
    print "               Welcome to Vigenere Cipher"
    print "-----------------------------------------------------------"
    plain_txt = tokenize(raw_file, plain_txt)
    key_length = 5
    vig_key = key_gen_vig(key_length)

    cipher_txt = enc_vig(vig_key, plain_txt, cipher_txt)
    plain_txt = dec_vig(vig_key, cipher_txt, plain_txt)

    print "-----------------------------------------------------------"
    print "              Welcome to Transposition Cipher"
    print "-----------------------------------------------------------"
    plain_txt = tokenize(raw_file, plain_txt)

    rand_alpha_num, trans_key = key_gen_trans()
    shift_alphabet = shift_alpha(rand_alpha_num, trans_key)

    cipher_txt = enc_trans(rand_alpha_num, shift_alphabet, plain_txt, cipher_txt)
    plain_txt = dec_trans(rand_alpha_num, shift_alphabet, cipher_txt)
"""
