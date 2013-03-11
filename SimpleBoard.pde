
ArrayList<Piece> myPieces;
Piece[] touchDraggedPieces;
Piece mouseDraggedPiece;
Piece selectedPiece;
ArrayList<Piece> allPieces;

Roller myRoller;


void setup(){
  size( 800, 600 );
  myPieces = new ArrayList<Piece>();
  for( int i = 0; i < 5; i++ ) {
    myPieces.add( new Piece( random(width), random(height) ) );
  }
  myRoller = new Roller( 100, 44 );
  
  allPieces = new ArrayList<Piece>();
  allPieces = myPieces;
  allPieces.add( myRoller );

  touchDraggedPieces = new Piece[ 4 ];

  selectedPiece = null;
  smooth();
} // end setup()




void draw() {
  background( 0 );
  for( Piece p : allPieces )
    p.display();
  myRoller.display();
} // end draw()



void mousePressed() {
  for( Piece p :allPieces ) {
    if( p.mouseOver )
      p.toggleSelected();
    else
      p.selected = false;
  }

  selectedPiece = null;
  for( Pieces p : allPieces ) {
    if( p.selected )
      selectedPiece = p;
  }
}




void mouseDragged(){
  if( mouseDraggedPiece == null ) {
    for( Piece p :allPieces ) {
      if( p.mouseOver ){
        p.selected = true;
        selectedPiece = p;
        p.dragged = true;
        mouseDraggedPiece = p;
      }
    }
  }
  if( mouseDraggedPiece != null )
    mouseDraggedPiece.updatePos( mouseX, mouseY );
}




void mouseReleased() {
  if( mouseDraggedPiece != null ) {
    mouseDraggedPiece.dragged = false;
    mouseDraggedPiece = null;
  }
} // end mouseReleased()




void touchStart(TouchEvent touchEvent){
/*
  float[] xTouches = new float[ touchEvent.touches.length ];
  float[] yTouches = new float[ touchEvent.touches.length ];
  for( int i = 0; i < touchEvent.touches.length; i++ ) {
    xTouches[ i ] = touchEvent.touches[ i ].offsetX;
    yTouches[ i ] = touchEvent.touches[ i ].offsetY;

    for( Piece p : allPieces )
      if( p.isAbove( xTouches[ i ], yTouches[ i ] ) )
        p.toggleSelected();;
    
  }
*/

  if( touchEvent.touches.length == 1 ) {
    float xNew = touchEvent.touches[ 0 ].offsetX;
    float yNew = touchEvent.touches[ 0 ].offsetY;
    for( Pieces p : allPieces )
      if( p.isAbove( xNew, yNew ) )
        p.toggleSelected();
      else
        p.selected = false;

    selectedPiece = null;
    for( Piece p : allPieces )
      if( p.selected )
        selectedPiece = p;
  }
} // end touchStart()




void touchEnd( TouchEvent touchEvent ) {
  for( Piece p : allPieces )
    p.dragged = false;
  touchDraggedPieces = new Piece[ 4 ];
} // end touchEnd()




void touchMove(TouchEvent touchEvent) {
  for( int i = 0; i < touchEvent.touches.length; i++ ) {
    float xNew = touchEvent.touches[ i ].offsetX;
    float yNew = touchEvent.touches[ i ].offsetY;
    if( touchDraggedPieces[ i ] != null )
      touchDraggedPieces[ i ].updatePos( xNew, yNew );
    else {
      for( Piece p : allPieces ) {
        if( p.isAbove( xNew, yNew ) ) {
          p.dragged = true;
          p.updatePos( xNew, yNew );
          touchDraggedPieces[ i ] = p;
        }
      }
    }  
  }
} // end touchMove()

//=============

class Piece {
  
  float xPos, yPos;
  float diam;
  boolean dragged, mouseOver, selected;
  
  
  
   Piece() {
    xPos = width / 2;
    yPos = height / 2;
    diam = 40;
    dragged = false;
    mouseOver = false;
    selected = false;
  } // end constructor
  
  
  
   
  Piece( float xInit, float yInit ) {
    xPos = xInit;
    yPos = yInit;
    diam = 40;
    dragged = false;
    mouseOver = false;
    selected = false;
  } // end constructor
  
  
  
  
  Piece( float xInit, float yInit, float diamInit ) {
    xPos = xInit;
    yPos = yInit;
    diam = diamInit;
    dragged = false;
    mouseOver = false;
    selected = false;
  } // end constructor
  
  
  
  

  void display(){
    mouseOver = isHover();

    if( selected ) {
      stroke( 255, 100, 100 );
      strokeWeight( 3 );
    } else {
      stroke( 128 );
      strokeWeight( 1 );
    }

    if( dragged || mouseOver )
      fill( 255, 0, 0 );
    else
      fill( 0, 0, 255 );

    ellipse( xPos, yPos, diam, diam );
  } // end display()
  
  
  
  
  boolean isAbove( float xCheck, float yCheck ){
    // returns true if distance between checking point and center of the piece
    // is smaller than the radius of the piece
    // returns false otherwise
    if( dist( xCheck, yCheck, xPos, yPos ) < ( diam / 2) )
      return true;
    else
      return false;    
  } // end isAbove()
  
  
  
  
  boolean isHover() {
    // returns true if mouse is hovering above the piece
    // returns false otherwise
    if( isAbove( mouseX, mouseY ) )
      return true;
    else
      return false;
  } // end isHover()
  
  
  
  
  void updatePos( float xNew, float yNew ) {
    xPos = xNew;
    yPos = yNew;
  } // end updatePos()
  
  


  void toggleSelected() {
    if( selected )
      selected = false;
    else
      selected = true;
  } // end toggleSelected()





} // end class Piece

//=================

class Roller extends Piece {
  
    // see superclass for other fields
    float xDir, yDir; // determines the rolling direction
    int updateDelay = 0;
  
  Roller() {
    super();
    xDir = 1;
    yDir = 1;
  } 
  
  
  
  
  Roller( float xInit, float yInit ) {
    super( xInit, yInit ); 
    xDir = 1;
    yDir = 1;
  }
  
  
  
  
  Roller( float xInit, float yInit, float diamInit ) {
    super( xInit, yInit, diamInit ); 
    xDir = 1;
    yDir = 1;
  }
  
  
  
  
  void display() {
    super.display();
    roll();
  } // end display()
  
  
  
  
  void roll() {
    updateDelay++;
    if( updateDelay > 2 ) {
      xPos += xDir;
      if( xPos > width || xPos < 0 )
        xDir *= -1;
      yPos +=  yDir;
      if( yPos > height || yPos < 0 )
        yDir *= -1;
      updateDelay = 0;   
    }
  } // end roll()
  
  
  
  
  
} // end class Roller


