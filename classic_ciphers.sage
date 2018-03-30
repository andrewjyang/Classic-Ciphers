"""
This program implements 3 classic ciphers: Affine, Vigenere, and Alphabetic
    Transposition Cipher
CPSC 353-01, Spring 2018
Project: 4
Sources: n/a
@authors: Andrew Yang and Jeb Kilfoyle
@version v1.0 February 23, 2018
            `
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
        open(raw_file, 'w+')
    else:
        with open(raw_file, 'r') as raw_text:
            rt_string = raw_text.read().replace('\n','').replace(" ", "").upper()
            rt_string = regex.sub("(.{50})", "\\1\n", rt_string, 0, regex.DOTALL)
            clean_rt_string = regex.sub(r'[\W_]+', '', rt_string)
    if not os.path.isfile(plain_txt):
        open(plain_txt, 'w+')
    with open(plain_txt, 'w') as plain_text:
        plain_text.write(clean_rt_string + "\n")
        plain_txt = clean_rt_string
    print "plain text: " + plain_txt
    return #plain_txt
"""
Affine Cipher
"""
def key_gen_aff():
    """
    Description: key_gen_aff() generates a randomly generates a pair of random alpha beta values. Alpha can be any number 2:26 that is relatively prime to 26.
        Beta is any value 0:26.
    Arguments: n/a
    Returns:
       rand_tuple(two-tuple): (alpha, beta) a random pair of valid alpha beta values.
    """
    a_set = {x for x in xrange(2,26) if gcd(x,26) == 1}
    b_set = {y for y in xrange(0,26)}
    rand_tuple = (random.sample(a_set,1)[0],random.sample(b_set,1)[0])
    print "affine cipher key: " + str(rand_tuple)
    return #rand_tuple
def enc_aff(key, plain_txt, cipher_txt):
    """
    Description: enc_aff(key,plain_txt,cipher_txt) takes the plain_txt and multiplies it's character value by alpha, adds beta, and the modulo 26. Store the result in cipher_txt.
    Arguments:
        key(Integer pair): A random alphabetic String.
        plain_txt(File):plain_txt is a File of the un-encrypted message
        cipher_txt(File): cipher_txt is a File for the encrypted message
    Returns:
    N/A
    """
    with open(plain_txt, 'r') as myfile:
    plain_txt_str=myfile.read().replace('\n', '')
    plain_txt_list = list(plain_txt_str)
    alpha = key[0]
    beta = key[1]
    cipher_txt_list = []
    for i in xrange(0, len(plain_txt_list)):
        val = (dictionary[plain_txt_list[i]] * alpha + beta) % 26
        cipher_txt_list.append(alphabet[val])
    cipher_text = ''.join(cipher_txt_list)
    print "encrypted text: " + cipher_text
    if not os.path.isfile(cipher_txt):
            open(cipher_txt, 'w+')
    with open(cipher_txt, 'w') as cipher_t:
        cipher_t.write(str(cipher_text) + "\n")
    return #cipher_text
def dec_aff(key, cipher_txt, plain_txt):
    """
    Description: dec_aff(key,cipher_txt,plain_txt) takes the message in cipher_txt, subtracts beta from the character values, and then mutiplies by the multiplicative inverse of alpha mod 26
    Arguments:
        key(Integer Pair): An Integer pair.
        plain_txt(File):plain_txt is a File of the un-encrypted message
        cipher_txt(File): cipher_txt is a File of the encrypted message
    Returns:
        N/A
    """
    alpha = key[0]
    beta = key[1]
    alpha_inverse = inverse_mod(alpha,26)

    with open(cipher_txt, 'r') as myfile:
    cipher_txt_str=myfile.read().replace('\n', '')
    cipher_txt_list = list(cipher_txt_str)
    plain_txt_list = []
    for i in xrange(0,len(cipher_txt_list)):
        val = ((dictionary[cipher_txt_list[i]] - beta) * alpha_inverse) % 26
        plain_txt_list.append(alphabet[val])
    plain_text = ''.join(plain_txt_list)
    print "decrypted text: " + plain_text
    if not os.path.isfile(plain_txt):
        open(plain_txt, 'w+')
    with open(plain_txt, 'a') as cipher_text:
        cipher_text.write(plain_text + "\n")
    return #plain_txt
"""
Vigenere Cipher
"""
def key_gen_vig(key_length):
    """
    Description: key_gen_vig() generates a randomly generated upper-case String of length key_length.
    Arguments:
        key_length(Int): The desired length of they key.
    Returns:
        N/A
    """
    key = []
    for x in xrange(0, key_length):
        key.append(Permutations(alphabet).random_element()[0])
    key = ''.join(key)
    print "vigenere cipher key: " + key
    return #key
def enc_vig(key, plain_txt, cipher_txt):
    """
    Description: enc_vig(key,plain_txt,cipher_txt) takes the plain_txt and adds its character value to the codewords character values, and then storing the results in the cipher_txt file.
    Arguments:
        key(String): An alphabetic String.
        plain_txt(File):plain_txt is a File with the un-encrypted message
        cipher_txt(File): cipher_txt is a File for the encrypted message
    Returns:
        N/A
    """

    key_list = list(key)
    with open(plain_txt, 'r') as myfile:
    plain_txt_str=myfile.read().replace('\n', '')
    plain_txt_list = list(plain_txt_str)
    cipher_txt_list = []
    for i in xrange(0, len(plain_txt_list)):
            val = (dictionary[plain_txt_list[i]] + dictionary[key_list[i % len(key_list)]]) % 26
            cipher_txt_list.append(alphabet[val])
    cipher_text_str = ''.join(cipher_txt_list)
    print "encrypted text: " + cipher_text_str
    if not os.path.isfile(cipher_txt):
        open(cipher_txt, 'w+')
    with open(cipher_txt, 'a') as cipher_text:
        cipher_text.write(cipher_text_str + "\n")
    return #cipher_txt
def dec_vig(key, cipher_txt, plain_txt):
    """
    Description: dec_vig(key,cipher_txt,plain_txt) takes the plain_txt and subtracts the codewords character values from the cipher_txt's character values, and then stores the results in the plain_txt file.
    Arguments:
        key(String): A random alphabetic String.
        plain_txt(String):plain_txt is a String of the un-encrypted message
        cipher_txt(String): cipher_txt is a String for the encrypted message
    Returns:
        plain_txt(String): plain_txt is a String with the decrypted message
    """
    key_list = list(key)
    plain_txt_list = []
    with open(cipher_txt, 'r') as myfile:
    cipher_txt_str=myfile.read().replace('\n', '')
    cipher_txt_list = list(cipher_txt_str)
    for i in xrange(0, len(cipher_txt_list)):
        val = (dictionary[cipher_txt_list[i]] - dictionary[key_list[i % len(key_list)]]) % 26
        plain_txt_list.append(alphabet[val])
    plain_text_str = ''.join(plain_txt_list)
    print ("decrypted text: " + plain_text_str + "\n")
    if not os.path.isfile(plain_txt):
        open(plain_txt, 'w+')
    with open(plain_txt, 'a') as plain_text:
        plain_text.write(plain_text_str + "\n")
    return #plain_txt
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
    #rand_alpha_num += [str(i) for i in range(0,10)]
    rand_alpha_num = Permutations(rand_alpha_num).random_element()
    print "random alphabet:" + ''.join(rand_alpha_num)
    return #key
def enc_trans(key, plain_txt, cipher_txt):
    """
    Description: enc_trans() reads and encrypts plain_txt using the transpositon
        cipher
    Arguments:
        key(String): key is a randomly generated alphabet
            consisting of the letters A to Z
        plain_txt(File): plain_txt is a File with the message to be encrypted
        cipher_txt(File): cipher_txt is a File to write the encrypted message in
    Returns:
        N/A
    """
    key_l = list(key)
    stand_alphabet = [chr(i) for i in range(ord('A'),ord('Z')+1)]
    cipher_text = ""
    with open(plain_txt, 'r') as myfile:
    plain_txt_str=myfile.read().replace('\n', '')
    plain_txt_list = list(plain_txt_str)
    for chars in plain_txt_list:
        cipher_text += key_l[stand_alphabet.index(chars)]
    print "encrypted text: " + cipher_text
    if not os.path.isfile(cipher_txt):
        open(cipher_txt, 'w+')
    with open(cipher_txt, 'a') as cipher_text_f:
        cipher_text_f.write(cipher_text + "\n")
    return #cipher_txt
def dec_trans( key, cipher_txt, plain_txt):
    """
    Description: dec_trans() reads and decrypts cipher_txt using the transpositon
        cipher
    Arguments:
        cipher_txt(File): cipher_txt is a File with the encrypted message
    plain_txt(File):plain_txt is a File with the decrypted message
    Returns:
        N/A
    """
    key_l = list(key)
    stand_alphabet = [chr(i) for i in range(ord('A'),ord('Z')+1)]
    cipher_txt_str = ""
    with open(cipher_txt, 'r') as myfile:
    cipher_txt_str=myfile.read().replace('\n', '')
    cipher_txt_list = list(cipher_txt_str)
    plain_txt_str = ""
    for chars in cipher_txt_list:
    plain_txt_str+= stand_alphabet[key_l.index(chars)]
    print "decrypted text: " + plain_txt_str
    if not os.path.isfile(plain_txt):
        open(plain_txt, 'w+')
    with open(plain_txt, 'a') as plain_text_f:
            plain_text_f.write(plain_txt_str + "\n")
    return #plain_txt
