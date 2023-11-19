use <MX_DES_Standard.scad>

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


for (i=[0:len(legends)-1]) {
    key = legends[i];
    row = key[0];
    text = key[1];
    font = key[3];
    size = key[2];
    translate([i * 20, 0, 0]) keycap(
        keyID = row,
        Stem = true,
        crossSection = false,
        Legends=true,
        text=text,
        font=font,
        textSize=size,
    );

};