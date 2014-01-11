dialog -l rc {

  title Roman-Arabic No. Converter

  size -1 -1 95 103

  option dbu

  box Input, 1, 5 5 85 45

  text Input Romanic or Arabic Number (up to 3999):, 2, 16 15 65 15

  edit $date(yyyy), 3, 19 32 58 10

  box Output, 4, 5 55 85 30

  edit , 5, 19 67 58 10, read

  button &OK, 6, 35 89 25 10, ok

}

alias -l rc.find {

  did -r ranconv 5

  if ($did(3) == $null) {

    did -a ranconv 5 Please enter a value. | halt

  }

  if (($did(3) !isalpha) && ($did(3) !isnum)) {

    did -a ranconv 5 Error: Invalid input | halt

  }

  set %rc.tho 0 | set %rc.hun 0 | set %rc.ten 0 | set %rc.one 0

  if ($did(3) isalpha) {

    set %rc.ip $did(3) | set %rc.iplen $len($did(3))

    var %i = 1

    while (%i <= %rc.iplen) {

      if ($mid(%rc.ip,%i,1) == I) {

        if (%rc.one == 0) { set %rc.one 1 }

        elseif ((%rc.one == 1) && ($mid(%rc.ip,$calc(%i - 1),1) == I)) { set %rc.one 2 }

        elseif ((%rc.one == 2) && ($mid(%rc.ip,$calc(%i - 1),1) == I)) { set %rc.one 3 }

        elseif ((%rc.one == 5) && ($mid(%rc.ip,$calc(%i - 1),1) == V)) { set %rc.one 6 }

        elseif ((%rc.one == 6) && ($mid(%rc.ip,$calc(%i - 1),1) == I)) { set %rc.one 7 }

        elseif ((%rc.one == 7) && ($mid(%rc.ip,$calc(%i - 1),1) == I)) { set %rc.one 8 }

        elseif ((%rc.ten == 1) && ($mid(%rc.ip,$calc(%i - 1),1) == X)) { set %rc.one 1 }

        else { did -a ranconv 5 Error: Invalid input | halt }

      }

      elseif ($mid(%rc.ip,%i,1) == V) {

        if (%rc.one == 0) { set %rc.one 5 }

        elseif ((%rc.one == 1) && ($mid(%rc.ip,$calc(%i - 1),1) == I)) { set %rc.one 4 }

        else { did -a ranconv 5 Error: Invalid input | halt }

      }

      elseif ($mid(%rc.ip,%i,1) == X) {

        if ((%rc.ten == 0) && (%rc.one == 0)) { set %rc.ten 1 }

        elseif ((%rc.one == 1) && ($mid(%rc.ip,$calc(%i - 1),1) == I)) { set %rc.one 9 }

        elseif ((%rc.ten == 1) && (%rc.one == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == X)) { set %rc.ten 2 }

        elseif ((%rc.ten == 2) && (%rc.one == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == X)) { set %rc.ten 3 }

        elseif ((%rc.ten == 5) && ($mid(%rc.ip,$calc(%i - 1),1) == L)) { set %rc.ten 6 }

        elseif ((%rc.ten == 6) && (%rc.one == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == X)) { set %rc.ten 7 }

        elseif ((%rc.ten == 7) && (%rc.one == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == X)) { set %rc.ten 8 }

        elseif ((%rc.hun == 1) && (%rc.ten == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == C)) { set %rc.ten 1 }

        else { did -a ranconv 5 Error: Invalid input | halt }

      }

      elseif ($mid(%rc.ip,%i,1) == L) {

        if ((%rc.ten == 0) && (%rc.one == 0)) { set %rc.ten 5 }

        elseif ((%rc.ten == 1) && ($mid(%rc.ip,$calc(%i - 1),1) == X)) { set %rc.ten 4 }

        else { did -a ranconv 5 Error: Invalid input | halt }

      }

      elseif ($mid(%rc.ip,%i,1) == C) {

        if ((%rc.hun == 0) && (%rc.ten == 0) && (%rc.one == 0)) { set %rc.hun 1 }

        elseif ((%rc.ten == 1) && ($mid(%rc.ip,$calc(%i - 1),1) == X)) { set %rc.ten 9 }

        elseif ((%rc.hun == 1) && (%rc.ten == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == C)) { set %rc.hun 2 }

        elseif ((%rc.hun == 2) && (%rc.ten == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == C)) { set %rc.hun 3 }

        elseif ((%rc.hun == 5) && ($mid(%rc.ip,$calc(%i - 1),1) == D)) { set %rc.hun 6 }

        elseif ((%rc.hun == 6) && (%rc.ten == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == C)) { set %rc.hun 7 }

        elseif ((%rc.hun == 7) && (%rc.ten == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == C)) { set %rc.hun 8 }

        elseif ((%rc.tho == 1) && (%rc.hun == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == M)) { set %rc.hun 1 }

        else { did -a ranconv 5 Error: Invalid input | halt }

      }

      elseif ($mid(%rc.ip,%i,1) == D) {

        if ((%rc.hun == 0) && (%rc.ten == 0) && (%rc.one == 0)) { set %rc.hun 5 }

        elseif ((%rc.hun == 1) && ($mid(%rc.ip,$calc(%i - 1),1) == C)) { set %rc.hun 4 }

        else { did -a ranconv 5 Error: Invalid input | halt }

      }

      elseif ($mid(%rc.ip,%i,1) == M) {

        if ((%rc.tho == 0) && (%rc.hun == 0) && (%rc.ten == 0) && (%rc.one == 0)) { set %rc.tho 1 }

        elseif ((%rc.hun == 1) && ($mid(%rc.ip,$calc(%i - 1),1) == C)) { set %rc.hun 9 }

        elseif ((%rc.tho == 1) && (%rc.hun == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == M)) { set %rc.tho 2 }

        elseif ((%rc.tho == 2) && (%rc.hun == 0) && ($mid(%rc.ip,$calc(%i - 1),1) == M)) { set %rc.tho 3 }

        else { did -a ranconv 5 Error: Invalid input | halt }

      }

      else {

        did -a ranconv 5 Error: Invalid input | halt

      }

      inc %i

    }

  }

  if ($did(3) isnum) {

    if ((+ isin $did(3)) || (- isin $did(3)) || (. isin $did(3)) || ($did(3) >= 4000)) {

      did -a ranconv 5 Error: Invalid input | halt

    }

    if ($did(3) == 0) { 

      did -a ranconv 5 0 | halt

    }

    set %rc.ip $calc($did(3)) | set %rc.iplen $len($calc($did(3)))

    var %i = 1

    while (%i <= %rc.iplen) {

      set $replace(%i,1,% $+ rc.one,2,% $+ rc.ten,3,% $+ rc.hun,4,% $+ rc.tho) $left($right(%rc.ip,%i),1)

      inc %i

    }

    set %rc.tho $replace(%rc.tho,0,,1,M,2,MM,3,MMM)

    set %rc.hun $replace(%rc.hun,0,,1,C,2,CC,3,CCC,4,CD,5,D,6,DC,7,DCC,8,DCCC,9,CM)

    set %rc.ten $replace(%rc.ten,0,,1,X,2,XX,3,XXX,4,XL,5,L,6,LX,7,LXX,8,LXXX,9,XC)

    set %rc.one $replace(%rc.one,0,,1,I,2,II,3,III,4,IV,5,V,6,VI,7,VII,8,VIII,9,IX)

  }

  if (%rc.tho == 0) { unset %rc.tho }

  else { goto result }

  if (%rc.hun == 0) { unset %rc.hun }

  else { goto result }

  if (%rc.ten == 0) { unset %rc.ten }

  else { goto result }

  :result

  did -a ranconv 5 %rc.tho $+ %rc.hun $+ %rc.ten $+ %rc.one

}

on *:dialog:ranconv:init:0: {

  rc.find

}

on *:dialog:ranconv:edit:3: {

  rc.find

}

on *:dialog:ranconv:close:0: {

  unset %rc.*

}

alias ranconv {

  if (!$dialog(ranconv)) {

    dialog -m ranconv rc

  }

  dialog -rv ranconv rc

}

menu menubar,status {

  &Roman-Arabic No. Converter (/ranconv):/ranconv

}
