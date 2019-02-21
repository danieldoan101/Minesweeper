

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private static final int NUM_ROWS = 20;
private static final int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int i = 0; i < NUM_ROWS; ++i) {
        for (int j = 0; j < NUM_COLS; ++j) {
            buttons[i][j] = new MSButton(i, j);        
        }        
    }     
    bombs = new ArrayList <MSButton>();
    while(bombs.size()<10)
        setBombs();
}
public void setBombs()
{
    int randRow = (int)(Math.random()*NUM_ROWS);
    int randCol = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[randRow][randCol]))
        bombs.add(new MSButton(randRow, randCol));
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();

}
public boolean isWon()
{
    for (int i = 0; i < NUM_ROWS; ++i) {
        for (int j = 0; j < NUM_COLS; ++j) {
            if(!buttons[i][j].isMarked()){
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    text("YOU LOST", 200, 200);;
}
public void displayWinningMessage()
{
    text("YOU WON!", 200, 200);
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton==RIGHT) {
            if(marked){
                marked=false;
            }else{
                marked=true;
            }
        }else if (bombs.contains(buttons[r][c])) {
            displayLosingMessage();
        }else if(countBombs(r, c)>0){
            setLabel(""+countBombs(r,c));
        }else{
            if (buttons[r-1][c-1].isValid(r-1, c-1)) {
                buttons[r-1][c-1].mousePressed();
            }
            if (buttons[r-1][c].isValid(r-1, c)) {
                buttons[r-1][c].mousePressed();
            }
            if (buttons[r-1][c+1].isValid(r-1, c+1)) {
                buttons[r-1][c+1].mousePressed();
            }
            if (buttons[r][c-1].isValid(r, c-1)) {
                buttons[r][c-1].mousePressed();
            }
            if (buttons[r][c+1].isValid(r, c+1)) {
                buttons[r][c+1].mousePressed();
            }
            if (buttons[r+1][c-1].isValid(r+1, c-1)) {
                buttons[r+1][c-1].mousePressed();
            }
            if (buttons[r+1][c].isValid(r+1, c)) {
                buttons[r+1][c].mousePressed();
            }
            if (buttons[r+1][c+1].isValid(r+1, c+1)) {
                buttons[r+1][c+1].mousePressed();
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) {
            fill(255,0,0);
        }else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r<NUM_ROWS && r>=0 && c<NUM_COLS && c>=0)
            return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if(buttons[row+1][col+1].isValid(row+1,col+1)){
            if (bombs.contains(buttons[row+1][col+1])) {
                numBombs++;
            }
        }
        if(buttons[row+1][col].isValid(row+1,col)){
            if (bombs.contains(buttons[row+1][col])) {
                numBombs++;
            }
        }
        if(buttons[row+1][col-1].isValid(row+1,col-1)){
            if (bombs.contains(buttons[row+1][col-1])) {
                numBombs++;
            }
        }
        if(buttons[row][col+1].isValid(row,col+1)){
            if (bombs.contains(buttons[row][col+1])) {
                numBombs++;
            }
        }if(buttons[row][col-1].isValid(row,col-1)){
            if (bombs.contains(buttons[row][col-1])) {
                numBombs++;
            }
        }
        if(buttons[row-1][col+1].isValid(row-1,col+1)){
            if (bombs.contains(buttons[row-1][col+1])) {
                numBombs++;
            }
        }
        if(buttons[row-1][col].isValid(row-1,col)){
            if (bombs.contains(buttons[row-1][col])) {
                numBombs++;
            }
        }
        if(buttons[row-1][col-1].isValid(row-1,col-1)){
            if (bombs.contains(buttons[row-1][col-1])) {
                numBombs++;
            }
        }
        return numBombs;
    }
}



