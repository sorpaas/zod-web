::  Serialize &elem as &json, with special handling for urb:* attributes
::
::::  /hoon/elem-to-react-json/lib
  ::
/?    310
|%
++  react-attrs                                         ::  uppercase mapping
  ~+  ^-  (map term cord)
  %-  molt  ^-  (list (pair term cord))  
  :-  [%class 'className']
  =-  (rash - (more next (cook |=(a/tape [(crip (cass a)) (crip a)]) (star alf))))
  '''
  accept acceptCharset accessKey action allowFullScreen allowTransparency alt
  async autoComplete autoFocus autoPlay cellPadding cellSpacing charSet checked
  classID className colSpan cols content contentEditable contextMenu controls
  coords crossOrigin data dateTime defer dir disabled download draggable encType
  form formAction formEncType formMethod formNoValidate formTarget frameBorder
  headers height hidden high href hrefLang htmlFor httpEquiv icon id label lang
  list loop low manifest marginHeight marginWidth max maxLength media mediaGroup
  method min multiple muted name noValidate open optimum pattern placeholder
  poster preload radioGroup readOnly rel required role rowSpan rows sandbox 
  scope scoped scrolling seamless selected shape size sizes span spellCheck 
  src srcDoc srcSet start step style tabIndex target title type useMap value 
  width wmode
  '''
::
::  special handling for <pre urb:codemirror>foo</pre>
++  urb-codemirror                                      ::  render code blocks
  |=  src/manx  ^-  manx
  ?>  ?=({{$pre *} _;/(**) $~} src)
  ;codemirror(value "{v.i.a.g.i.c.src}");
::
::  special handling for <pre urb:exec>foo</pre>
++  urb-exec                                            ::  eval inline hoon
  |=  src/manx
  ?>  ?=({{$pre *} _;/(**) $~} src)      ::  verify it's only a text node
  =*  code  v.i.a.g.i.c.src
  =+  =<  result=(mule .)
      !.(|.((slap !>(.) (ream (crip code)))))     ::  compile and run safely
  =+  claz=?-(-.result $& "rancode", $| "failedcode")
  ;div(class "{claz}")
    ;pre:"{code}"
    ;+  ?-  -.result
          $&  ;code:"{~(ram re (sell p.result))}"
          $|  ;pre
                ;div:"error"
                ;*  %+  turn  p.result
                    |=  a/tank
                    ^-  manx
                    ;div:"{~(ram re a)}"
  ==    ==    ==
::
++  elem-to-react-json                                  ::  serialize DOM as json
  |=  src/manx  ^-  json
  ?:  ?=(_;/(**) src)
    (jape v.i.a.g.src)
  =+  atr=(molt `(list (pair mane tape))`a.g.src)  
  ?:  (~(has by atr) [%urb %codemirror])
    $(src (urb-codemirror src))
  ?:  (~(has by atr) [%urb %exec])           ::  runnable code attribute tag
    $(src (urb-exec src))
  %-  jobe  :~
    c+a+(turn c.src ..$)
    gn+s+(mane-to-cord n.g.src)
    =<  ga+(jobe (turn a.g.src .))
    |=  {a/mane b/tape}  ^-  {cord json}
    :_  (jape b)
    ?^  a  (mane-to-cord a)
    (fall (~(get by react-attrs) a) a)
  ==
::
++  mane-to-cord                                        ::  namespaced xml names
  |=(a/mane `cord`?@(a a (rap 3 -.a ':' +.a ~)))
--
::
::::
  ::
elem-to-react-json                                      ::  export conversion gate
