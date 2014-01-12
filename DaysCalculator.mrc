dialog -l dc {

  title Days Calculator

  size -1 -1 95 142

  option dbu

  tab Find date, 1, 2 0 90 130

  tab Find no. of days, 2

  box From, 3, 5 15 85 45

  radio Today, 4, 10 25 25 10

  text dd, 5, 40 35 10 10, center

  text MM, 6, 52 35 10 10, center

  text yyyy, 7, 64 35 20 10, center

  radio Other, 8, 10 42 25 10

  edit $date(dd), 9, 40 42 10 10, limit 2

  edit $date(mm), 10, 52 42 10 10, limit 2

  edit $date(yyyy), 11, 64 42 20 10, limit 4

  box To, 12, 5 65 85 45

  text No. of days (up to 24854), 13, 16 80 65 10, tab 1

  check +, 14, 30 90 10 10, push, tab 1

  edit , 15, 42 90 21 10, limit 5, tab 1

  radio Today, 16, 10 75 25 10, tab 2

  text dd, 17, 40 85 10 10, center, tab 2

  text MM, 18, 52 85 10 10, center, tab 2

  text yyyy, 19, 64 85 20 10, center, tab 2

  radio Other, 20, 10 92 25 10, tab 2

  edit $date(dd), 21, 40 92 10 10, limit 2, tab 2

  edit $date(mm), 22, 52 92 10 10, limit 2, tab 2

  edit $date(yyyy), 23, 64 92 20 10, limit 4, tab 2

  button &Check, 24, 20 115 25 10, default, tab 1

  button &Check, 25, 20 115 25 10, tab 2

  button &Exclude, 26, 50 115 25 10

  edit Ready, 27, 2 131 91 10, read

}

dialog -l dcX {

  title Exclusions

  size -1 -1 120 65

  option dbu

  text Exclude the following days from calculations:, 1, 5 5 110 10

  check Monday, 2, 5 15 30 15

  check Tuesday, 3, 40 15 30 15

  check Wednesday, 4, 75 15 40 15

  check Thursday, 5, 5 30 30 15

  check Friday, 6, 40 30 30 15

  check Saturday, 7, 75 30 30 15

  check Sunday, 8, 5 45 30 15

  button &OK, 9, 55 50 25 10, ok

  button &Cancel, 10, 85 50 25 10, cancel

}

on *:dialog:dayscalc:init:0: {

  did -c dayscalc 4,16 | did -b dayscalc 9-11,21-23

  set -e %dcfrm $did(4).state | set -e %dcto $did(16).state

}

on *:dialog:dayscalc:sclick:1,2: {

  did -t dayscalc $replace($dialog(dayscalc).focus,2,25,1,24)

}

on *:dialog:dayscalc:sclick:4,8: {

  set -e %dcfrm $did(4).state | did $replace($dialog(dayscalc).focus,4,-b,8,-e) dayscalc 9-11

  did -ck dayscalc $replace(%dcto,1,16,0,20)

}

on *:dialog:dayscalc:sclick:14: {

  if ($did(14) == $chr(43)) {

    did -o dayscalc 14 1 –

  }

  else {

    did -o dayscalc 14 1 $chr(43)

  }

}

on *:dialog:dayscalc:sclick:16,20: {

  set -e %dcto $did(16).state | did $replace($dialog(dayscalc).focus,16,-b,20,-e) dayscalc 21-23

  did -ck dayscalc $replace(%dcfrm,1,4,0,8)

}

on *:dialog:dayscalc:sclick:24: {

  did -r dayscalc 27

  if (%dcfrm == 1) {

    var %dcfrmdate = $date

    if ($did(15) !isnum) || (+ isin $did(15)) || (- isin $did(15)) || ($did(15) == "") || (. isin $did(15)) || ($did(15) > 24854) {

      did -a dayscalc 27 Error: Invalid input

      halt

    }

  }

  else {

    var %dcfrmdate = $did(9) $+ / $+ $did(10) $+ / $+ $did(11)

    if ($did(9) !isnum) || ($did(10) !isnum) || ($did(11) !isnum) || ($len($did(11)) == 1) || ($len($did(11)) == 3) || (+ isin %dcfrmdate) || (- isin %dcfrmdate) || (!$ctime(%dcfrmdate)) || ($did(15) !isnum) || (+ isin $did(15)) || (- isin $did(15)) || ($did(15) == "") || (. isin $did(15)) || ($did(15) > 24854) {

      did -a dayscalc 27 Error: Invalid input

      halt

    }

  }

  var %dcXnodays = $did(15)

  if (!$ctime(%dcfrmdate 0:0)) {

    var %dcop = 0

  }

  else {

    var %dcop = $ctime(%dcfrmdate 0:0)

  }

  if (Monday isin %dcXlist) && (Tuesday isin %dcXlist) && (Wednesday isin %dcXlist) && (Thursday isin %dcXlist) && (Friday isin %dcXlist) && (Saturday isin %dcXlist) && (Sunday isin %dcXlist) {

  }

  else {

    while (%dcXnodays > 0) {

      if ($did(14) == $chr(43)) {

        inc %dcop 86400

      }

      else {

        dec %dcop 86400

      }

      if ($asctime(%dcop,dddd) isin %dcXlist) {

        continue

      }

      dec %dcXnodays

    }

  }

  if (!$asctime(%dcop)) {

    did -a dayscalc 27 Error: Invalid input

  }

  else {

    did -a dayscalc 27 Date: $asctime(%dcop,dd/mm/yyyy) $+ , $asctime(%dcop,dddd)

  }

}

on *:dialog:dayscalc:sclick:25: {

  did -r dayscalc 27

  if (%dcfrm == 0) && (%dcto == 0) {

    var %dcfrmdate = $did(9) $+ / $+ $did(10) $+ / $+ $did(11)

    var %dctodate = $did(21) $+ / $+ $did(22) $+ / $+ $did(23)

    if ($did(9) !isnum) || ($did(10) !isnum) || ($did(11) !isnum) || ($len($did(11)) == 1) || ($len($did(11)) == 3) || (+ isin %dcfrmdate) || (- isin %dcfrmdate) || (!$ctime(%dcfrmdate)) || ($did(21) !isnum) || ($did(22) !isnum) || ($did(23) !isnum) || ($len($did(23)) == 1) || ($len($did(23)) == 3) || (+ isin %dctodate) || (- isin %dctodate) || (!$ctime(%dctodate)) {

      did -a dayscalc 27 Error: Invalid input

      halt

    }

  }

  else if (%dcfrm == 0) && (%dcto == 1) {

    var %dcfrmdate = $did(9) $+ / $+ $did(10) $+ / $+ $did(11)

    var %dctodate = $date

    if ($did(9) !isnum) || ($did(10) !isnum) || ($did(11) !isnum) || ($len($did(11)) == 1) || ($len($did(11)) == 3) || (+ isin %dcfrmdate) || (- isin %dcfrmdate) || (!$ctime(%dcfrmdate)) {

      did -a dayscalc 27 Error: Invalid input

      halt

    }

  }

  else if (%dcfrm == 1) && (%dcto == 0) {

    var %dcfrmdate = $date

    var %dctodate = $did(21) $+ / $+ $did(22) $+ / $+ $did(23)

    if ($did(21) !isnum) || ($did(22) !isnum) || ($did(23) !isnum) || ($len($did(23)) == 1) || ($len($did(23)) == 3) || (+ isin %dctodate) || (- isin %dctodate) || (!$ctime(%dctodate)) {

      did -a dayscalc 27 Error: Invalid input

      halt

    }

  }

  else {

    var %dcop = 0 | goto output

  }

  var %dcop = $calc(($ctime(%dctodate) - $ctime(%dcfrmdate)) / 86400)

  if (!$ctime(%dcfrmdate 0:0)) {

    var %dcXfrmdate = 0

  }

  else {

    var %dcXfrmdate = $ctime(%dcfrmdate 0:0)

  }

  if (!$ctime(%dctodate 0:0)) {

    var %dcXtodate = 0

  }

  else {

    var %dcXtodate = $ctime(%dctodate 0:0)

  }

  if (%dcXtodate > %dcXfrmdate) {

    while (%dcXtodate > %dcXfrmdate) && (%dcop != 0) {

      if ($asctime(%dcXtodate,dddd) isin %dcXlist) {

        dec %dcop

      }

      dec %dcXtodate 86400

    }

  }

  else {

    while (%dcXfrmdate > %dcXtodate) && (%dcop != 0) {

      if ($asctime(%dcXfrmdate,dddd) isin %dcXlist) {

        inc %dcop

      }

      dec %dcXfrmdate 86400

    }

  }

  :output

  did -a dayscalc 27 No. of days: %dcop

}

on *:dialog:dayscalc:sclick:26: {

  if (!$dialog(dayscalcex)) {

    dialog -m dayscalcex dcX

  }

  dialog -rv dayscalcex dcX

}

on *:dialog:dayscalc:close:0: {

  unset %dcfrm | unset %dcto

  if ($dialog(dayscalcex) != $null) {

    dialog -x dayscalcex

  }

}

on *:dialog:dayscalcex:init:0: {

  var %dcXday = 2

  while (%dcXday <= 8) {

    if ($did(%dcXday) isin %dcXlist) {

      did -c dayscalcex %dcXday

    }

    inc %dcXday

  }

}

on *:dialog:dayscalcex:sclick:9: {

  unset %dcXlist | var %dcXday = 2

  while (%dcXday <= 8) {

    if ($did(%dcXday).state == 1) {

      set %dcXlist %dcXlist $did(%dcXday)

    }

    inc %dcXday

  }

}

on *:unload: {

  unset %dcXlist

}

alias dayscalc {

  if (!$dialog(dayscalc)) {

    dialog -m dayscalc dc

  }

  dialog -rv dayscalc dc

}

menu menubar,status {

  &Days Calculator (/dayscalc):/dayscalc

}

