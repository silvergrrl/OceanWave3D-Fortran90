!___________________________________________________________________________________________________
! Double precision complex error function
! Adapted from the Naval Surface Warfare Center Mathematics Library
! by Alan.Miller @ vic.cmis.csiro.au
! http://www.ozemail.com.au/~milleraj
! Adaptation made by Aleksandar Donev
!___________________________________________________________________________________________________
MODULE Error_Function
   USE Erf_Auxilliary 
   IMPLICIT NONE
   PRIVATE
   PUBLIC :: Erf, InvErf

   ! INTEGER, PARAMETER  :: dp = KIND(0.0D0)

   INTERFACE Erf
     MODULE PROCEDURE ErfReal_sp
     MODULE PROCEDURE ErfReal_dp
   END INTERFACE  

   INTERFACE InvErf
     MODULE PROCEDURE InvErfReal_sp
     MODULE PROCEDURE InvErfReal_dp
   END INTERFACE     
   
CONTAINS

FUNCTION ErfReal_sp(x) RESULT(fn_val)
!-----------------------------------------------------------------------
!             EVALUATION OF THE REAL ERROR FUNCTION
!-----------------------------------------------------------------------
REAL, INTENT(IN) :: x
REAL             :: fn_val

REAL :: a(5) = (/ .771058495001320E-04, -.133733772997339E-02,   &
                  .323076579225834E-01,  .479137145607681E-01,   &
                  .128379167095513E+00 /),   &
        b(3) = (/ .301048631703895E-02,  .538971687740286E-01,   &
                  .375795757275549E+00 /),   &
        p(8) = (/-1.36864857382717E-07,  5.64195517478974E-01, &
                  7.21175825088309E+00,  4.31622272220567E+01, &
                  1.52989285046940E+02,  3.39320816734344E+02, &
                  4.51918953711873E+02,  3.00459261020162E+02 /),  &
        q(8) = (/ 1.00000000000000E+00,  1.27827273196294E+01, &
                  7.70001529352295E+01,  2.77585444743988E+02, &
                  6.38980264465631E+02,  9.31354094850610E+02, &
                  7.90950925327898E+02,  3.00459260956983E+02 /),  &
        r(5) = (/ 2.10144126479064E+00,  2.62370141675169E+01, &
                  2.13688200555087E+01,  4.65807828718470E+00, &
                  2.82094791773523E-01 /),   &
        s(4) = (/ 9.41537750555460E+01,  1.87114811799590E+02, &
                  9.90191814623914E+01,  1.80124575948747E+01 /)
!-------------------------
REAL :: ax, bot, c = .564189583547756, t, top, x2
!-------------------------
ax = ABS(x)
IF (ax < 0.5) THEN
  t = x*x
  top = ((((a(1)*t + a(2))*t + a(3))*t + a(4))*t + a(5)) + 1.0
  bot = ((b(1)*t + b(2))*t + b(3))*t + 1.0
  fn_val = x*(top/bot)
  RETURN

ELSE IF (ax < 4.0_dp) THEN
  top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax  &
        + p(6))*ax + p(7))*ax + p(8)
  bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax  &
        + q(6))*ax + q(7))*ax + q(8)
  fn_val = 0.5 + (0.5 - EXP(-x*x)*top/bot)
  IF (x < 0.0_dp) fn_val = -fn_val
  RETURN

ELSE IF (ax < 5.8) THEN
  x2 = x*x
  t = 1.0/x2
  top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
  bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + 1.0
  fn_val = (c - top/(x2*bot)) / ax
  fn_val = 0.5 + (0.5 - EXP(-x2)*fn_val)
  IF (x < 0.0) fn_val = -fn_val
  RETURN

ELSE
  fn_val = SIGN(1.0,x)
END IF

RETURN
END FUNCTION ErfReal_sp

FUNCTION ErfReal_dp(x) RESULT(fn_val)
!-----------------------------------------------------------------------
!             EVALUATION OF THE REAL ERROR FUNCTION
! Based upon a Fortran 66 routine in the Naval Surface Warfare Center's
! Mathematics Library (1993 version).
! Adapted by Alan.Miller @ vic.cmis.csiro.au
!-----------------------------------------------------------------------
! IMPLICIT NONE
! INTEGER, PARAMETER :: dp = wp ! g77 does not support double precision SELECTED_REAL_KIND(14, 60)      ! `Double precision'

REAL (dp), INTENT(IN) :: x
REAL (dp)             :: fn_val

! Local variables

REAL (dp), PARAMETER :: c = .564189583547756_dp, one = 1.0_dp, half = 0.5_dp, &
                        zero = 0.0_dp
REAL (dp), PARAMETER ::  &
           a(5) = (/ .771058495001320D-04, -.133733772997339D-02, &
                     .323076579225834D-01,  .479137145607681D-01, &
                     .128379167095513D+00 /),  &
           b(3) = (/ .301048631703895D-02,  .538971687740286D-01,  &
                     .375795757275549D+00 /),  &
           p(8) = (/ -1.36864857382717D-07, 5.64195517478974D-01,  &
                      7.21175825088309D+00, 4.31622272220567D+01,  &
                      1.52989285046940D+02, 3.39320816734344D+02,  &
                      4.51918953711873D+02, 3.00459261020162D+02 /), &
           q(8) = (/  1.00000000000000D+00, 1.27827273196294D+01,  &
                      7.70001529352295D+01, 2.77585444743988D+02,  &
                      6.38980264465631D+02, 9.31354094850610D+02,  &
                      7.90950925327898D+02, 3.00459260956983D+02 /), &
           r(5) = (/  2.10144126479064D+00, 2.62370141675169D+01,  &
                      2.13688200555087D+01, 4.65807828718470D+00,  &
                      2.82094791773523D-01 /),  &
           s(4) = (/  9.41537750555460D+01, 1.87114811799590D+02,  &
                      9.90191814623914D+01, 1.80124575948747D+01 /)
REAL (dp) :: ax, bot, t, top, x2
!-------------------------
ax = ABS(x)

IF (ax <= half) THEN
  t = x*x
  top = ((((a(1)*t + a(2))*t + a(3))*t + a(4))*t + a(5)) + one
  bot = ((b(1)*t + b(2))*t + b(3))*t + one
  fn_val = x*(top/bot)
  RETURN
END IF

IF (ax <= 4.0_dp) THEN
  top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax  &
        + p(6))*ax + p(7))*ax + p(8)
  bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax  &
        + q(6))*ax + q(7))*ax + q(8)
  fn_val = half + (half - EXP(-x*x)*top/bot)
  IF (x < zero) fn_val = -fn_val
  RETURN
END IF

IF (ax < 5.8_dp) THEN
  x2 = x*x
  t = one / x2
  top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
  bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + one
  fn_val = (c - top/(x2*bot)) / ax
  fn_val = half + (half - EXP(-x2)*fn_val)
  IF (x < zero) fn_val = -fn_val
  RETURN
END IF

fn_val = SIGN(one, x)
RETURN
END FUNCTION ErfReal_dp

FUNCTION InvErfReal_sp(p) RESULT(fn_val)
!-----------------------------------------------------------------------

!              EVALUATION OF THE INVERSE ERROR FUNCTION

!                        ---------------

!     FOR 0 <= P < 1,  W = ERFI(P,Q) WHERE ERF(W) = P. IT IS
!     ASSUMED THAT Q = 1 - P.  IF P < 0, Q <= 0, OR P + Q IS
!     NOT 1, THEN ERFI(P,Q) IS SET TO A NEGATIVE VALUE.

!-----------------------------------------------------------------------
!     REFERENCE. MATHEMATICS OF COMPUTATION,OCT.1976,PP.827-830.
!                  J.M.BLAIR,C.A.EDWARDS,J.H.JOHNSON
!-----------------------------------------------------------------------
REAL, INTENT(IN) :: p
REAL             :: fn_val

! Local variables
REAL :: q
REAL, PARAMETER :: a(6) = (/ .1400216916161353E+03, -.7204275515686407E+03,  &
                             .1296708621660511E+04, -.9697932901514031E+03,  &
                             .2762427049269425E+03, -.2012940180552054E+02 /),  &
                   b(6) = (/ .1291046303114685E+03, -.7312308064260973E+03,  &
                             .1494970492915789E+04, -.1337793793683419E+04,  &
                             .5033747142783567E+03, -.6220205554529216E+02 /),  &
                 a1(7)  = (/ -.1690478046781745E+00, .3524374318100228E+0,  &
                             -.2698143370550352E+02, .9340783041018743E+02,  &
                             -.1455364428646732E+03, .8805852004723659E+02,  &
                             -.1349018591231947E+02 /),  &
                  b1(7) = (/ -.1203221171313429E+00, .2684812231556632E+00,  &
                             -.2242485268704865E+02, .8723495028643494E+02,  &
                             -.1604352408444319E+03, .1259117982101525E+03,  &
                             -.3184861786248824E+02 /),   &
                  a2(9) = (/ .3100808562552958E-04, .4097487603011940E-02,  &
                             .1214902662897276E+00, .1109167694639028E+01,  &
                             .3228379855663924E+01, .2881691815651599E+01,  &
                             .2047972087262996E+01, .8545922081972148E+00,  &
                             .3551095884622383E-02 /),   &
                  b2(8) = (/ .3100809298564522E-04, .4097528678663915E-02,  &
                             .1215907800748757E+00, .1118627167631696E+01,  &
                             .3432363984305290E+01, .4140284677116202E+01,  &
                             .4119797271272204E+01, .2162961962641435E+01 /), &
                  a3(9) = (/ .3205405422062050E-08, .1899479322632128E-05,  &
                             .2814223189858532E-03, .1370504879067817E-01,  &
                             .2268143542005976E+00, .1098421959892340E+01,  &
                             .6791143397056208E+00, -.834334189167721E+00,  &
                             .3421951267240343E+00 /),   &
                  b3(6) = (/ .3205405053282398E-08, .1899480592260143E-05,  &
                             .2814349691098940E-03, .1371092249602266E-01,  &
                             .2275172815174473E+00, .1125348514036959E+01 /), &
                      c = .5625, c1 = .87890625, c2 = -.2302585092994046E+03
REAL :: eps, s, t, v, v1
!-----------------------------------------------------------------------
!     C2 = LN(1.E-100)
!-----------------------------------------------------------------------
IF (p >= 0.0 ) THEN
  q=1.0-p 
  eps = MAX(EPSILON(1.0), 1.e-15)
  
!                      0 <= P <= 0.75

  IF (p <= 0.75) THEN
    v = p * p - c
    t = p * (((((a(6)*v + a(5))*v + a(4))*v + a(3))*v + a(2))*v + a(1))
    s = (((((v + b(6))*v + b(5))*v + b(4))*v + b(3))*v + b(2)) * v + b(1)
  ELSE

!                    0.75 < P <= 0.9375

    IF (p <= 0.9375) THEN
      v = p * p - c1
      t = p * ((((((a1(7)*v + a1(6))*v + a1(5))*v + a1(4))*v + a1(3))*v + a1(2))*v + a1(1))
      s = ((((((v + b1(7))*v + b1(6))*v + b1(5))*v + b1(4))*v + b1(3))*v +  &
          b1(2)) * v + b1(1)
    ELSE

!                  1.E-100 <= Q < 0.0625

      v1 = LOG(q)
      v = 1.0 / SQRT(-v1)
      IF (v1 >= c2) THEN
        t = (((((((a2(9)*v + a2(8))*v + a2(7))*v + a2(6))*v + a2(5))*v +  &
            a2(4))*v + a2(3))*v + a2(2)) * v + a2(1)
        s = v * ((((((((v + b2(8))*v + b2(7))*v + b2(6))*v + b2(5))*v +  &
            b2(4))*v + b2(3))*v + b2(2))*v + b2(1))
      ELSE

!                 1.E-10000 <= Q < 1.E-100

        t = (((((((a3(9)*v + a3(8))*v + a3(7))*v + a3(6))*v + a3(5))*v +  &
            a3(4))*v + a3(3))*v + a3(2)) * v + a3(1)
        s = v * ((((((v + b3(6))*v + b3(5))*v + b3(4))*v + b3(3))*v +  &
                b3(2))*v + b3(1))
      END IF
    END IF
  END IF
  fn_val = t / s
  RETURN
END IF

!                         ERROR RETURN

fn_val = -1.0
RETURN

END FUNCTION InvErfReal_sp



FUNCTION InvErfReal_dp(p) RESULT(fn_val)
!-----------------------------------------------------------------------
REAL (dp), INTENT(IN) :: p
REAL (dp)             :: fn_val

!                  REAL (dp) COMPUTATION OF
!                    THE INVERSE ERROR FUNCTION

!                         ----------------

!     FOR 0 <= P <= 1,  W = DERFI(P,Q) WHERE ERF(W) = P. IT
!     IS ASSUMED THAT Q = 1 - P. IF P < 0, Q <= 0, OR P + Q
!     IS NOT 1, THEN DERFI(P,Q) IS SET TO A NEGATIVE VALUE.

!-----------------------------------------------------------------------
!     REFERENCE. MATHEMATICS OF COMPUTATION,OCT.1976,PP.827-830.
!                  J.M.BLAIR,C.A.EDWARDS,J.H.JOHNSON
!-----------------------------------------------------------------------
REAL (dp) :: q
REAL (dp) :: c = .5625_dp, c1 = .87890625_dp, c2  &
        = -.2302585092994045684017991454684364D+03, r  &
        = .8862269254527580136490837416705726D+00, eps, f, lnq, s, t, x
REAL (dp) :: a(7) = (/ .841467547194693616D-01,  &
        .160499904248262200D+01, .809451641478547505D+01,  &
        .164273396973002581D+02, .154297507839223692D+02,  &
        .669584134660994039D+01, .108455979679682472D+01 /), a1(7)  &
        = (/ .552755110179178015D+2, .657347545992519152D+3,  &
        .124276851197202733D+4, .818859792456464820D+3,  &
        .234425632359410093D+3, .299942187305427917D+2,  &
        .140496035731853946D+1 /), a2(7) = (/ .500926197430588206D+1,  &
        .111349802614499199D+3, .353872732756132161D+3,  &
        .356000407341490731D+3, .143264457509959760D+3,  &
        .240823237485307567D+2, .140496035273226366D+1 /), a3(11)  &
        = (/ .237121026548776092D4, .732899958728969905D6,  &
        .182063754893444775D7, .269191299062422172D7, .304817224671614253D7  &
       , .130643103351072345D7, .296799076241952125D6,  &
        .457006532030955554D5, .373449801680687213D4, .118062255483596543D3  &
       , .100000329157954960D1 /), a4(9) = (/ .154269429680540807D12,  &
        .430207405012067454D12, .182623446525965017D12,  &
        .248740194409838713D11, .133506080294978121D10,  &
        .302446226073105850D08, .285909602878724425D06,  &
        .101789226017835707D04, .100000004821118676D01 /),  &
        b(7) = (/ .352281538790042405D-02, .293409069065309557D+00,  &
        .326709873508963100D+01, .123611641257633210D+02,  &
        .207984023857547070D+02, .170791197367677668D+02,  &
        .669253523595376683D+01 /), b1(6) = (/ .179209835890172156D+3,  &
        .991315839349539886D+3, .138271033653003487D+4, .764020340925985926D+3,  &
        .194354053300991923D+3, .228139510050586581D+2 /),  &
        b2(6) = (/ .209004294324106981D+2, .198607335199741185D+3,  &
        .439311287748524270D+3, .355415991280861051D+3, .123303672628828521D+3,  &
        .186060775181898848D+2 /), b3(10) = (/ .851911109952055378D6,  &
        .194746720192729966D7, .373640079258593694D7, .397271370110424145D7,  &
        .339457682064283712D7 , .136888294898155938D7, .303357770911491406D6,  &
        .459721480357533823D5, .373762573565814355D4, .118064334590001264D3 /),  &
        b4(9) = (/ .220533001293836387D12, .347822938010402687D12,  &
        .468373326975152250D12, .185251723580351631D12,  &
        .249464490520921771D11, .133587491840784926D10,  &
        .302480682561295591D08, .285913799407861384D06,  &
        .101789250893050230D04 /)
!-----------------------------------------------------------------------
!     C2 = LN(1.E-100)
!     R  = SQRT(PI)/2
!-----------------------------------------------------------------------
IF (p >= 0._dp ) THEN
  eps = EPSILON(1.0_dp)
  q=1.0_dp-p 

!                      0 <= P <= 0.75

  IF (p <= 0.75_dp) THEN
    x = c - p * p
    s = (((((a(1)*x+a(2))*x+a(3))*x+a(4))*x+a(5))*x+a(6)) * x +a(7)
    t = ((((((b(1)*x+b(2))*x+b(3))*x+b(4))*x+b(5))*x+b(6))*x+b(7)) * x + 1._dp
    fn_val = p * (s/t)
    IF (eps > 1.d-19) RETURN

    x = fn_val
    f = Erf(x) - p
    fn_val = x - r * EXP(x*x) * f
    RETURN
  END IF

!                    0.75 < P <= 0.9375

  IF (p <= 0.9375_dp) THEN
    x = c1 - p * p
    IF (x <= 0.1_dp) THEN
      s = ((((((a1(1)*x+a1(2))*x+a1(3))*x+a1(4))*x+a1(5))*x+a1(6))*x+a1(7))
      t = ((((((b1(1)*x+b1(2))*x+b1(3))*x+b1(4))*x+b1(5))*x+b1(6))*x+1._dp)
    ELSE

      s = ((((((a2(1)*x+a2(2))*x+a2(3))*x+a2(4))*x+a2(5))*x+a2(6))*x+a2(7))
      t = ((((((b2(1)*x+b2(2))*x+b2(3))*x+b2(4))*x+b2(5))*x+b2(6))*x+1._dp)
    END IF

    fn_val = p * (s/t)
    IF (eps > 1.d-19) RETURN

    x = fn_val
    t = derfc1(1,x) - EXP(x*x) * q
    fn_val = x + r * t
    RETURN
  END IF

!                  1.E-100 <= Q < 0.0625

  lnq = LOG(q)
  x = 1._dp / SQRT(-lnq)
  IF (lnq >= c2) THEN
    s = (((((((((a3(1)*x+a3(2))*x+a3(3))*x+a3(4))*x+a3(5))*x+  &
    a3(6))*x+a3(7))*x+a3(8))*x+a3(9))*x+a3(10)) * x + a3(11)
    t = (((((((((b3(1)*x+b3(2))*x+b3(3))*x+b3(4))*x+b3(5))*x+  &
    b3(6))*x+b3(7))*x+b3(8))*x+b3(9))*x+b3(10)) * x + 1._dp
  ELSE

!                 1.E-10000 <= Q < 1.E-100

    s = (((((((a4(1)*x+a4(2))*x+a4(3))*x+a4(4))*x+a4(5))*x+a4(6))*  &
    x+a4(7))*x+a4(8)) * x + a4(9)
    t = ((((((((b4(1)*x+b4(2))*x+b4(3))*x+b4(4))*x+b4(5))*x+  &
    b4(6))*x+b4(7))*x+b4(8))*x+b4(9)) * x + 1._dp
  END IF

  fn_val = s / (x*t)
  IF (eps > 5.d-20) RETURN

  x = fn_val
  t = derfc1(1,x)
  f = (LOG(t)-lnq) - x * x
  fn_val = x + r * t * f
  RETURN
END IF

!                         ERROR RETURN

fn_val = -1._dp
RETURN

END FUNCTION InvErfReal_dp

END MODULE Error_Function
!