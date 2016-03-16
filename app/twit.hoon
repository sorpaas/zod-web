::  Twitter daemon
::
::::  /hook/core/twit/app
  ::
/+    twitter, talk
::
::::  ~fyr
  ::
|%
++  twit-path                                           ::  valid peer path
  $%  ::  {$home $~}                                         ::  home timeline
      {$user p/@t $~}                                    ::  user's tweets
      {$post p/@taxuv $~}                             ::  status of status
  ==
::
++  axle                                                ::  app state
  $:  $0
      out/(map @uvI (each {knot cord} stat))           ::  sent tweets
      ran/(map path {p/@ud q/@da})                     ::  polls active
      fed/(jar path stat)                               ::  feed cache
  ==
::
++  gift                                                ::  subscription action
  $%  {$quit $~}                                         ::  terminate
      {$diff gilt}                                      ::  send data
  ==
++  gilt  
  $%  {$twit-feed p/(list stat)}                        ::  posts in feed
      {$twit-stat p/stat}                               ::  tweet accepted
      {$ares term (list tank)}
  ==
::
++  move  {bone card}
++  card                                                ::  arvo request
  $?  gift
  $%  {$hiss wire (unit iden) api-call}                 ::  api request
      {$poke wire dock $talk-command command:talk}      ::
      {$wait wire p/@da}                                ::  timeout
  ==  ==
::
++  api-call  {response-mark $twit-req {endpoint quay}} :: full hiss payload
++  response-mark  ?($twit-status $twit-feed)           :: sigh options
++  sign                                                ::  arvo response
  $%  {$e $thou p/httr}                                 ::  HTTP result
      {$t $wake $~}                                      ::  timeout ping
  ==
::
::  XX =*
++  stat      stat:twitter                              ::  recieved tweet
++  command   command:twitter                           ::  incoming command
++  endpoint  endpoint:reqs:twitter                     ::  outgoing target
++  param  param:reqs:twitter                           ::  twit-req paramters
++  print  print:twitter                                ::  their serialization
++  parse  parse:twitter                                ::  and deserialization
::
:: ++  twit  args:reqs:twitter                             ::  arugment types
:: ++  twir  parse:twitter                                 ::  reparsers
:: ++  twip  print:twitter                                 ::  printers
--
!:
::::
  ::
|_  {bowl axle}
::
++  cull                                                ::  remove seen tweets
  |=  {pax/path rep/(list stat)}  ^+  rep
  =+  pev=(silt (turn (~(get ja fed) pax) |=(stat id)))
  (skip rep |=(stat (~(has in pev) id)))
::
++  done  [*(list move) .]
++  dely                                                ::  next polling timeout
  |=  pax/path
  ^-  {(unit time) _ran}
  =+  cur=(~(get by ran) pax)
  =+  tym=(add now (mul ~s8 (bex ?~(cur 0 p.u.cur))))
  :: ~&  dely/`@dr`(sub tym now)
  ?:  &(?=(^ cur) (gte tym q.u.cur) (gth q.u.cur now))
    [~ ran]
  [`tym (~(put by ran) pax ?~(cur 0 (min 5 +(p.u.cur))) tym)]
::
++  wait                                                ::  ensure poll by path
  |=  {pax/path mof/(list move)}  ^+  done
  =^  tym  ran  (dely pax)
  :_  +>.$
  ?~  tym  
    :: ~&  no-wait/ran
    mof
  :: ~&  will-wait/u.tym
  :-  [ost %wait pax u.tym]
  mof
::
++  poke-twit-do                                        ::  recieve request
  |=  {usr/knot act/command}  ^+  done
  ?-    -.act
      $post
    =:  out  (~(put by out) p.act %& usr q.act)
        ran  (~(del by ran) /peer/home)
      ==
    %+  wait  /peer/home
    =+  req=[%twit-req `endpoint`stat-upda+[%status q.act]~ ~]
    [ost %hiss post+(dray ~[%uv] p.act) `usr %twit-status req]~
  ==
::
++  wake-peer
  |=  {pax/path $~}  ^+  done
  ~&  twit-wake+peer+pax
  :_  +>.$
  ?.  (~(has by ran) peer+pax)                           ::  ignore if retracted
    ~
  =+  =>  |=({a/bone @ b/path} [b a])
      pus=(~(gas ju *(jug path bone)) (turn (~(tap by sup)) .))
  ?~  (~(get ju pus) pax)
    ~
  ~&  peer-again+[pax ran]
  (pear | `~. pax) ::(user-from-path pax))
::
::  XX parse from stack trace?
:: ++  sigh-429                          ::  Rate-limit
::   |=  {pax/path hit/httr}
::   =.  ran  (~(put by ran) pax 6 now)
::   =+  lim=%.(%x-rate-limit-reset ;~(biff ~(get by (mo q.hit)) poja ni:jo))
::   =+  tym=?~(lim (add ~m7.s30 now) (add ~1970.1.1 (mul ~s1 u.lim)))
::   ~&  retrying-in+`@dr`(sub tym now)
::   :_(+>.$ [ost %wait pax tym]~)
::
++  sigh-twit-status-post                               ::  post acknowledged
  |=  {wir/wire rep/stat}  ^+  done
  =+  (raid wir mez=%uv ~)
  =.  out  (~(put by out) mez %| rep)
  :_  +>.$
  =+  pax=/[who.rep]/status/(rsh 3 2 (scot %ui id.rep))
  :-  (show-url [& ~ &+/com/twitter] `pax ~)
  %+  weld  (spam pax (tweet-good rep))
  (spam scry+x+pax (tweet-good rep))
::
++  sigh-twit-feed                                      ::  feed data
  |=  {wir/wire rep/(list stat)}  ^+  done
  ?>  ?=({?($peer $scry) *} wir)
  =*  pax  t.wir
  :: ~&  got-feed+[(scag 5 (turn rep |=(stat id))) fed]
  =:  ran  (~(del by ran) wir)                    ::  clear poll delay
      fed  (~(put by fed) pax rep)              ::  saw last message
    ==
  ?:  ?=($scry -.wir)
    [(spam scry+x+pax [%diff twit-feed+(flop rep)] [%quit ~] ~) +>.$]
  =+  ren=(cull pax rep)                       ::  new messages
  ?~  ren
    (wait wir ~)                              ::  pump polling
  :: ~&  spam-feed+ren
  (wait wir (spam pax [%diff twit-feed+(flop ren)] ~))
::
++  sigh-tang                       ::  Err
  |=  {pax/path tan/tang}  ^+  done
  =+  ^-  git/gift
      =+  err='' ::%.(q:(need r.hit) ;~(biff poja mean:twir))  :: XX parse?
      :^  %diff  %ares  %bad-http
      tan
      :: [leaf/"HTTP Code {<p.hit>}" (turn (need err) mean:render:twit)]
  ?+    pax  [[ost git]~ +>.$]
    {$post @ $~}
      [(spam pax git ~) +>.$]
  ==
::
:: ++  user-to-path  |=(a/(unit iden) ?~(a '~' (scot %ta u.a)))
:: ++  user-from-path
::   |=  pax/path  ^-  {(unit iden) path}
::   ~|  %bad-user
::   ?~  pax  ~|(%empty-path !!)
::   ~|  i.pax
::   ?:  =('~' i.pax)  [~ t.pax]
::   [`(slav %ta i.pax) t.pax]
::
::
::  .^(twit-feed %gx /=twit=/~/user/urbit_test)
::  .^(twit-stat %gx /=twit=/~./post/0vv0old.0post.hash0.0000)
++  peek
  |=  {ren/care pax/path}  ^-  (unit (unit gilt))
  ?>  ?=($x ren)  ::  others unsupported
  =+  usr=`~.  ::   =^  usr  pax  (user-from-path pax)
  ?.  ?=(twit-path pax)
    ~|([%missed-path pax] !!)
  =+  gil=(pear-scry pax)
  ?-  -.gil
    $none  ~
    $part  ~      ::  stale data
    $full  ``p.gil
  ==
::
++  peer-scry-x
  |=  pax/path  ^+  done
  :_  +>
  =+  pek=(peek %x pax)
  ?^  pek
    ?~  u.pek  ~|(bad-scry+x+pax !!)
    ~[[ost %diff u.u.pek] [ost %quit ~]]
  =+  usr=`~.  ::   =^  usr  pax  (user-from-path pax)
  ?.  ?=(twit-path pax)
    ~|([%missed-path pax] !!)
  =+  hiz=(pear-hiss pax)
  ?~  hiz  ~                          :: already in flight
  [ost %hiss scry+pax usr u.hiz]~  
::
++  tweet-good  |=(rep/stat `(list gift)`~[[%diff %twit-stat rep] [%quit ~]]) 
++  peer  |=(pax/path :_(+> (pear & `~. pax)))       ::  accept subscription
++  pear                              ::  poll, possibly returning current data
  |=  {ver/? usr/(unit iden) pax/path}
  ^-  (list move)
  ?.  ?=(twit-path pax)
    ~|([%missed-path pax] !!)
  =+  gil=(pear-scry pax)
  %+  welp
    ^-  (list move)
    ?:  ?=($full -.gil)  ~       :: permanent result
    =+  hiz=(pear-hiss pax)
    ?~  hiz  ~
    [ost %hiss peer+pax usr u.hiz]~
  ^-  (list move)
  ?.  ver  ~
  ?-  -.gil
    $none  ~
    $part  [ost %diff p.gil]~
    $full  ~[[ost %diff p.gil] [ost %quit ~]]
  ==
::
++  pear-scry
  |=  pax/twit-path  ^-  $%({$none $~} {$part p/gilt} {$full p/gilt})
  ?-    -.pax
      $post
    =+  mez=(slav %uv p.pax)
    =+  (raid +.pax mez=%uv ~)
    =+  sta=(~(get by out) mez)
    ?.  ?=({$~ $| *} sta)
      [%none ~]
    [%full twit-stat+p.u.sta]
  ::
      $user  ::?($user $home)
    [%part twit-feed+(flop (~(get ja fed) pax))]
  ==
::
++  pear-hiss
  |=  pax/twit-path  ^-  (unit api-call)
  ?-    -.pax
      $post  ~                        :: future/unacked
      $user
    =+  ole=(~(get ja fed) pax)
    =+  opt=?~(ole ~ ['since_id' (tid:print id.i.ole)]~)
    `[%twit-feed twit-req+[stat-user+[(to-sd p.pax)]~ opt]]
  ::
::       $home
::     =+  ole=(~(get ja fed) pax)
::     =+  opt=?~(ole ~ ['since_id' (tid:print id.i.ole)]~)
::     `[%twit-feed stat-home+~ opt]
  ==
::
++  to-sd                                               ::  parse user name/numb
  |=  a/knot  ^-  sd:param
  ~|  [%not-user a]
  %+  rash  a
  ;~(pose (stag %user-id dem) (stag %screen-name user:parse))
::
:: ++  pull                                                ::  release subscription
::   |=  ost/bone
::   ?.  (~(has by sup) ost)  `+>.$      ::  XX should not occur
::   =+  [his pax]=(~(got by sup) ost)
::   ?:  (lth 1 ~(wyt in (~(get ju pus) pax)))
::     `+>.$
::   =:  ran  (~(del by ran) [%peer pax])
::       fed  (~(del by fed) pax)
::     ==
::   `+>.$
::
++  spam                                                ::  send by path
  |=  {a/path b/(list gift)}  ^-  (list move)
  %-  zing  ^-  (list (list move))
  %+  turn  (~(tap by sup))
  |=  {ost/bone @ pax/path}
  ?.  =(pax a)  ~
  (turn b |=(c/gift [ost c]))
::
++  show-url  ~(said-url talk `bowl`+<-)
--
