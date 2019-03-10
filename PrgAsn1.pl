#!/usr/bin/perl -w

use bigint;

#
# GPSoft - Giovanni Palleschi - 2010-2019 PrgAsn1.pl Utility read file ASN.1 - Ver. 3.1
#
# perl PrgAsn1.pl <File Asn1> [<File Name Conversion>]
#
# [...] opcional
#
# This script perl produce a BER Codification in STDOUT of an ASN1 File.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#Start Declarative 

# Start Function to convert hex value 

sub dataConvert {
  my ($hexvalue, $type) = @_;
  $valueConv = $hexvalue;

# Hex to Ascii
  if ( $type eq 'A' ) {
     $valueConv = pack("H*", $hexvalue);
  }
# Hex to Binary
  if ( $type eq 'B' ) {
     $valueConv = unpack("B*", pack("H*", $hexvalue));
  }
# Hex to Number
  if ( $type eq 'N' ) {
     $valueConv = hex $hexvalue;
  }

  return $valueConv;
}

# End Function to convert hex value 
sub help {
    print "\n\nPrgAsn1.pl version $Version\n\n";
    print "Use: PrgAsn1.pl <File Asn1> [-s<File Name Conversion>] [-h] [-o] [-t] [-nl] [-help]\n\n";
    print "[...] are optional parameters\n\n";
    print "[-s<File Name Conversion>] : you can add a Conversion File. Each record has this format <Tag Name>|<Conversion Type>|<Desc Tag>\n";
    print "                             Values for <Conversion Type> : A for Hex to Ascii\n";
    print "                                                            B for Hex to Binary\n";
    print "                                                            N for Hex to Number\n\n";
    print "                             Example Record : 1.15.43|N|Total Records\n\n";
    print "[-h]                       : Display Hexadecimal Value for Tags\n\n";
    print "[-o]                       : Display Offset for each Tag\n\n";
    print "[-t]                       : Display Only value of Tag instead of Id-Tag (To use for TAP rappresentation)\n\n";
    print "[-nl]                      : No Display Length for Tags\n\n";
}

sub displayTagPrimitive {

# Code Tag

	$RecordToDisplay = $CodeTag;

	if ( $flagConv eq 1 ) {
#           $RecordToDisplay = $RecordToDisplay . "\t{" . print("\t{%.40s}"",$DescFieldToDisplay) . "}";
            $RecAppo = sprintf("\t{%s}",$DescFieldToDisplay);
	    $RecAppo2 = sprintf("%-40s",$RecAppo);
	    $RecordToDisplay = $RecordToDisplay . $RecAppo2;
        }

# Length
	if ( $flagLength eq 1 ) {
  	   $RecordToDisplay = $RecordToDisplay . "\t" . $LengthTAGToDisplay;
        }

# Hexadecimal Value

	$RecordToDisplay = $RecordToDisplay . "\t" . $hexValueToDisplay;
	
# Traslated Value

	if ( $flagConv eq 1 ) {
	   $RecordToDisplay = $RecordToDisplay . "\tValue (" . "$datoConvToDisplay" . ")" . $typeConv;
        }

# Display 
	print $RecordToDisplay;
}

sub displayTagStructured {

# Code Tag

	$RecordToDisplay = $CodeTag;

	if ( $flagConv eq 1 ) {
           $RecordToDisplay = $RecordToDisplay . "\t{" . $DescFieldToDisplay . "}";
        }

# Length
	if ( $flagLength eq 1 ) {
	   $RecordToDisplay = $RecordToDisplay . "\t" . $LengthTAGToDisplay;
        }

# Display 
	print $RecordToDisplay;
}



sub getConv {

  open FILEC, $_[0] or die "Couldn't open file: $_[0] $!\n";

  foreach $line (<FILEC>) {
    if ( length($line) > 4 ) {
       @fields = split(/\|/, $line);
       if ( scalar(@fields) ne 3 ) {
          printf("Error in Config File <$_[0]> line <$line> expected 3 fields. <Tag>|<Conv>|<Desc>\n");
          close(FILEC);
          exit 0;
       }
       $tagToFind = $fields[0];
       $valueToFind = $fields[1] . $fields[2];
       $convs{ $tagToFind } =  $valueToFind;
    }
  }

  close FILEC;
}

sub CtrlInfinitiveEnd {

    if ( $_[0] >= 0 )  { 
       return 0;
    }

    my $retCode = "00";
    my $curpos  = tell FILE;
   
    for($i=0;$i<2;$i++) {
       last if ( readAsn1() ne "00" );
    }

    if ( $i == 2 ) {
       return 1;
    }

    seek(FILE, $curpos, 0);
    return 0;
}

sub GetPrimitiveValue {

  my ($lenValue) = @_;
  my $sretvalue = "";
  $ind = 0;

  while ( ($lenValue > 0 && $ind < $lenValue) or
          ($lenValue < 0 && CtrlInfinitiveEnd($lenValue) == 0) 
	) {
   
     $sretvalue = sprintf("%s%s",$sretvalue,readAsn1());
     $ind = $ind + 1;

  }

  return $sretvalue
}

sub readAsn1 { 
    if ( eof(FILE) ) {

       printf("\n");
       close(FILE);
       exit 0;
    }
    my $retCode = sprintf("%02x",ord(getc( FILE )));
    return $retCode;
}

sub getTag {

    my $length;
    my $startByte = tell FILE;
    my $taghex = readAsn1();
    my $next = hex $taghex;

    if ( $next == 0 ) { return; }

    $next = $next & 0xff;
    
    $id = ($next & 192) >> 6;

    if ( (($next & 32) >> 5) == 1 ) {
       $flag = "false";
    }
    else {
       $flag = "true";
    }

    $tag = ($next & 31);

    if ( $tag == 31 )
    {
      $taghex = sprintf("%s%s",$taghex,readAsn1());
      $nextbis = hex $taghex;

      $nextbis = $nextbis & 0xff;

      $tag = $nextbis & 127;
      while( 128 == ( $nextbis & 128 ) )
      {
        $taghex = sprintf("%s%s",$taghex,readAsn1());
        $nextbis = hex $taghex;

        $nextbis = $nextbis & 0xff;
        $tag = $tag << 7 | ( $nextbis & 127 );
      }
    }

    if ( $flagTap eq 1 ) {
       $ATag[$iLevel] =  sprintf ("$tag"); 
    } else {
       $ATag[$iLevel] =  sprintf ("$id-$tag"); 
    }

    $HTag[$iLevel] =  sprintf ("$taghex"); 

    #    if ( $flagTap eq 0 ) {
       $TagApp = $ATag[0];
       $TagAppH = $HTag[0];
       for($iInd=1;$iInd<$iLevel+1;$iInd++) {
         $TagApp2 = $TagApp . "." . $ATag[$iInd];
         $TagApp = $TagApp2;
         $TagApp2H = $TagAppH . "." . $HTag[$iInd];
         $TagAppH = $TagApp2H;
       }
       #} else {
       #$TagApp = $ATag[$iLevel];
       # $TagAppH = $HTag[$iLevel];
       # }
    
    if ( $flagHex eq 1 ) {
          $CodeTag = sprintf ("$TagApp\t[$TagAppH]");
    } else {
          $CodeTag = sprintf ("$TagApp");
    }

    $next = hex readAsn1();

    $nbyte = $next & 127;

    if ( ($next & 128) == 0 )
    {
      $length = $nbyte;
    }
    else
    {
      if ( $nbyte > 0 )
      {
        if ( $nbyte > 4 ) {
          $CodeTag = "ERROR TAG";
          return;
        }
        else {
          $next = hex readAsn1();

          $length = $next;
          for($contabyte=1;$contabyte<$nbyte;$contabyte++)
          {
            $next = hex readAsn1();

            $length = $length << 8 | ( $next );
          }
        }
      }
      else
      {

# Length Infinity

        $length = -1;
      }
    }
    printf("\n");

# Print OffSet
 
    if ( $flagOffSet eq 1 ) {
      printf("%08d:%04d:  ",$startByte,$iLevel);
    }

    for($i=0;$i<$iLevel;$i++) {
       print("   ");
    }

    if ( $flagLength eq 1 ) {
       if ( $length < 0 ) {
          $LengthTAGToDisplay = "length : indefinite";
       } else {
          $LengthTAGToDisplay = "length : $length";
       }
    } 

# Primitive Tag read value

    if ( $flag eq "true" ) {
       $value = GetPrimitiveValue($length);

       $hexValueToDisplay = "\"$value\"h";

       $flagConv = 0;
       if ( keys( %convs ) > 0 ) {
          if ( $flagTap eq 1 ) {
            $TagAppToFind = $ATag[$iLevel];
          } else {
            $TagAppToFind = $TagApp;
          }
          if (exists($convs{$TagAppToFind})) {
             $flagConv = 1;
             $record = $convs{$TagAppToFind};
             $typeConv = substr($record,0,1);
	     $DescFieldToDisplay = substr($record,1);
	     $DescFieldToDisplay = substr($DescFieldToDisplay,0,length($DescFieldToDisplay)-1);
             $datoConvToDisplay = dataConvert($value,$typeConv);
          }
       }

       displayTagPrimitive();

    } else {

# Structured Tag

       $flagConv = 0;
       if ( keys( %convs ) > 0 ) {
          if ( $flagTap eq 1 ) {
            $TagAppToFind = $ATag[$iLevel];
          } else {
            $TagAppToFind = $TagApp;
          }
          if (exists($convs{$TagAppToFind})) {
             $flagConv = 1;
             $record = $convs{$TagAppToFind};
             $typeConv = substr($record,0,1);
	     $DescFieldToDisplay =  substr($record,1);
	     $DescFieldToDisplay = substr($DescFieldToDisplay,0,length($DescFieldToDisplay)-1);
          }
       }

       displayTagStructured();

       # Structured Tag read next tag

       $iLevel  = $iLevel + 1;
       while ( (($length > 0) && ((tell FILE) - $startByte) < $length) or
	       (($length < 0) && CtrlInfinitiveEnd($length) == 0) ) {
	       getTag();
       }
       $iLevel  = $iLevel - 1;
   }
   return;
}

# Start Prg

# Variable Convertions
my %hash = ();
$flagHex=0;
$flagOffSet=0;
$flagTap=0;
$flagLength=1;
$Version="3.1 02/03/2019";

#End Declarative 

if ($#ARGV < 0 ) {
	help();
	exit;
}

# Check Parameters
for($i = 1; $i <= $#ARGV; $i++)
{
	if ( substr($ARGV[$i],0,2) eq "-s" ) {
		getConv(substr($ARGV[$i],2));
	}

	# Notazione Hex 
	if ( substr($ARGV[$i],0,2) eq "-h" ) {
		$flagHex = 1;
	}

	# Notazione OffSet
	if ( substr($ARGV[$i],0,2) eq "-o" ) {
		$flagOffSet = 1;
	}
	# Notazione Tap
	if ( substr($ARGV[$i],0,2) eq "-t" ) {
		$flagTap = 1;
	}
	# Notazione No Length
	if ( substr($ARGV[$i],0,3) eq "-nl" ) {
		$flagLength = 0;
	}
}

$flag_cont=1;

open FILE, $ARGV[0] or die "Couldn't open file: $ARGV[0] $!\n";

$sizeFile = -s $ARGV[0];

printf("\nASN1 FILE $ARGV[0] SIZE : $sizeFile\n");

$iLevel  = 0;
while ( $flag_cont == 1 ) {
	getTag();
}

