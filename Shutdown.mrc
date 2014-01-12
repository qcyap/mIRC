dialog -l sd {

  title Shutdown Windows

  size -1 -1 85 116

  option dbu

  text dd, 1, 30 5 10 10, center

  text MM, 2, 42 5 10 10, center

  text yyyy, 3, 54 5 20 10, center

  text Date:, 4, 10 14 15 10

  edit , 5, 30 12 10 10, limit 2

  edit , 6, 42 12 10 10, limit 2

  edit , 7, 54 12 20 10, limit 4

  text HH, 8, 30 25 10 10, center

  text mm, 9, 42 25 10 10, center

  text Time:, 10, 10 34 15 10

  edit , 11, 30 32 10 10, limit 2

  edit , 12, 42 32 10 10, limit 2

  text Type:, 13, 10 52 15 10

  combo 14, 30 50 40 0, drop

  check Auto-close unresponding programs, 15, 9 65 70 15, multi

  button &Start, 16, 15 85 25 10, ok

  button S&top, 17, 45 85 25 10

  edit , 18, 0 100 85 16, read multi

}

on *:dialog:shutdown:init:0: {

  did -ac shutdown 14 Shutdown | did -a shutdown 14 Restart | did -a shutdown 14 Logoff

  if ((%sddate != $null) && (%sdtime != $null)) && (($timer(shutdown)) || ($timer(shutdown2))) {

    did -a shutdown 5 $gettok(%sddate,1,47) | did -a shutdown 6 $gettok(%sddate,2,47) | did -a shutdown 7 $gettok(%sddate,3,47) | did -a shutdown 11 $gettok(%sdtime,1,58) | did -a shutdown 12 $gettok(%sdtime,2,58) | did -c shutdown 14 %sdtype

    if (%sdforce == 1) {

      did -c shutdown 15

    }

    did -b shutdown 5-7,11,12,14-16 | did -f shutdown 17

    sdcd | .timersdcd -o 0 1 sdcd

  }

  else {

    did -a shutdown 5 $date(dd) | did -a shutdown 6 $date(mm) | did -a shutdown 7 $date(yyyy) | did -a shutdown 11 $date(HH) | did -a shutdown 12 $date(nn) | did -b shutdown 17 | did -a shutdown 18 No shutdown scheduled

  }

}

on *:dialog:shutdown:sclick:16: {

  if ($did(5) !isnum) || ($did(6) !isnum) || ($did(7) !isnum) || ($did(11) !isnum) || ($did(12) !isnum) || ($did(5) > 31) || ($did(6) > 12) || ($did(11) > 23) || ($did(12) > 59) || ($len($did(7)) == 1) || ($len($did(7)) == 3) || ($len($did(12)) != 2) {

    if $input(An invalid date format was entered. $crlf Please check all fields and try again.,ouw,Error) {

    }

    halt

  }

  else {

    set -e %sddate $did(5) $+ / $+ $did(6) $+ / $+ $did(7) | set -e %sdtime $did(11) $+ : $+ $did(12)

    set -e %sddate $asctime($ctime(%sddate),dd/mm/yyyy) | set -e %sdtime $asctime($ctime(%sddate %sdtime),HH:nn)

    if (+ isin %sddate) || (- isin %sddate) || (+ isin %sdtime) || (- isin %sdtime) || (!$ctime(%sddate %sdtime)) {

      unset %sddate | unset %sdtime

      if $input(An invalid date format was entered. $crlf Please check all fields and try again.,ouw,Error) {

      }

      halt

    }

    elseif ( $ctime(%sddate %sdtime) < $ctime($date $time(HH:nn)) ) {

      unset %sddate | unset %sdtime

      if $input(Time preset is over. Please set to a later time.,ouw,Error) {

      }

      halt

    }

    else {

      set -e %sdtype $did(14).sel

      if ($did(15).state == 1) {

        set -e %sdforce 1

      }

      .timershutdown -o %sdtime 1 0 sdcheck

      echo $color(info) -es * Shutdown timer activated. $did(14) scheduled on %sddate at %sdtime $+ .

    }

  }

}

on *:dialog:shutdown:sclick:17: {

  did -e shutdown 5-7,11,12,14-16 | did -f shutdown 5 | did -b shutdown 17 | did -ar shutdown 18 No shutdown scheduled

  unset %sddate | unset %sdtime | unset %sdforce | unset %sdtype

  .timersdcd off | .timershutdown off | .timershutdown2 off

  echo $color(info) -es * Shutdown timer deactivated.

}

on *:dialog:shutdown:close:0: {

  .timersdcd off

}

alias -l sdcd {

  did -ar shutdown 18 $replace(%sdtype,1,Shutting down,2,Restarting,3,Logging off) in [ $duration($calc($ctime(%sddate %sdtime) - $ctime($date))) ]

}

alias -l sdcheck {

  if ((%sddate != $null) && (%sdtime != $null)) && (($timer(shutdown)) || ($timer(shutdown2))) {

    if (%sddate == $date) && (%sdtime == $time(HH:nn)) {

      echo $color(info) -es * $replace(%sdtype,1,Shutting down,2,Restarting,3,Logging off) Windows...

      run shutdown.exe $replace(%sdforce,1,-f) $replace(%sdtype,1,-s,2,-r,3,-l) -t 0

    }

    else {

      .timershutdown2 -o 1 60 .timershutdown -o %sdtime 1 0 sdcheck

    }

  }

}

alias shutdown {

  if (!$dialog(shutdown)) {

    dialog -m shutdown sd

  }

  dialog -rv shutdown sd

}

menu menubar,status {

  &Shutdown Windows (/shutdown):/shutdown

}

