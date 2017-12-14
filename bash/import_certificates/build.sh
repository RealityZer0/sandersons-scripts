#!/bin/sh

cd Certificates
tar -cyf ../certs.bz2 *
cd ..
make dmg
rm certs.bz2
