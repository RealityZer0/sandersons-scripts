#!/usr/bin/env python

import sys
import os
import re
import xlwt

# Regex to match both generic and internet passwords from a keychain dump
regex = re.compile(
    r"""
    keychain:\s"(?P<kchn>[^"]+)"\n                  # absolute path and file of keychain
    version:\s(\d\d\d)\n                            # version
    class:\s"(?P<clss>(genp|inet))"\n               # generic password or internet password
    attributes:\n
    (\s*?0x00000007\s<blob>=(?P<name>[^\n]+)\n)?    # name
    (\s*?0x00000008\s<blob>=(?P<hex8>[^\n]+)\n)?    # ? only used at certificates
    (\s*?"acct"<blob>=(?P<acct>[^\n]+)\n)?          # account
    (\s*?"atyp"<blob>=(?P<atyp>[^\n]+)\n)?          # account type ("form"), sometimes int
    (\s*?"cdat"<timedate>=[^"]*(?P<cdat>[^\n]+)\n)? # datetime created
    (\s*?"crtr"<uint32>=(?P<crtr>[^\n]+)\n)?        # vendor key with four chars like "aapl"
    (\s*?"cusi"<sint32>=(?P<cusi>[^\n]+)\n)?        # ? always null
    (\s*?"desc"<blob>=(?P<desc>[^\n]+)\n)?          # description
    (\s*?"gena"<blob>=(?P<gena>[^\n]+)\n)?          # ? always null except one rare cases
    (\s*?"icmt"<blob>=(?P<icmt>[^\n]+)\n)?          # ? some sort of description
    (\s*?"invi"<sint32>=(?P<invi>[^\n]+)\n)?        # ? always null
    (\s*?"mdat"<timedate>=[^"]*(?P<mdat>[^\n]+)\n)? # datetime last modified
    (\s*?"nega"<sint32>=(?P<nega>[^\n]+)\n)?        # ? always null
    (\s*?"path"<blob>=(?P<path>[^\n]+)\n)?          # path
    (\s*?"port"<uint32>=(?P<port>[^\n]+)\n)?        # port number in hex
    (\s*?"prot"<blob>=(?P<prot>[^\n]+)\n)?          # ? always null
    (\s*?"ptcl"<uint32>=(?P<ptcl>[^\n]+)\n)?        # protocol but is blob ("http", "https")
    (\s*?"scrp"<sint32>=(?P<scrp>[^\n]+)\n)?        # ? always null except one rare cases
    (\s*?"sdmn"<blob>=(?P<sdmn>[^\n]+)\n)?          # used for htaccess AuthName
    (\s*?"srvr"<blob>=(?P<srvr>[^\n]+)\n)?          # server
    (\s*?"svce"<blob>=(?P<svce>[^\n]+)\n)?          # ? some sort of description
    (\s*?"type"<uint32>=(?P<type>[^\n]+)\n)?        # some blob: "iprf", "note"
    data:\n
    "(?P<data>[^"]*)"                               # password
    """, re.MULTILINE | re.VERBOSE)

# Dictionary used by the clean function (Apple is not always right about the
# types of the field)
field2type = { 
    "name": "blob",
    "hex8": "blob",
    "acct": "blob",
    "atyp": "simple",
    "cdat": "timedate",
    "crtr": "uint32",
    "cusi": "sint32",
    "desc": "blob", 
    "gena": "blob",
    "icmt": "blob",
    "invi": "sint32",
    "mdat": "timedate",
    "nega": "sint32",
    "path": "blob",
    "port": "uint32",
    "prot": "blob",
    "ptcl": "blob",
    "scrp": "sint32",
    "sdmn": "blob",
    "srvr": "blob", 
    "svce": "blob",
    "type": "blob",
    "data": "simple",
    "kchn": "simple",
    "clss": "simple"
}

def clean(field, match):
    value = match.group(field)
    if not value or value == "<NULL>":
        # print null values as empty strings
        return ""
    if field2type[field] == "blob":
        # strip " at beginning and end
        return value[1:-1]
    elif field2type[field] == "timedate":
        # convert timedate to the iso standard
        value = value[1:-1]
        return value[0:4] + "-" + value[4:6] + "-" + value[6:8] + "T" + \
            value[8:10] + ":" + value[10:12] + ":" + value[12:14] + "Z" + value[16:19]
    elif field2type[field] == "uint32":
        # if it really is a hex int, convert it to decimal
        value = value.strip()
        if re.match("^0x[0-9a-fA-F]+$", value):
            return int(value, 16)
        else:
            return value
    else:
        # do nothing, just print it as it is
        return value

def print_help():
    print "Usage: python keychain.py INPUTFILE OUTPUTFILE"
    print "Example: python keychain.py keychain.txt keychain.xls"
    print "  where keychain.txt was created by `security dump-keychain -d > keychain.txt`"
    print "  When dumping the keychain, you have to click 'Allow' for each entry in your"
    print "  keychain. Position you mouse over the button and go clicking like crazy."




print "Keychain 0.1: convert an Apple Keychain dump to an Excel (XLS) spreadsheet."

# Check for correct parameters
if len(sys.argv) != 3:
    print_help()
    sys.exit(1)
elif len(sys.argv) == 3:
    if not os.path.isfile(sys.argv[1]):
        print "Error: no such file '{0}'".format(sys.argv[1])
        print_help()
        exit(1)

# Read keychain file
buffer = open(sys.argv[1], "r").read()
print "Read {0} bytes from '{1}'".format(len(buffer), sys.argv[1])

# Create excel workbook and header
wb = xlwt.Workbook()
ws = wb.add_sheet("Keychain")
ws.write(0, 0, "Name")
ws.write(0, 1, "Account")
ws.write(0, 2, "Password")
ws.write(0, 3, "Protocol")
ws.write(0, 4, "Server")
ws.write(0, 5, "Port")
ws.write(0, 6, "Path")
ws.write(0, 7, "Description")
ws.write(0, 8, "Created")
ws.write(0, 9, "Modified")
ws.write(0, 10, "AuthName")
ws.write(0, 11, "AccountType")
ws.write(0, 12, "Type")
ws.write(0, 13, "Keychain")

# Find passwords and add them to the excel spreadsheet
i = 1
for match in regex.finditer(buffer):
    ws.write(i, 0, clean("name", match))
    ws.write(i, 1, clean("acct", match))
    ws.write(i, 2, clean("data", match))
    ws.write(i, 3, clean("ptcl", match))
    ws.write(i, 4, clean("srvr", match))
    ws.write(i, 5, clean("port", match))
    ws.write(i, 6, clean("path", match))
    ws.write(i, 7, clean("desc", match))
    ws.write(i, 8, clean("cdat", match))
    ws.write(i, 9, clean("mdat", match))
    ws.write(i, 10, clean("sdmn", match))
    ws.write(i, 11, clean("atyp", match))
    ws.write(i, 12, clean("clss", match))
    ws.write(i, 13, clean("kchn", match))
    i += 1
wb.save(sys.argv[2])

print "Saved {0} passwords to '{1}'".format(i-1, sys.argv[2])