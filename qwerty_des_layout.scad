use <MX_DES_Convex.scad>

legends = [

// LINE ROW 1 F row
  // left side

  [ 
    0, "Esc", 3, "Arial:style=Bold"   // with blank
  ],
    [
    0, "F1", 3, "Arial:style=Bold"
  ],
  [
    0, "F2", 3, "Arial:style=Bold"

  ],
  [
    0, "F3", 3, "Arial:style=Bold"
  ],


  // LINE ROW 1 F row
  // right side
  
  [
    0, "F7", 3, "Arial:style=Bold"
  ],
  [
    0, "F8", 3, "Arial:style=Bold"
  ],
  [
    0, "F9", 3, "Arial:style=Bold"
  ],


// LINE ROW 2 num row
  // left side

  [ 
    1, "DRG", 2.5, "Arial:style=Bold",   // with blank
  ],
  [
    1, "`", 4, "Arial:style=Bold"
  ],
  [
    1, "1", 3, "Arial:style=Bold"

  ],

  // LINE ROW 2 num row
  // right side
  
  [
    1, "6", 3, "Arial:style=Bold"
  ],
  [
    1, "7", 3, "Arial:style=Bold"
  ], 
  [
    1, "8", 3, "Arial:style=Bold"
  ]

];


// for (i=[0:len(legends)-1]) {
//     key = legends[i];
//     row = key[0];
//     text = key[1];
//     font = key[3];
//     size = key[2];
//     translate([i * 20, 0, 0]) keycap(
//         keyID = row,
//         Stem = true,
//         crossSection = false,
//         Legends=true,
//         text=text,
//         font=font,
//         textSize=size,
//     );

// };

letters = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M" ];

for (i =[1:10]) {
    // key = legends[i];
   
    translate([0, i * 20, 0]) keycap(
        keyID  = i + 10, //change profile refer to KeyParameters Struct
        cutLen = 0, //Don't change. for chopped caps
        Stem   = true, //tusn on shell and stems
        Dish   = true, //turn on dish cut
        Stab   = 0,
        visualizeDish = false, // turn on debug visual of Dish
        crossSection  = false, // center cut to check internal
        homeDot = false, //turn on homedots
        homeRing = false, //turn on homing rings
        Legends = true,
        text = letters[i],
        font = "Arial:style=Bold",
        textSize = 5
    );

}