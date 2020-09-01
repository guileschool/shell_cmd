#!/bin/bash
# Copyright (c) 2012-2015 Continuum Analytics, Inc.
# All rights reserved.
#
# NAME:  Anaconda2
# VER:   2.4.1
# PLAT:  osx-64
# DESCR: 2.4.0-322-g5c6b32f
# BYTES: 222326344
# LINES: 498
# MD5:   922231527cbae799fc2d9ba6cacef137

unset DYLD_LIBRARY_PATH
echo "$0" | grep '\.sh$' >/dev/null
if (( $? )); then
    echo 'Please run using "bash" or "sh", but not "." or "source"' >&2
    return 1
fi

THIS_DIR=$(cd $(dirname $0); pwd)
THIS_FILE=$(basename $0)
THIS_PATH="$THIS_DIR/$THIS_FILE"
PREFIX=$HOME/anaconda2
BATCH=0
FORCE=0

while getopts "bfhp:z:" x; do
    case "$x" in
        h)
            echo "usage: $0 [options]

Installs Anaconda2 2.4.1

    -b           run install in batch mode (without manual intervention),
                 it is expected the license terms are agreed upon
    -f           no error if install prefix already exists
    -h           print this help message and exit
    -p PREFIX    install prefix, defaults to $PREFIX
"
            exit 2
            ;;
        b)
            BATCH=1
            ;;
        f)
            FORCE=1
            ;;
        p)
            PREFIX="$OPTARG"
            ;;
        ?)
            echo "Error: did not recognize option, please try -h"
            exit 1
            ;;
    esac
done

# verify the size of the installer
wc -c "$THIS_PATH" | grep 222326344 >/dev/null
if (( $? )); then
    echo "ERROR: size of $THIS_FILE should be 222326344 bytes" >&2
    exit 1
fi

if [[ $BATCH == 0 ]] # interactive mode
then
    echo -n "
Welcome to Anaconda2 2.4.1 (by Continuum Analytics, Inc.)

In order to continue the installation process, please review the license
agreement.
Please, press ENTER to continue
>>> "
    read dummy
    more <<EOF
================
Anaconda License
================

Copyright 2015, Continuum Analytics, Inc.

All rights reserved under the 3-clause BSD License:

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

* Neither the name of Continuum Analytics, Inc. nor the names of its
contributors may be used to endorse or promote products derived from this
software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL CONTINUUM ANALYTICS, INC. BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
DAMAGE.


Notice of Third Party Software Licenses
=======================================

Anaconda contains open source software packages from third parties. These
are available on an "as is" basis and subject to their individual license
agreements. These licenses are available in Anaconda or at
http://docs.continuum.io/anaconda/pkg-docs . Any binary packages of these
third party tools you obtain via Anaconda are subject to their individual
licenses as well as the Anaconda license. Continuum reserves the right to
change which third party tools are provided in Anaconda.


Cryptography Notice
===================
This distribution includes cryptographic software. The country in which you
currently reside may have restrictions on the import, possession, use,
and/or re-export to another country, of encryption software. BEFORE using
any encryption software, please check your country's laws, regulations and
policies concerning the import, possession, or use, and re-export of
encryption software, to see if this is permitted. See the Wassenaar
Arrangement <http://www.wassenaar.org/> for more information.

Continuum Analytics has self-classified this software as Export Commodity
Control Number (ECCN) 5D002.C.1, which includes information security
software using or performing cryptographic functions with asymmetric
algorithms. The form and manner of this distribution makes it eligible for
export under the License Exception ENC Technology Software Unrestricted
(TSU) exception (see the BIS Export Administration Regulations, Section
740.13) for both object code and source code.

The following packages are included in this distribution that relate to
cryptography:

openssl
The OpenSSL Project is a collaborative effort to develop a robust,
commercial-grade, full-featured, and Open Source toolkit implementing the
Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols as
well as a full-strength general purpose cryptography library.

pycrypto
A collection of both secure hash functions (such as SHA256 and RIPEMD160),
and various encryption algorithms (AES, DES, RSA, ElGamal, etc.).

pyopenssl
A thin Python wrapper around (a subset of) the OpenSSL library.

kerberos (krb5, non-Windows platforms)
A network authentication protocol designed to provide strong authentication
for client/server applications by using secret-key cryptography.

cryptography
A Python library which exposes cryptographic recipes and primitives.
EOF
    echo -n "
Do you approve the license terms? [yes|no]
>>> "
    read ans
    while [[ ($ans != "yes") && ($ans != "Yes") && ($ans != "YES") &&
             ($ans != "no") && ($ans != "No") && ($ans != "NO") ]]
    do
        echo -n "Please answer 'yes' or 'no':
>>> "
        read ans
    done
    if [[ ($ans != "yes") && ($ans != "Yes") && ($ans != "YES") ]]
    then
        echo "The license agreement wasn't approved, aborting installation."
        exit 2
    fi

    echo -n "
Anaconda2 will now be installed into this location:
$PREFIX

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

[$PREFIX] >>> "
    read user_prefix
    if [[ $user_prefix != "" ]]; then
        case "$user_prefix" in
            *\ * )
                echo "ERROR: Cannot install into directories with spaces" >&2
                exit 1
                ;;
            *)
                eval PREFIX="$user_prefix"
                ;;
        esac
    fi
fi # !BATCH

case "$PREFIX" in
    *\ * )
        echo "ERROR: Cannot install into directories with spaces" >&2
        exit 1
        ;;
esac

if [[ ($FORCE == 0) && (-e $PREFIX) ]]; then
    echo "ERROR: File or directory already exists: $PREFIX" >&2
    exit 1
fi

mkdir -p $PREFIX
if (( $? )); then
    echo "ERROR: Could not create directory: $PREFIX" >&2
    exit 1
fi

PREFIX=$(cd $PREFIX; pwd)
export PREFIX

echo "PREFIX=$PREFIX"

# verify the MD5 sum of the tarball appended to this header
MD5=$(tail -n +498 "$THIS_PATH" | md5)
echo $MD5 | grep 922231527cbae799fc2d9ba6cacef137 >/dev/null
if (( $? )); then
    echo "WARNING: md5sum mismatch of tar archive
expected: 922231527cbae799fc2d9ba6cacef137
     got: $MD5" >&2
fi

# extract the tarball appended to this header, this creates the *.tar.bz2 files
# for all the packages which get installed below
# NOTE:
#   When extracting as root, tar will by default restore ownership of
#   extracted files, unless --no-same-owner is used, which will give
#   ownership to root himself.
cd $PREFIX

tail -n +498 "$THIS_PATH" | tar xf - --no-same-owner
if (( $? )); then
    echo "ERROR: could not extract tar starting at line 498" >&2
    exit 1
fi

extract_dist()
{
    echo "installing: $1 ..."
    DIST=$PREFIX/pkgs/$1
    mkdir -p $DIST
    tar xjf ${DIST}.tar.bz2 -C $DIST --no-same-owner || exit 1
    rm -f ${DIST}.tar.bz2
}

extract_dist _cache-0.0-py27_x0
extract_dist python-2.7.11-0
extract_dist conda-3.18.8-py27_0
extract_dist conda-build-1.18.2-py27_0
extract_dist conda-env-2.4.5-py27_0
extract_dist _license-1.1-py27_1
extract_dist abstract-rendering-0.5.1-np110py27_0
extract_dist alabaster-0.7.6-py27_0
extract_dist anaconda-client-1.2.1-py27_0
extract_dist appnope-0.1.0-py27_0
extract_dist appscript-1.0.1-py27_0
extract_dist argcomplete-1.0.0-py27_1
extract_dist astropy-1.0.6-np110py27_0
extract_dist babel-2.1.1-py27_0
extract_dist backports_abc-0.4-py27_0
extract_dist beautifulsoup4-4.4.1-py27_0
extract_dist bitarray-0.8.1-py27_0
extract_dist blaze-core-0.8.3-py27_0
extract_dist bokeh-0.10.0-py27_0
extract_dist boto-2.38.0-py27_0
extract_dist bottleneck-1.0.0-np110py27_0
extract_dist cdecimal-2.3-py27_0
extract_dist cffi-1.2.1-py27_0
extract_dist clyent-1.2.0-py27_0
extract_dist colorama-0.3.3-py27_0
extract_dist configobj-5.0.6-py27_0
extract_dist cryptography-1.0.2-py27_0
extract_dist curl-7.45.0-0
extract_dist cycler-0.9.0-py27_0
extract_dist cython-0.23.4-py27_1
extract_dist cytoolz-0.7.4-py27_0
extract_dist datashape-0.4.7-np110py27_1
extract_dist decorator-4.0.4-py27_0
extract_dist docutils-0.12-py27_0
extract_dist dynd-python-0.7.0-py27_0
extract_dist enum34-1.0.4-py27_0
extract_dist fastcache-1.0.2-py27_0
extract_dist flask-0.10.1-py27_1
extract_dist freetype-2.5.5-0
extract_dist funcsigs-0.4-py27_0
extract_dist gevent-1.0.1-py27_0
extract_dist gevent-websocket-0.9.3-py27_0
extract_dist greenlet-0.4.9-py27_0
extract_dist grin-1.2.1-py27_1
extract_dist h5py-2.5.0-np110py27_4
extract_dist hdf5-1.8.15.1-2
extract_dist idna-2.0-py27_0
extract_dist ipaddress-1.0.14-py27_0
extract_dist ipykernel-4.1.1-py27_0
extract_dist ipython-4.0.1-py27_0
extract_dist ipython-notebook-4.0.4-py27_0
extract_dist ipython-qtconsole-4.0.1-py27_0
extract_dist ipython_genutils-0.1.0-py27_0
extract_dist ipywidgets-4.1.0-py27_0
extract_dist itsdangerous-0.24-py27_0
extract_dist jbig-2.1-0
extract_dist jdcal-1.0-py27_0
extract_dist jedi-0.9.0-py27_0
extract_dist jinja2-2.8-py27_0
extract_dist jpeg-8d-1
extract_dist jsonschema-2.4.0-py27_0
extract_dist jupyter-1.0.0-py27_1
extract_dist jupyter_client-4.1.1-py27_0
extract_dist jupyter_console-4.0.3-py27_0
extract_dist jupyter_core-4.0.6-py27_0
extract_dist launcher-1.0.0-3
extract_dist libdynd-0.7.0-0
extract_dist libpng-1.6.17-0
extract_dist libtiff-4.0.6-1
extract_dist libxml2-2.9.2-0
extract_dist libxslt-1.1.28-2
extract_dist llvmlite-0.8.0-py27_0
extract_dist lxml-3.4.4-py27_0
extract_dist markupsafe-0.23-py27_0
extract_dist matplotlib-1.5.0-np110py27_0
extract_dist mistune-0.7.1-py27_0
extract_dist multipledispatch-0.4.8-py27_0
extract_dist nbconvert-4.0.0-py27_0
extract_dist nbformat-4.0.1-py27_0
extract_dist networkx-1.10-py27_0
extract_dist nltk-3.1-py27_0
extract_dist node-webkit-0.10.1-0
extract_dist nose-1.3.7-py27_0
extract_dist notebook-4.0.6-py27_0
extract_dist numba-0.22.1-np110py27_0
extract_dist numexpr-2.4.4-np110py27_0
extract_dist numpy-1.10.1-py27_0
extract_dist odo-0.3.4-py27_0
extract_dist openpyxl-2.2.6-py27_0
extract_dist openssl-1.0.2d-0
extract_dist pandas-0.17.1-np110py27_0
extract_dist path.py-8.1.2-py27_1
extract_dist patsy-0.4.0-np110py27_0
extract_dist pep8-1.6.2-py27_0
extract_dist pexpect-3.3-py27_0
extract_dist pickleshare-0.5-py27_0
extract_dist pillow-3.0.0-py27_1
extract_dist pip-7.1.2-py27_0
extract_dist ply-3.8-py27_0
extract_dist psutil-3.3.0-py27_0
extract_dist ptyprocess-0.5-py27_0
extract_dist py-1.4.30-py27_0
extract_dist pyasn1-0.1.9-py27_0
extract_dist pyaudio-0.2.7-py27_0
extract_dist pycosat-0.6.1-py27_0
extract_dist pycparser-2.14-py27_0
extract_dist pycrypto-2.6.1-py27_0
extract_dist pycurl-7.19.5.1-py27_3
extract_dist pyflakes-1.0.0-py27_0
extract_dist pygments-2.0.2-py27_0
extract_dist pyopenssl-0.15.1-py27_1
extract_dist pyparsing-2.0.3-py27_0
extract_dist pyqt-4.11.4-py27_1
extract_dist pytables-3.2.2-np110py27_0
extract_dist pytest-2.8.1-py27_0
extract_dist python-dateutil-2.4.2-py27_0
extract_dist python.app-1.2-py27_4
extract_dist pytz-2015.7-py27_0
extract_dist pyyaml-3.11-py27_1
extract_dist pyzmq-14.7.0-py27_1
extract_dist qt-4.8.7-1
extract_dist qtconsole-4.1.1-py27_0
extract_dist readline-6.2-2
extract_dist redis-2.6.9-0
extract_dist redis-py-2.10.3-py27_0
extract_dist requests-2.8.1-py27_0
extract_dist rope-0.9.4-py27_1
extract_dist scikit-image-0.11.3-np110py27_0
extract_dist scikit-learn-0.17-np110py27_1
extract_dist scipy-0.16.0-np110py27_1
extract_dist setuptools-18.5-py27_0
extract_dist simplegeneric-0.8.1-py27_0
extract_dist singledispatch-3.4.0.3-py27_0
extract_dist sip-4.16.9-py27_0
extract_dist six-1.10.0-py27_0
extract_dist snowballstemmer-1.2.0-py27_0
extract_dist sockjs-tornado-1.0.1-py27_0
extract_dist sphinx-1.3.1-py27_0
extract_dist sphinx_rtd_theme-0.1.7-py27_0
extract_dist spyder-2.3.8-py27_0
extract_dist spyder-app-2.3.8-py27_0
extract_dist sqlalchemy-1.0.9-py27_0
extract_dist sqlite-3.8.4.1-1
extract_dist ssl_match_hostname-3.4.0.2-py27_0
extract_dist statsmodels-0.6.1-np110py27_0
extract_dist sympy-0.7.6.1-py27_0
extract_dist terminado-0.5-py27_1
extract_dist tk-8.5.18-0
extract_dist toolz-0.7.4-py27_0
extract_dist tornado-4.3-py27_0
extract_dist traitlets-4.0.0-py27_0
extract_dist ujson-1.33-py27_0
extract_dist unicodecsv-0.14.1-py27_0
extract_dist werkzeug-0.11.2-py27_0
extract_dist wheel-0.26.0-py27_1
extract_dist xlrd-0.9.4-py27_0
extract_dist xlsxwriter-0.7.7-py27_0
extract_dist xlwings-0.5.0-py27_0
extract_dist xlwt-1.0.0-py27_0
extract_dist xz-5.0.5-0
extract_dist yaml-0.1.6-0
extract_dist zeromq-4.1.3-0
extract_dist zlib-1.2.8-0
extract_dist anaconda-2.4.1-np110py27_0

mkdir $PREFIX/envs
mkdir $HOME/.continuum 2>/dev/null

PYTHON="$PREFIX/pkgs/python-2.7.11-0/bin/python -E"
$PYTHON -V
if (( $? )); then
    echo "ERROR:
cannot execute native osx-64 binary, output from 'uname -a' is:" >&2
    uname -a
    exit 1
fi

echo "creating default environment..."
CONDA_INSTALL="$PREFIX/pkgs/conda-3.18.8-py27_0/lib/python2.7/site-packages/conda/install.py"
$PYTHON $CONDA_INSTALL --prefix=$PREFIX --pkgs-dir=$PREFIX/pkgs --link-all || exit 1
echo "installation finished."

if [[ $PYTHONPATH != "" ]]; then
    echo "WARNING:
    You currently have a PYTHONPATH environment variable set. This may cause
    unexpected behavior when running the Python interpreter in Anaconda2.
    For best results, please verify that your PYTHONPATH only points to
    directories of packages that are compatible with the Python interpreter
    in Anaconda2: $PREFIX"
fi

if [[ $BATCH == 0 ]] # interactive mode
then
    BASH_RC=$HOME/.bash_profile
    DEFAULT=yes
    echo -n "Do you wish the installer to prepend the Anaconda2 install location
to PATH in your $BASH_RC ? [yes|no]
[$DEFAULT] >>> "
    read ans
    if [[ $ans == "" ]]; then
        ans=$DEFAULT
    fi
    if [[ ($ans != "yes") && ($ans != "Yes") && ($ans != "YES") &&
                ($ans != "y") && ($ans != "Y") ]]
    then
        echo "
You may wish to edit your .bashrc or prepend the Anaconda2 install location:

$ export PATH=$PREFIX/bin:\$PATH
"
    else
        if [ -f $BASH_RC ]; then
            echo "
Prepending PATH=$PREFIX/bin to PATH in $BASH_RC
A backup will be made to: ${BASH_RC}-anaconda2.bak
"
            cp $BASH_RC ${BASH_RC}-anaconda2.bak
        else
            echo "
Prepending PATH=$PREFIX/bin to PATH in
newly created $BASH_RC"
        fi
        echo "
For this change to become active, you have to open a new terminal.
"
        echo "
# added by Anaconda2 2.4.1 installer
export PATH=\"$PREFIX/bin:\$PATH\"" >>$BASH_RC
    fi

    echo "Thank you for installing Anaconda2!

Share your notebooks and packages on Anaconda Cloud!
Sign up for free: https://anaconda.org
"
fi # !BATCH

exit 0
