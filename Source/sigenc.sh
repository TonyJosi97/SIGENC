#!/bin/bash


#*********************************************************************************



# The 'sigenc' is an easy use RSA Asymmetric encryption command that  
# uses Linux built in Openssl - rsa Commands


# USAGE
# * sigenc m
#	m - Mode:
#		g - Generate key
#		e - Encrypt Your password using the key public produced
# * sigenc m e k
#	m - Mode:
#		d - Decrypt encrpted password using private key
#		e - Encrypted file
#		k - Private key file for the encrpted password


#	Written by: Tony Josi 
#	First Version On: 27 Dec' 2k16, 2:45PM



#**********************************************************************************

#	Copyright (c) 2016 Tony Josi

#	Permission is hereby granted, free of charge, to any person obtaining
#   a copy of this software and associated documentation files (the "Software"), 
#   to deal in the Software without restriction, including without limitation 
#   the rights to use, copy, modify, merge, publish, distribute, sublicense, 
#   and/or sell copies of the Software,and to permit persons to whom the Software
#   is furnished to do so, subject to the following conditions:

#	The above copyright notice and this permission notice shall be included in 
#   all copies or substantial portions of the Software.

#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
#   THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
#   SOFTWARE.


#************************************************************************************


if [ -z "$1" ]
        then
                echo "ERROR: #Argument Missing! Provide mode as first argument:"
                echo "g: Generate RSA Public and Private Keys"
                echo "m: Make Encrypted password file"
		echo "d: Decrypt the given file with PRIVATE key"
                exit 1
fi

if [ "$1" == "g" ]
then
		openssl genrsa -des3 -out private.pem 2048
		openssl rsa -in private.pem -outform PEM -pubout -out public.pem
		openssl rsa -in private.pem -out private_unencrypted.pem -outform PEM
		rm private.pem
		mv private_unencrypted.pem private.pem
		echo "Private and Public RSA keys are Generated!"
fi

if [ "$1" == "e" ]
then
	touch temp
	echo "Input the Password to be Encrypted:"
	read pass
	echo "Confirm Password:"
	read pass2
	if [ $pass == $pass2 ]
	then
			if [ -f temp ]
			then
			    echo "Password Matched :)" 
			    echo "$pass" > temp
			else
			    echo "Temporary Password file got corrupted.....Exiting!! :("
			fi
	else
			echo "Password Not Matching....Exiting!!"
	fi
openssl rsautl -encrypt -inkey public.pem -pubin -in temp -out encrypted_key
ad=$(pwd)
rm temp
echo "The given password is Encypted and saved as encrypted_key in the Dir:" $ad
fi

if [ "$1" == "d" ]
then
		if [ -z "$2" ]
		then
			echo "ERROR Missing file name of encrypted password"
		elif [ -z "$3" ]
		then
			echo "ERROR Missing file name of Private Key file"
		else
			openssl rsautl -decrypt -inkey $3 -in $2 -out password
			ad1=$(pwd)
			echo "The Decrypted KEY is saved in file password in Dir:" $ad1
		fi
fi



#************************************************************************************

# THANKS FOR READING!!!

#************************************************************************************
