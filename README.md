# ASN.1-Reader

## Description
**PrgAsn1.pl** is a very simple but effective ASN1 viewer working as command line.  This script can use a Translation file to convert hexadecimal values in ascii or numeric values. This tool was created to read and analize TAP 3.12 and RAP 1.5 files. But It can be used to read any Type of ASN.1 BER File.

Use: `PrgAsn1.pl <File Asn1>` `[-s<File Name Conversion>]` `[-h] [-o] [-t] [-npv] [-lt] [-ll] [-nl] [-b] [-e] [-help]`

Parameters `[...]` are optional 
Parameters `<...>` are mandatory

**`[-s<File Name Conversion>]`** : you can add a Conversion File. 

         Each record has this format `<Tag Name>|<Conversion Type>|<Desc Tag>`

         Values for `<Conversion Type>` : A for Hex to Ascii
                                          B for Hex to Binary
                                          N for Hex to Number

         Example Record : 1.15.43|N|Total Records

**`[-h]`**                       : Display Hexadecimal Value for Tags  
**`[-o]`**                       : Display Offset for each Tag  
**`[-t]`**                       : Display Only value of Tag instead of Id-Tag (To use for TAP rappresentation)  
**`[-npv]`**                     : No Display primitive Values  
**`[-lt]`**                      : Display len Tag in Hexadecimal Value  
**`[-ll]`**                      : Display len Len in Hexadecimal Value  
**`[-nl]`**                      : No Display Length for Tags  
**`[-b]`**                       : Specify Byte From  
**`[-e]`**                       : Specify Byte To  

Here an example of output :

**PrgAsn1.pl ../JAsn1LC/CDARGTMARGTP02402 -sConv_TAP312 -t -o**
***
`ASN1 FILE ../JAsn1LC/CDARGTMARGTP02402 SIZE : 2967617`

`00000000:0000:  1       {TransferBatch} length : indefinite`  
`00000002:0001:     1.4  {BatchControlInfo}      length : 180`  
`00000005:0002:        1.4.196   {Sender}                                length : 5      "415247544d"h   Value (ARGTM)A`  
`00000014:0002:        1.4.182   {Recipient}                             length : 5      "4152475450"h   Value (ARGTP)A`  
`00000023:0002:        1.4.109   {FileSequenceNumber}                    length : 5      "3032343032"h   Value (02402)A`  
`00000031:0002:        1.4.108   {FileCreationTimeStamp} length : 25`  
`00000034:0003:           1.4.108.16     {LocalTimeStamp}                        length : 14     "3230323030353230303930303231"h Value (20200520090021)A`  
`00000050:0003:           1.4.108.231    {UtcTimeOffset}                         length : 5      "2d30333030"h   Value (-0300)A`  
`00000059:0002:        1.4.227   {TransferCutOffTimeStamp}       length : 25`  
`00000063:0003:           1.4.227.16     {LocalTimeStamp}                        length : 14     "3230323030353230303930303231"h Value (20200520090021)A`  
`00000079:0003:           1.4.227.231    {UtcTimeOffset}                         length : 5      "2d30333030"h   Value (-0300)A`  
`00000088:0002:        1.4.107   {FileAvailableTimeStamp}        length : 25`  
`00000091:0003:           1.4.107.16     {LocalTimeStamp}                        length : 14     "3230323030353230303930303231"h Value (20200520090021)A`  
`00000107:0003:           1.4.107.231    {UtcTimeOffset}                         length : 5      "2d30333030"h   Value (-0300)A`  
`00000116:0002:        1.4.201   {SpecificationVersionNumber}            length : 1      "03"h   Value (3)N`  
`00000121:0002:        1.4.189   {ReleaseVersionNumber}                  length : 1      "0c"h   Value (12)N`  
`00000126:0002:        1.4.162   {OperatorSpecInfoList}  length : 55`  
`00000130:0003:           1.4.162.163    {OperatorSpecInformation}               length : 51     "445746505f435f54495f415247544d41524754505f303030303032383834315f3230303532305f303030393130392e30303032"h       Value (DWFP_C_TI_ARGTMARGTP_0 000028841_200520_0009109.0002)A`  
`00000185:0001:     1.5  {AccountingInfo}        length : 75`  
`00000187:0002:        1.5.211   {TaxationList}  length : 31`  
`00000191:0003:           1.5.211.216    {TaxRateDefinition}     length : 27`  
`00000195:0004:              1.5.211.216.212     {TaxCode}                               length : 1      "01"h   Value (1)N`  
`00000200:0004:              1.5.211.216.217     {TaxType}                               length : 2      "3031"h Value (01)A`  
`00000206:0004:              1.5.211.216.215     {TaxRate}                               length : 7      "32313030303030"h       Value (2100000)A`  
`00000217:0004:              1.5.211.216.71      {ChargeType}                            length : 2      "3030"h Value (00)A`  
`00000222:0002:        1.5.135   {LocalCurrency}                         length : 3      "555344"h       Value (USD)A`  
`00000229:0002:        1.5.210   {TapCurrency}                           length : 3      "555344"h       Value (USD)A`  
`00000236:0002:        1.5.80    {CurrencyConversionList}        length : 18`  
`00000239:0003:           1.5.80.106     {CurrencyConversion}    length : 15`  
`00000242:0004:              1.5.80.106.105      {ExchangeRateCode}                      length : 1      "01"h   Value (1)N`  
`00000246:0004:              1.5.80.106.159      {NumberOfDecimalPlaces}                 length : 1      "05"h   Value (5)N`  
`00000251:0004:              1.5.80.106.104      {ExchangeRate}                          length : 3      "0186a0"h       Value (100000)N`  
`00000257:0002:        1.5.244   {TapDecimalPlaces}                      length : 1      "06"h   Value (6)N`  
`00000262:0001:     1.6  {NetworkInfo}   length : 1729`  
`00000266:0002:        1.6.234   {UtcTimeOffsetInfoList} length : 18`  
`00000270:0003:           1.6.234.233    {UtcTimeOffsetInfo}     length : 14`  
`00000274:0004:              1.6.234.233.232     {UtcTimeOffsetCode}                     length : 1      "01"h   Value (1)N`  
`00000279:0004:              1.6.234.233.231     {UtcTimeOffset}                         length : 5      "2d30333030"h   Value (-0300)A`  
`00000288:0002:        1.6.188   {RecEntityInfoList}     length : 1701`  
`00000294:0003:           1.6.188.183    {RecEntityInformation}  length : 23`  
`00000298:0004:              1.6.188.183.184     {RecEntityCode}                         length : 1      "01"h   Value (1)N`  
`00000303:0004:              1.6.188.183.186     {RecEntityType}                         length : 1      "04"h   Value (4)`  
`00000308:0004:              1.6.188.183.400     {RecEntityId}                           length : 9      "3132372e302e302e30"h   Value (127.0.0.0)A`  
`00000321:0003:           1.6.188.183    {RecEntityInformation}  length : 29`  
`...`  
***
### Prerequisites

`Executed Succesfully with perl 5, version 26, subversion 1 (v5.26.1)`

## Built With

* [Visual Code Editor](https://code.visualstudio.com) 

## Authors

* **Giovanni Palleschi** - [gpalleschi](https://github.com/gpalleschi)

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE 3.0 License - see the [LICENSE](LICENSE) file for details



