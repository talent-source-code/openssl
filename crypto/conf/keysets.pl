#! /usr/bin/env perl
# Copyright 1995-2016 The OpenSSL Project Authors. All Rights Reserved.
#
# Licensed under the OpenSSL license (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# https://www.openssl.org/source/license.html

$NUMBER=0x01;
$UPPER=0x02;
$LOWER=0x04;
$UNDER=0x100;
$PUNCTUATION=0x200;
$WS=0x10;
$ESC=0x20;
$QUOTE=0x40;
$DQUOTE=0x400;
$COMMENT=0x80;
$FCOMMENT=0x800;
$EOF=0x08;
$HIGHBIT=0x1000;

foreach (0 .. 255)
	{
	$v=0;
	$c=sprintf("%c",$_);
	$v|=$NUMBER	if ($c =~ /[0-9]/);
	$v|=$UPPER	if ($c =~ /[A-Z]/);
	$v|=$LOWER	if ($c =~ /[a-z]/);
	$v|=$UNDER	if ($c =~ /_/);
	$v|=$PUNCTUATION if ($c =~ /[!\.%&\*\+,\/;\?\@\^\~\|-]/);
	$v|=$WS		if ($c =~ /[ \t\r\n]/);
	$v|=$ESC	if ($c =~ /\\/);
	$v|=$QUOTE	if ($c =~ /['`"]/); # for emacs: "`'}/)
	$v|=$COMMENT	if ($c =~ /\#/);
	$v|=$EOF	if ($c =~ /\0/);
	$v|=$HIGHBIT	if ($c =~/[\x80-\xff]/);

	push(@V_def,$v);
	}

foreach (0 .. 255)
	{
	$v=0;
	$c=sprintf("%c",$_);
	$v|=$NUMBER	if ($c =~ /[0-9]/);
	$v|=$UPPER	if ($c =~ /[A-Z]/);
	$v|=$LOWER	if ($c =~ /[a-z]/);
	$v|=$UNDER	if ($c =~ /_/);
	$v|=$PUNCTUATION if ($c =~ /[!\.%&\*\+,\/;\?\@\^\~\|-]/);
	$v|=$WS		if ($c =~ /[ \t\r\n]/);
	$v|=$DQUOTE	if ($c =~ /["]/); # for emacs: "}/)
	$v|=$FCOMMENT	if ($c =~ /;/);
	$v|=$EOF	if ($c =~ /\0/);
	$v|=$HIGHBIT	if ($c =~/[\x80-\xff]/);

	push(@V_w32,$v);
	}

print <<"EOF";
/*
 * WARNING: do not edit!
 * Generated by crypto/conf/keysets.pl
 *
 * Copyright 1995-2016 The OpenSSL Project Authors. All Rights Reserved.
 * Licensed under the OpenSSL license (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#define CONF_NUMBER             $NUMBER
#define CONF_UPPER              $UPPER
#define CONF_LOWER              $LOWER
#define CONF_UNDER              $UNDER
#define CONF_PUNCTUATION        $PUNCTUATION
#define CONF_WS                 $WS
#define CONF_ESC                $ESC
#define CONF_QUOTE              $QUOTE
#define CONF_DQUOTE             $DQUOTE
#define CONF_COMMENT            $COMMENT
#define CONF_FCOMMENT           $FCOMMENT
#define CONF_EOF                $EOF
#define CONF_HIGHBIT            $HIGHBIT
#define CONF_ALPHA              (CONF_UPPER|CONF_LOWER)
#define CONF_ALPHA_NUMERIC      (CONF_ALPHA|CONF_NUMBER|CONF_UNDER)
#define CONF_ALPHA_NUMERIC_PUNCT (CONF_ALPHA|CONF_NUMBER|CONF_UNDER| \\
                                        CONF_PUNCTUATION)

#define KEYTYPES(c)             ((const unsigned short *)((c)->meth_data))
#ifndef CHARSET_EBCDIC
# define IS_COMMENT(c,a)         (KEYTYPES(c)[(a)&0xff]&CONF_COMMENT)
# define IS_FCOMMENT(c,a)        (KEYTYPES(c)[(a)&0xff]&CONF_FCOMMENT)
# define IS_EOF(c,a)             (KEYTYPES(c)[(a)&0xff]&CONF_EOF)
# define IS_ESC(c,a)             (KEYTYPES(c)[(a)&0xff]&CONF_ESC)
# define IS_NUMBER(c,a)          (KEYTYPES(c)[(a)&0xff]&CONF_NUMBER)
# define IS_WS(c,a)              (KEYTYPES(c)[(a)&0xff]&CONF_WS)
# define IS_ALPHA_NUMERIC(c,a)   (KEYTYPES(c)[(a)&0xff]&CONF_ALPHA_NUMERIC)
# define IS_ALPHA_NUMERIC_PUNCT(c,a) \\
                                (KEYTYPES(c)[(a)&0xff]&CONF_ALPHA_NUMERIC_PUNCT)
# define IS_QUOTE(c,a)           (KEYTYPES(c)[(a)&0xff]&CONF_QUOTE)
# define IS_DQUOTE(c,a)          (KEYTYPES(c)[(a)&0xff]&CONF_DQUOTE)
# define IS_HIGHBIT(c,a)         (KEYTYPES(c)[(a)&0xff]&CONF_HIGHBIT)

#else                           /* CHARSET_EBCDIC */

# define IS_COMMENT(c,a)         (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_COMMENT)
# define IS_FCOMMENT(c,a)        (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_FCOMMENT)
# define IS_EOF(c,a)             (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_EOF)
# define IS_ESC(c,a)             (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_ESC)
# define IS_NUMBER(c,a)          (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_NUMBER)
# define IS_WS(c,a)              (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_WS)
# define IS_ALPHA_NUMERIC(c,a)   (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_ALPHA_NUMERIC)
# define IS_ALPHA_NUMERIC_PUNCT(c,a) \\
                                (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_ALPHA_NUMERIC_PUNCT)
# define IS_QUOTE(c,a)           (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_QUOTE)
# define IS_DQUOTE(c,a)          (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_DQUOTE)
# define IS_HIGHBIT(c,a)         (KEYTYPES(c)[os_toascii[a]&0xff]&CONF_HIGHBIT)
#endif                          /* CHARSET_EBCDIC */

EOF

print "static const unsigned short CONF_type_default[256] = {";

for ($i=0; $i<256; $i++)
	{
	print "\n   " if ($i % 8) == 0;
	printf " 0x%04X,",$V_def[$i];
	}

print "\n};\n\n";

print "static const unsigned short CONF_type_win32[256] = {";

for ($i=0; $i<256; $i++)
	{
	print "\n   " if ($i % 8) == 0;
	printf " 0x%04X,",$V_w32[$i];
	}

print "\n};\n";
