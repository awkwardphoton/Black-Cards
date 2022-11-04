#!/bin/bash

title () {
  clear
  echo "Awkwardphoton's BBFC Black Card Creator Script"
  echo "---------------------------------------------"
}
title
echo Enter Film name
read TITLE
SEARCH=$(echo "$TITLE" | tr -d '[:punct:]')
SEARCH=${SEARCH// /%20}
TITLE=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -1)
LINK=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -1)
TITLE=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=<span>).*?(?=</span>)' | head -1 | tail -1)

touch "$TITLE".txt

if [ -f "$TITLE".txt ]
  then
    rm "$TITLE".txt
fi

if [[ $(echo $TITLE | wc -c) -gt "22" ]] && [[ $TITLE == *":"* ]]
  then
    echo LINES="2" >> "$TITLE".txt
    LINEONE=$(echo "$TITLE" | cut -d ":" -f 1)
    LINEONE="$LINEONE:"
    LINETWO=$(echo "$TITLE" | cut -d ":" -f 2)
    LINETWO=$(echo "$LINETWO" | xargs)
    echo TITLE="\"$LINEONE" >> "$TITLE".txt
    echo "$LINETWO\"" >> "$TITLE".txt
    SEARCH=${LINETWO// /%20}
  elif
    [[ $(echo $TITLE | wc -c) -gt "22" ]] && [[ $TITLE == *"-"* ]]
  then
    echo LINES="2" >> "$TITLE".txt
    LINEONE=$(echo "$TITLE" | cut -d "-" -f 1)
    LINEONE="$LINEONE -"
    LINETWO=$(echo "$TITLE" | cut -d "-" -f 2)
    LINETWO=$(echo "$LINETWO" | xargs)
    echo TITLE="\"$LINEONE" >> "$TITLE".txt
    echo "$LINETWO\"" >> "$TITLE".txt
    SEARCH=${LINETWO// /%20}
  elif [[ $(echo $TITLE | wc -w) -gt "4" ]]
    then
      echo LINES="2" >> "$TITLE".txt
      LINEONE=$(echo "$TITLE" | cut -d " " -f -6)
      LINETWO=$(echo "$TITLE" | cut -d " " -f 7-)
      if [[ $(echo $LINEONE | wc -c) -gt "22" ]]; then
      LINEONE=$(echo "$TITLE" | cut -d " " -f -5)
      LINETWO=$(echo "$TITLE" | cut -d " " -f 6-)
      fi
      echo TITLE="\"$LINEONE" >> "$TITLE".txt
      echo "$LINETWO\"" >> "$TITLE".txt
  else
    echo LINES="1" >> "$TITLE".txt
    echo TITLE="\"$TITLE\"" >> "$TITLE".txt
    SEARCH=${TITLE// /%20}     
fi

LINK=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -1)
YEAR=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=<h4 class="Type_base__2EnB2">).*?(?=<)' | head -2 | tail -1)
RATING=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<="Rated ).*?(?=")' | head -8 | tail -1)
NOTES=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=3q3Or">).*?(?=</div>)' | head -1) 
BBFCref=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=MediaDetails_Value__apBzp">).*?(?=</h4>)' | head -2 | tail -1)
Classified_Date=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=MediaDetails_Value__apBzp">).*?(?=</h4>)' | head -1 | tail -1)
TMDBID=$(curl -s "https://www.themoviedb.org/search?query=$SEARCH%20" | cat | grep -oP -m 1 '(?<=class="result" href="/movie/).*?(?=">)' | head -1)
Release_Date=$( curl -s -N "https://www.themoviedb.org/search?query=$SEARCH" | grep -oP -m 1 '(?<=<span class="release_date">).*?(?=</span>)' | head -1 | tail -1)
Release_Date=$(date -d "$Release_Date" +%Y-%m-%d)
if [ -z "$TMDBID" ] 
  then
    TMDBID=$(curl -s "https://www.themoviedb.org/search?query=$SEARCH%20y:$YEAR" | cat | grep -oP -m 1 '(?<=class="result" href="/movie/).*?(?=">)' | head -1)
fi


echo YEAR="\"$YEAR\"" >> "$TITLE".txt
echo NOTES="\"$NOTES\"" >> "$TITLE".txt
echo RATING="\"${RATING^^}\"" >> "$TITLE".txt
echo BBFCref="\"$BBFCref\"" >> "$TITLE".txt
echo TMDBID="\"$TMDBID\"" >> "$TITLE".txt
echo Classified_Date="\"$Classified_Date\"" >> "$TITLE".txt
echo Release_Date="\"$Release_Date\"" >> "$TITLE".txt

RATING=${RATING^^}

# BLACK CARD DESIGNS
Start_01=1913-01-01
End_01=1913-12-31
Start_02=1932-01-01
End_02=1932-12-31
Start_03=1967-01-01
End_03=1967-12-31
Start_04=1971-01-01
End_04=1982-12-18
Start_05=1982-12-19
End_05=2002-12-31
Start_07=2003-01-01
End_07=2011-12-31
Start_08=2012-01-01
End_08=2012-02-29
Start_09=2012-03-01
End_09=2012-04-30
Start_10=2012-05-01
End_10=2012-06-30
Start_11=2012-07-01
End_11=2012-08-30
Start_12=2012-08-03
End_12=2012-08-03
Start_13=2012-09-01
End_13=2012-10-31
Start_14=2012-11-01
End_14=2012-12-31
Start_15=2013-01-01
End_15=2019-04-26
Start_16=2019-02-06
End_16=$(date +%F)

# PRESIDENTS OF THE BBFC
# George A. Redford
Start_George_Redford=1913-01-01
End_George_Redford=1916-12-11
# T.P O'Connor
Start_TP_OConnor=1916-12-11
End_TP_OConnor=1929-10-18
# Edward Shortt
Start_Edward_Shortt=1929-10-21
End_Edward_Shortt=1935-10-10
# William Tyrrell
Start_William_Tyrrell=1935-10-25
End_William_Tyrrell=1948-03-22
# Sir Sidney Harris
Start_Sidney_Harris=1948-03-31
End_Sidney_Harris=1960-05-31
# Herbert Morrison, Baron Morrison of Lambeth
Start_Herbert_Morrison=1960-06-1
End_Herbert_Morrison=1965-03-06
# David Ormsby-Gore, 5th Baron of Harlech
Start_David_Ormsby=1965-07-21
End_David_Ormsby=1985-01-26
# George Lascelles, 7th Earl of Harewood
Start_George_Laselles=1985-06-01
End_George_Laselles=1997-12-18
# Andreas Whittham Smith
Start_Andreas_Whittham_Smith=1997-12-18
End_Andreas_Whittham_Smith=2002-08-01
# Sir Quentin Thomas
Start_Quentin_Thomas=2002-08-01
End_Quentin_Thomas=2012-10-17
# Patrick Swaffer
Start_Patrick_Swaffer=2012-10-17
End_Patrick_Swaffer=2022-10-17
# Natasha Kaplinsky
Start_Natasha_Kaplinsky=2022-10-17
End_Natasha_Kaplinsky=$(date +%F)

# DIRECTORS OF THE BBFC
# Joseph Brooke Wilkinson - Chief Executive
Start_Joseph_Brooke_Wilkinson=1913-01-01
End_Joseph_Brooke_Wilkinson=1948-07-15
# A. T. L. Watkins - Chief Executive
Start_ATL_Watkins=1948-07-26
End_ATL_Watkins=1957-01-23
# John Nicholls - Chief Executive
Start_John_Nicholls=1957-01-23
End_John_Nicholls=1958-04-30
# John Trevelyan - Chief Executive
Start_John_Trevelyan=1958-05-22
End_John_Trevelyan=1971-07-01
# Stephen Murphy - Chief Executive
Start_Stephen_Murphy=1971-07-01
End_Stephen_Murphy=1975-06-18
# James Ferman - Director
Start_James_Ferman=1975-06-18
End_James_Ferman=1999-01-10
# Robin Duval - Director
Start_Robin_Duval=1999-01-11
End_Robin_Duval=2004-09-19
# David Cooke - Director
Start_David_Cooke=2004-09-20
End_David_Cooke=2016-03-10
# David Austin - Chief Executive
Start_David_Austin=2016-03-10
End_David_Austin=$(date +%F)





if [[ "$Release_Date" > "$Start_01" ]] && [[ "$Release_Date" < "$End_01" ]]
  then
    BLACKCARD=01
elif [[ "$Release_Date" > "$Start_02" ]] && [[ "$Release_Date" < "$End_02" ]]
  then
    BLACKCARD=02
elif [[ "$Release_Date" > "$Start_03" ]] && [[ "$Release_Date" < "$End_03" ]]
  then
    BLACKCARD=03
elif [[ "$Release_Date" > "$Start_04" ]] && [[ "$Release_Date" < "$End_04" ]]
  then
    BLACKCARD=04
elif [[ "$Release_Date" > "$Start_05" ]] && [[ "$Release_Date" < "$End_05" ]]
  then
    BLACKCARD=05  
elif [[ "$Release_Date" > "$Start_06" ]] && [[ "$Release_Date" < "$End_06" ]]
  then
    BLACKCARD=06
elif [[ "$Release_Date" > "$Start_07" ]] && [[ "$Release_Date" < "$End_07" ]]
  then
    BLACKCARD=07
elif [[ "$Release_Date" > "$Start_08" ]] && [[ "$Release_Date" < "$End_08" ]]
  then
    BLACKCARD=08
elif [[ "$Release_Date" > "$Start_09" ]] && [[ "$Release_Date" < "$End_09" ]]
  then
    BLACKCARD=09
elif [[ "$Release_Date" > "$Start_10" ]] && [[ "$Release_Date" < "$End_10" ]]
  then
    BLACKCARD=10
elif [[ "$Release_Date" > "$Start_11" ]] && [[ "$Release_Date" < "$End_11" ]]
  then
    BLACKCARD=11
elif [[ "$Release_Date" > "$Start_12" ]] && [[ "$Release_Date" < "$End_12" ]]
  then
    BLACKCARD=12
elif [[ "$Release_Date" > "$Start_13" ]] && [[ "$Release_Date" < "$End_13" ]]
  then
    BLACKCARD=13
elif [[ "$Release_Date" > "$Start_14" ]] && [[ "$Release_Date" < "$End_14" ]]
  then
    BLACKCARD=14
elif [[ "$Release_Date" > "$Start_15" ]] && [[ "$Release_Date" < "$End_15" ]]
  then
    BLACKCARD=15
elif [[ "$Release_Date" > "$Start_16" ]] && [[ "$Release_Date" < "$End_16" ]]
  then
    BLACKCARD=16
fi

if [[ "$Release_Date" > "$Start_Joseph_Brooke_Wilkinson" ]] && [[ "$Release_Date" < "$End_Joseph_Brooke_Wilkinson" ]]
  then
    DIRECTOR="Wilkinson"
elif [[ "$Release_Date" > "$Start_ATL_Watkins" ]] && [[ "$Release_Date" < "$End_ATL_Watkins" ]]
  then
    DIRECTOR="Watkins"
elif [[ "$Release_Date" > "$Start_John_Nicholls" ]] && [[ "$Release_Date" < "$End_John_Nicholls" ]]
  then
    DIRECTOR="Nicholls"
elif [[ "$Release_Date" > "$Start_John_Trevelyan" ]] && [[ "$Release_Date" < "$End_John_Trevelyan" ]]
  then
    DIRECTOR="Trevelyan"
elif [[ "$Release_Date" > "$Start_Stephen_Murphy" ]] && [[ "$Release_Date" < "$End_Stephen_Murphy" ]]
  then
    DIRECTOR="Murphy"
elif [[ "$Release_Date" > "$Start_James_Ferman" ]] && [[ "$Release_Date" < "$End_James_Ferman" ]]
  then
    DIRECTOR="Ferman"
elif [[ "$Release_Date" > "$Start_Robin_Duval" ]] && [[ "$Release_Date" < "$End_Robin_Duval" ]]
  then
    DIRECTOR="Duval"
elif [[ "$Release_Date" > "$Start_David_Cooke" ]] && [[ "$Release_Date" < "$End_David_Cooke" ]]
  then
    DIRECTOR="Cooke"
elif [[ "$Release_Date" > "$Start_David_Austin" ]] && [[ "$Release_Date" < "$End_David_Austin" ]]
  then
    DIRECTOR="Austin"
fi
  

if [[ "$Release_Date" > "$Start_George_Redford" ]] && [[ "$Release_Date" < "$End_George_Redford" ]]
  then
    PRESIDENT="Redford"
elif [[ "$Release_Date" > "$Start_TP_OConnor" ]] && [[ "$Release_Date" < "$End_TP_OConnor" ]]
  then
    PRESIDENT="O'Connor"
elif [[ "$Release_Date" > "$Start_Edward_Shortt" ]] && [[ "$Release_Date" < "$End_Edward_Shortt" ]]
  then
    PRESIDENT="Shortt"
elif [[ "$Release_Date" > "$Start_William_Tyrrell" ]] && [[ "$Release_Date" < "$End_William_Tyrrell" ]]
  then
    PRESIDENT="Tyrrell"
elif [[ "$Release_Date" > "$Start_Sidney_Harris" ]] && [[ "$Release_Date" < "$End_Sidney_Harris" ]]
  then
    PRESIDENT="Harris"
elif [[ "$Release_Date" > "$Start_Herbert_Morrison" ]] && [[ "$Release_Date" < "$End_Herbert_Morrison" ]]
  then
    PRESIDENT="Morrison"
elif [[ "$Release_Date" > "$Start_David_Ormsby" ]] && [[ "$Release_Date" < "$End_David_Ormsby" ]]
  then
    PRESIDENT="Ormsby-Gore"
elif [[ "$Release_Date" > "$Start_George_Laselles" ]] && [[ "$Release_Date" < "$End_George_Laselles" ]]
  then
    PRESIDENT="Laselles"
elif [[ "$Release_Date" > "$Start_Andreas_Whittham_Smith" ]] && [[ "$Release_Date" < "$End_Andreas_Whittham_Smith" ]]
  then
    PRESIDENT="Whittham"
elif [[ "$Release_Date" > "$Start_Quentin_Thomas" ]] && [[ "$Release_Date" < "$End_Quentin_Thomas" ]]
  then
    PRESIDENT="Thomas"
elif [[ "$Release_Date" > "$Start_Patrick_Swaffer" ]] && [[ "$Release_Date" < "$End_Patrick_Swaffer" ]]
  then
    PRESIDENT="Swaffer"
elif [[ "$Release_Date" > "$Start_Natasha_Kaplinsky" ]] && [[ "$Release_Date" < "$End_Natasha_Kaplinsky" ]]
  then
    PRESIDENT="Kaplinsky"
fi




if [[ "$DIRECTOR"="James Ferman" ]]
then
  CEO="Director"
fi
if [[ "$DIRECTOR"="Robin Duval" ]]
then
  CEO="Director"
fi
if [[ "$DIRECTOR"="David Cooke" ]]
then
  CEO="Director"
fi

if [[ "$CEO"="" ]]; then
  CEO="Chief Executive"
fi





clear
echo "$TITLE"
echo "Your Film Was Released $Release_Date."
echo "It Used Black Card Design #$BLACKCARD."
echo "The BBFC President Was $PRESIDENT."
echo "The BBFC $CEO Was $DIRECTOR."