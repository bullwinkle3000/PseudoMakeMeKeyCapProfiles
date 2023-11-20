use <./libraries/scad-utils/morphology.scad> //for cheaper minwoski
use <./libraries/scad-utils/transformations.scad>
use <./libraries/scad-utils/shapes.scad>
use <./libraries/scad-utils/trajectory.scad>
use <./libraries/scad-utils/trajectory_path.scad>
use <./libraries/sweep.scad>
use <./libraries/skin.scad>

/*DES (Distorted Elliptical Saddle) Sculpted Profile
Version 2: Eliptical Rectangle
*/

//NOTE: with sweep cuts, top surface may not be visible in review, it should be visible once rendered
mirror([0,0,0])keycap(
    keyID  = 4, //change profile refer to KeyParameters Struct
    cutLen = 0, //Don't change. for chopped caps
    Stem   = true, //tusn on shell and stems
    Dish   = true, //turn on dish cut
    Stab   = 0,
    visualizeDish = true, // turn on debug visual of Dish
    crossSection  = false, // center cut to check internal
    homeDot = false, //turn on homedots
    Legends = true,
    text = "A",
    font = "American Typewriter:style=regular",
    textRotate = 0,
    textSize = 5
);

//Parameters
wallthickness = 1.5;
topthickness  = 3;   //
stepsize      = 50;  //resolution of Trajectory
step          = 0.5;   //resolution of ellipes
fn            = 60;  //resolution of Rounded Rectangles: 60 for output
layers        = 50;  //resolution of vertical Sweep: 50 for output
dotRadius     = 1.25;   //home dot size

// roll for trajectories
fr1 = 0;
fr2 = 0;
br1 = 0;
br2 = 0;

//---Stem param
Tol    = 0.00; //stem tolarance
stemRot = 0;
stemRad = 5.55; // stem outer radius
stemLen = 5.55 ;
stemCrossHeight = 4;
extra_vertical  = 0.6;
StemBrimDep     = 0.25;
stemLayers      = 50; //resolution of stem to cap top transition

keyParameters = //keyParameters[KeyID][ParameterID]
[
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft  XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
//normie hipro v1 0~3
    [17.16,  17.16,   6.5, 	 6.5, 11.5,    0,    0,    -3,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
    [35.46,  17.16,   6.5, 	 6.5, 11.0,    0,    0,   -10,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 2u
    [17.16,  17.16,   6.5, 	 6.5,    9,    0,    0,     3,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R3 Home
    [35.56,   6.5, 	 6.5,  8.6,    0,    0,    -8,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 2u low pro 3
//normie hi-sculpt 4 row system  4~15
    [KeyWidth(1.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5  4
    [KeyWidth(1.25),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 1.25u
    [KeyWidth(1.50),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 1.5u
    [KeyWidth(1.75),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 1.75u
    [KeyWidth(2.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 2.0u
    [KeyWidth(2.25),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 2.25u
    [KeyWidth(2.75),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 2.75u
    [KeyWidth(3.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 3.00u
    [KeyWidth(4.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 4.00u
    [KeyWidth(6.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 4.00u
    [KeyWidth(6.25),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 4.00u
    [KeyWidth(7.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 4.00u
//normie  mild  4 row system 16~20
    [17.16,  17.16,    6.5, 	 6.5, 10.3,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
    [22.26,  17.16,    6.5, 	 6.5, 10.3,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
    [26.66,  17.16,    6.5, 	 6.5, 10.3,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
    [31.06,  17.16,    6.5, 	 6.5, 10.3,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
    [35.56,  17.16,    6.5, 	 6.5, 10.3,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
//nueron R5s 21~24
    [35.46,  17.96,    6.5,    6.5, 10.5,    0,    0,    -5,     0,     0,   2,   2,      1,      5,      1,      5,     2,       2], //R5  2u
    [26.66,  17.16,    6.5, 	 6.5, 10.5,    0,    0,    -3,     0,     0,   2,   2,      1,      5,      1,      5,     2,       2], //R5 1.5u
    [40.66,  17.16,    6.5, 	 6.5, 10.5,    0,    0,    -3,     0,     0,   2,   2,      1,      5,      1,      5,     2,       2], //R5 2.25u
    [49.86,  17.16,    6.5, 	 6.5, 10.5,    0,    0,    -3,     0,     0,   2,   2,      1,      5,      1,      5,     2,       2], //R5 2.75u
];

dishParameters = //dishParameter[keyID][ParameterID]
[
//FFwd1 FFwd2 FPit1 FPit2  DshDepi DishDepf,DshHDif FArcIn FArcFn FArcEx     BFwd1 BFwd2 BPit1 BPit2  BArcIn BArcFn BArcEx
  [   4,    4,  -10,  -20,      3,      7,   8.2,     9,     2,        4,    9,    3,   15,    8.2,     9,     2], //R5
  [   4,  3.5,  -13,  -50,      2,    4.5,  18.2,  17.5,     2,       4.5,  2.5,   -5,  -50,   18.2,    17,     2], //R5 2u
  [   3,    3,  -10,  -50,      3,      7,   8.8,     9,     2,        4,    3,   -5,  -30,    8.8,     9,     2],  //R3
  [   3, 3.25,  -10,  -45,      2,    4.3,  18.2,    21,     2,        5,    3,  -10,  -30,   18.2,    21,     2], //R4
//normie hi-sculpt 4 row system  17~24
  [   4,    3,  -10,  -20,    1.5,      4,   8.2,    9.0,     2,        4,    3,  -10,  -30,    8.2,    9.0,      2], //R5
  [   4,    3,  -10,  -20,    1.5,      4,  10.6,   11.4,     2,        4,    3,  -10,  -30,   10.6,   11.4,      2],//R5 1.25u
  [   4,    3,  -10,  -20,    1.5,      4,  13.0,   13.8,     2,        4,    3,  -10,  -30,   13.0,   13.8,      2], //R5 1.5u
  [   4,    3,  -10,  -20,    1.5,      4,  15.4,   16.1,     2,        4,    3,  -10,  -30,   15.4,   16.1,      2], //R5 1.75u
  [   4,    3,  -10,  -20,    1.5,      4,  17.7,   18.5,     2,        4,    3,  -10,  -30,   17.7,   18.5,      2], //R5 2.0u
  [   4,    3,  -10,  -20,    1.5,      4,  20.1,   20.9,     2,        4,    3,  -10,  -30,   20.1,   20.9,      2], //R5 2.25u
  [   4,    3,  -10,  -20,    1.5,      4,  24.9,   27.7,     2,        4,    3,  -10,  -30,   24.9,   27.7,      2], //R5 2.75u
  [   4,    3,  -10,  -20,    1.5,      4,  27.3,   28.1,     2,        4,    3,  -10,  -30,   27.3,   28.1,      2], //R5 3.00u
  [   4,    3,  -10,  -20,    1.5,      4,  36.8,   37.6,     2,        4,    3,  -10,  -30,   36.8,   37.6,      2], //R5 4.00u
  [   4,    3,  -10,  -20,    1.5,      4,  55.8,   56.6,     2,        4,    3,  -10,  -30,   55.8,   56.6,      2], //R5 6.00u
  [   4,    3,  -10,  -20,    1.5,      4,  58.2,   60.0,     2,        4,    3,  -10,  -30,   58.2,   60.0,      2], //R5 6.25u
  [   4,    3,  -10,  -20,    1.5,      4,  65.4,   66.2,     2,        4,    3,  -10,  -30,   65.4,   66.2,      2], //R5 7.00u
//normie hi-sculpt 4 row system  17~24
  [   4,    3,  -10,  -20,    1.5,      4,   8.2,     9,     2,        4,    3,  -10,  -30,    8.2,     9,     2], //R5
  [   4,    3,  -10,  -20,    1.5,      4,  10.2,    11,     2,        4,    3,  -10,  -30,   10.2,    11,     2],//R5 1.25u
  [   4,    3,  -10,  -20,    1.5,      4,  12.4,    13,     2,        4,    3,  -10,  -30,   12.4,    13,     2], //R5 1.5u
  [   4,    3,  -10,  -20,    1.5,      4,  14.6,    15,     2,        4,    3,  -10,  -30,   14.6,    15,     2], //R5 1.75u
  [   4,    3,  -10,  -20,    1.5,      4,  16.8,    17,     2,        4,    3,  -10,  -30,   16.8,    17,     2], //R5 2.0u
//
  [   4,    3,  -10,  -20,    1.8,    4.5,  17.5,    19,     2,        4,   10,    3,   15,   17.5,    19,     2], //R5
  [   4,    3,  -10,  -20,    1.5,      4,  11.8,    12,     2,        4,    3,  -10,  -30,   11.8,    12,     2], //R5 1.5u
  [   4,    3,  -10,  -20,    1.5,      4,  18.8,  18.8,     2,        4,    3,  -10,  -30,   18.8,  18.8,     2], //R5 2.25u
  [   4,    3,  -10,  -20,    1.5,      4,  23.5,    24,     2,        4,    3,  -10,  -30,   23.5,    24,     2], //R5 2.75u
];

function FrontForward1(keyID) = dishParameters[keyID][0];  //
function FrontForward2(keyID) = dishParameters[keyID][1];  //
function FrontPitch1(keyID)   = dishParameters[keyID][2];  //
function FrontPitch2(keyID)   = dishParameters[keyID][3];  //
function DishDepth(keyID)     = dishParameters[keyID][4];  //
function DishHeightDif(keyID) = dishParameters[keyID][5];  //
function FrontInitArc(keyID)  = dishParameters[keyID][6];
function FrontFinArc(keyID)   = dishParameters[keyID][7];
function FrontArcExpo(keyID)  = dishParameters[keyID][8];
function BackForward1(keyID)  = dishParameters[keyID][9];  //
function BackForward2(keyID)  = dishParameters[keyID][10];  //
function BackPitch1(keyID)    = dishParameters[keyID][11];  //
function BackPitch2(keyID)    = dishParameters[keyID][12];  //
function BackInitArc(keyID)   = dishParameters[keyID][13];
function BackFinArc(keyID)    = dishParameters[keyID][14];
function BackArcExpo(keyID)   = dishParameters[keyID][15];

function BottomWidth(keyID)  = keyParameters[keyID][0];  //
function BottomLength(keyID) = keyParameters[keyID][1];  //
function TopWidthDiff(keyID) = keyParameters[keyID][2];  //
function TopLenDiff(keyID)   = keyParameters[keyID][3];  //
function KeyHeight(keyID)    = keyParameters[keyID][4];  //
function TopWidShift(keyID)  = keyParameters[keyID][5];
function TopLenShift(keyID)  = keyParameters[keyID][6];
function XAngleSkew(keyID)   = keyParameters[keyID][7];
function YAngleSkew(keyID)   = keyParameters[keyID][8];
function ZAngleSkew(keyID)   = keyParameters[keyID][9];
function WidExponent(keyID)  = keyParameters[keyID][10];
function LenExponent(keyID)  = keyParameters[keyID][11];
function CapRound0i(keyID)   = keyParameters[keyID][12];
function CapRound0f(keyID)   = keyParameters[keyID][13];
function CapRound1i(keyID)   = keyParameters[keyID][14];
function CapRound1f(keyID)   = keyParameters[keyID][15];
function ChamExponent(keyID) = keyParameters[keyID][16];
function StemExponent(keyID) = keyParameters[keyID][17];

function FrontTrajectory(keyID) =
  [
    trajectory(forward = FrontForward1(keyID), pitch =  FrontPitch1(keyID), roll = fr1), //more param available: yaw, roll, scale
    trajectory(forward = FrontForward2(keyID), pitch =  FrontPitch2(keyID), roll = fr2)  //You can add more traj if you wish
  ];

function BackTrajectory (keyID) =
  [
    trajectory(forward = BackForward1(keyID), pitch =  BackPitch1(keyID), roll = br1),
    trajectory(forward = BackForward2(keyID), pitch =  BackPitch2(keyID), roll = br2),
  ];

//------- function defining Dish Shapes

function ellipse(a, b, d = 0, rot1 = 0, rot2 = 360) = [for (t = [rot1:step:rot2]) [a*cos(t)+a, b*sin(t)*(1+d*cos(t))]]; //Centered at a apex to avoid inverted face

function DishShape (a,b,c,d) =
  concat(
   [[c+a,-b]],
    ellipse(a, b, d = 0,rot1 = 270, rot2 =450),
   [[c+a,b]]
  );

function oval_path(theta, phi, a, b, c, deform = 0) = [
 a*cos(theta)*cos(phi), //x
 c*sin(theta)*(1+deform*cos(theta)) , //
 b*sin(phi),
];

path_trans2 = [for (t=[0:step:180])   translation(oval_path(t,0,10,15,2,0))*rotation([0,90,0])];


//--------------Function definng Cap
function CapTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),   //X shift
    ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*KeyHeight(keyID))    //Z shift
  ];

function InnerTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),   //X shift
    ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*(KeyHeight(keyID)-topthickness))    //Z shift
  ];

function CapRotation(t, keyID) =
  [
    ((1-t)/layers*XAngleSkew(keyID)),   //X shift
    ((1-t)/layers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/layers*ZAngleSkew(keyID))    //Z shift
  ];

function CapTransform(t, keyID) =
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopWidthDiff(keyID)) + (1-pow(t/layers, WidExponent(keyID)))*BottomWidth(keyID) ,
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)) + (1-pow(t/layers, LenExponent(keyID)))*BottomLength(keyID)
  ];
function CapRoundness(t, keyID) =
  [
    pow(t/layers, ChamExponent(keyID))*(CapRound0f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound0i(keyID),
    pow(t/layers, ChamExponent(keyID))*(CapRound1f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound1i(keyID)
  ];

function CapRadius(t, keyID) = pow(t/layers, ChamExponent(keyID))*ChamfFinRad(keyID) + (1-pow(t/layers, ChamExponent(keyID)))*ChamfInitRad(keyID);

function InnerTransform(t, keyID) =
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/layers, WidExponent(keyID)))*(BottomWidth(keyID) -wallthickness*2),
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/layers, LenExponent(keyID)))*(BottomLength(keyID)-wallthickness*2)
  ];

function StemTranslation(t, keyID) =
  [
    ((1-t)/stemLayers*TopWidShift(keyID)),   //X shift
    ((1-t)/stemLayers*TopLenShift(keyID)),   //Y shift
    stemCrossHeight+.1+StemBrimDep + (t/stemLayers*(KeyHeight(keyID)- topthickness - stemCrossHeight-.1 -StemBrimDep))    //Z shift
  ];

function StemRotation(t, keyID) =
  [
    ((1-t)/stemLayers*XAngleSkew(keyID)),   //X shift
    ((1-t)/stemLayers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/stemLayers*ZAngleSkew(keyID))    //Z shift
  ];

function StemTransform(t, keyID) =
  [
    pow(t/stemLayers, StemExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemWid - 2*slop),
    pow(t/stemLayers, StemExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemLen - 2*slop)
  ];

function StemRadius(t, keyID) = pow(t/stemLayers,3)*3 + (1-pow(t/stemLayers, 3))*1;
  //Stem Exponent


///----- KEY Builder Module
module keycap(keyID = 0, cutLen = 0, visualizeDish = false, rossSection = false, Dish = true, Stem = false, homeDot = false, Legends = false, text = "A", font = "Arial:style=regular", textSize = 4, textRotate = 0, Stab = 0) {

  //Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  //Scaling initial and final dim tranformation by exponents
  function FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*FrontInitArc(keyID);
  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID);

  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShape(DishDepth(keyID), FrontDishArc(i), DishDepth(keyID)+2.5, d = 0)) ];
  BackCurve  = [ for(i=[0:len(BackPath)-1])  transform(BackPath[i],  DishShape(DishDepth(keyID),  BackDishArc(i), DishDepth(keyID)+2.5, d = 0)) ];

  //builds
  difference(){
    union(){
        difference(){
          skin([for (i=[0:layers-1]) transform(translation(CapTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle(CapTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]); //outer shell

          //Cut inner shell
          if(Stem == true){
            translate([0,0,-.001])skin([for (i=[0:layers-1]) transform(translation(InnerTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle(InnerTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]);
          }
        }

        if(Stem == true){
            StemLength = KeyHeight(keyID) - StemBrimDep;
            u = KeyUnit(BottomWidth(keyID));
            CherryStems(Unit = u, Length = StemLength, BrimDepth = StemBrimDep, Rotation = stemRot);
        }
    }

    if(Legends ==  true){
//          #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])
      rotate([0, 0, textRotate]) translate([0,0,KeyHeight(keyID)-3])linear_extrude(height =4) text( text = text, font = font, size = textSize, valign = "center", halign = "center" );
      //  #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,-3.5,0])linear_extrude(height = 0.5)text( text = "Me", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
      }
   //Dish Sh
   
   //Dish Shape
    if(Dish == true){
     if(visualizeDish == false){
      translate([-TopWidShift(keyID),.00001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
      translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
     } else {
      #translate([-TopWidShift(keyID),.00001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)]) rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
      #translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
     }
   }

    if(crossSection == true) {
       translate([0,-15,-.1])cube([15,30,15]);
     }

     //Homing dot
     if(homeDot == true)translate([0,0,KeyHeight(keyID)-DishHeightDif(keyID)-.25])sphere(d = dotRadius);
  }
}

//------------------stems
module CherryStem(Length, BrimDepth, Rotation) {
    MXWid = 4.03/2+Tol; //horizontal lenght
    MXLen = 4.23/2+Tol; //vertical length

    MXWidT = 1.15/2+Tol; //horizontal thickness
    MXLenT = 1.25/2+Tol; //vertical thickness

    function stem_internal(sc=1) = sc*[
        [MXLenT, MXLen],[MXLenT, MXWidT],[MXWid, MXWidT],
        [MXWid, -MXWidT],[MXLenT, -MXWidT],[MXLenT, -MXLen],
        [-MXLenT, -MXLen],[-MXLenT, -MXWidT],[-MXWid, -MXWidT],
        [-MXWid,MXWidT],[-MXLenT, MXWidT],[-MXLenT, MXLen]
    ];  //2D stem cross with tolance offset and additonal transformation via jog

    function StemTrajectory() = [
        trajectory(forward = 5.25)  //You can add more traj if you wish
    ];

    function StemTrajectory2() = [
        trajectory(forward = .5)  //You can add more traj if you wish
    ];

    StemPath  = quantize_trajectories(StemTrajectory(),  steps = 1 , loop=false, start_position= $t*4);
    StemCurve  = [ for(i=[0:len(StemPath)-1])  transform(StemPath[i],  stem_internal()) ];
    StemPath2  = quantize_trajectories(StemTrajectory2(),  steps = 10, loop=false, start_position= $t*4);
    StemCurve2  = [ for(i=[0:len(StemPath2)-1])  transform(StemPath2[i]*scaling([(1.1-.1*i/(len(StemPath2)-1)),(1.1-.1*i/(len(StemPath2)-1)),1]),  stem_internal()) ];

    translate([0, 0, BrimDepth])
    rotate(Rotation)
    difference() {
        cylinder(d =5.5, Length, $fn= 32);
        skin(StemCurve);
        skin(StemCurve2);
    }
}

module CherryStems(Unit, Length, BrimDepth, Rotation) {
    length = keyHeight - stemDepth;

    union() {
        CherryStem(Length, BrimDepth, Rotation);

        if (Unit >= 2 && Unit < 3) {
            spacing = 1.25 * 19.05;
            translate([spacing / 2, 0, 0]) CherryStem(Length, BrimDepth, Rotation);
            translate([-spacing / 2, 0, 0]) CherryStem(Length, BrimDepth, Rotation);
        }

        if (Unit >= 3)  {
            spacing = (Unit - 1) * 19.05;
            translate([spacing / 2, 0, 0]) CherryStem(Length, BrimDepth, Rotation);
            translate([-spacing / 2, 0, 0]) CherryStem(Length, BrimDepth, Rotation);
        }
    }
}

//module cherry_stem(depth, slop) {
//  D1=.15;
//  D2=.05;
//  H1=3.5;
//
//  CrossDist = 1.75;
//  difference(){
//    // outside shape
//    linear_extrude(height = depth) {
//      offset(r=1){
//        square(outer_cherry_stem(slop) - [2,2], center=true);
//      }
//    }
//    inside_cherry_cross(slop);
//    hull(){
//      translate([CrossDist,CrossDist-.1,0])cylinder(d1=D1, d2=D2, H1);
//      translate([-CrossDist,-CrossDist+.1,0])cylinder(d1=D1, d2=D2, H1);
//    }
//    hull(){
//      translate([-CrossDist,CrossDist-.1])cylinder(d1=D1, d2=D2, H1);
//      translate([CrossDist,-CrossDist+.1])cylinder(d1=D1, d2=D2, H1);
//    }
//  }
//}

module choc_stem() {

    translate([5.7/2,0,-3.4/2+2])difference(){
    cube([1.25,3, 3.4], center= true);
    translate([3.9,0,0])cylinder(d=7,3.4,center = true);
    translate([-3.9,0,0])cylinder(d=7,3.4,center = true);
  }
  translate([-5.7/2,0,-3.4/2+2])difference(){
    cube([1.25,3, 3.4], center= true);
    translate([3.9,0,0])cylinder(d=7,3.4,center = true);
    translate([-3.9,0,0])cylinder(d=7,3.4,center = true);
  }

}
/// ----- helper functions
function KeyWidth(u = 1) =
    let (clearance = 1.89)
    u * 19.05 - clearance;

function KeyUnit(width) =
    let (clearance = 1.89)
    (width + clearance) / 19.05;


function rounded_rectangle_profile(size=[1,1],r=1,fn=32) = [
	for (index = [0:fn-1])
		let(a = index/fn*360)
			r * [cos(a), sin(a)]
			+ sign_x(index, fn) * [size[0]/2-r,0]
			+ sign_y(index, fn) * [0,size[1]/2-r]
];

function elliptical_rectangle(a = [1,1], b =[1,1], fn=32) = [
    for (index = [0:fn-1]) // section right
     let(theta1 = -atan(a[1]/b[1])+ 2*atan(a[1]/b[1])*index/fn)
      [b[1]*cos(theta1), a[1]*sin(theta1)]
    + [a[0]*cos(atan(b[0]/a[0])) , 0]
    - [b[1]*cos(atan(a[1]/b[1])) , 0],

    for(index = [0:fn-1]) // section Top
     let(theta2 = atan(b[0]/a[0]) + (180 -2*atan(b[0]/a[0]))*index/fn)
      [a[0]*cos(theta2), b[0]*sin(theta2)]
    - [0, b[0]*sin(atan(b[0]/a[0]))]
    + [0, a[1]*sin(atan(a[1]/b[1]))],

    for(index = [0:fn-1]) // section left
     let(theta2 = -atan(a[1]/b[1])+180+ 2*atan(a[1]/b[1])*index/fn)
      [b[1]*cos(theta2), a[1]*sin(theta2)]
    - [a[0]*cos(atan(b[0]/a[0])) , 0]
    + [b[1]*cos(atan(a[1]/b[1])) , 0],

    for(index = [0:fn-1]) // section Top
     let(theta2 = atan(b[0]/a[0]) + 180 + (180 -2*atan(b[0]/a[0]))*index/fn)
      [a[0]*cos(theta2), b[0]*sin(theta2)]
    + [0, b[0]*sin(atan(b[0]/a[0]))]
    - [0, a[1]*sin(atan(a[1]/b[1]))]
]/2;

function sign_x(i,n) =
	i < n/4 || i > n-n/4  ?  1 :
	i > n/4 && i < n-n/4  ? -1 :
	0;

function sign_y(i,n) =
	i > 0 && i < n/2  ?  1 :
	i > n/2 ? -1 :
	0;
