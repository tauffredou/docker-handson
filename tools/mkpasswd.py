#!/usr/bin/env python

import crypt, getpass, pwd,sys;
print crypt.crypt(sys.argv[1], '\$6\$saltsalt\$')
