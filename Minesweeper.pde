
import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private static final int NUM_ROWS = 20;
private static final int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean notLost = true;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int i = 0; i < NUM_ROWS; ++i) {
        for (int j = 0; j < NUM_COLS; ++j) {
            buttons[i][j] = new MSButton(i,j);
        }
    }

    while(bombs.size()<50)
        setBombs();
}
public void setBombs()
{
    int randRow = (int)(Math.random()*NUM_ROWS);
    int randCol = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[randRow][randCol]))
        bombs.add(buttons[randRow][randCol]);
        println(randRow + ", " + randCol);
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    if(!notLost)
        return false;
    for(int i=0; i<NUM_ROWS; i++){
        for(int j=0; j<NUM_COLS; j++){
            if(!buttons[i][j].isClicked()){
                if(!bombs.contains(buttons[i][j]))
                    return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    for(int i=0; i<bombs.size(); i++){
        if(!bombs.get(i).isClicked()){
            bombs.get(i).mousePressed();
        }
    }
    buttons[9][5].setLabel("Y");
    buttons[9][6].setLabel("o");
    buttons[9][7].setLabel("u");
    buttons[9][8].setLabel(" ");
    buttons[9][9].setLabel("L");
    buttons[9][10].setLabel("o");
    buttons[9][11].setLabel("s");
    buttons[9][12].setLabel("e");
    notLost = false;
}
public void displayWinningMessage()
{
    buttons[9][5].setLabel("Y");
    buttons[9][6].setLabel("o");
    buttons[9][7].setLabel("u");
    buttons[9][8].setLabel(" ");
    buttons[9][9].setLabel("W");
    buttons[9][10].setLabel("i");
    buttons[9][11].setLabel("n");
    buttons[9][12].setLabel("!");
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
    
    public void mousePressed() 
    {
        if(!notLost || isWon())
            return;
        boolean wasClicked = isClicked();
        clicked = true;
        if(mouseButton==RIGHT){
            if(marked){
                if (!wasClicked) {
                    clicked=false;
                    marked=false;
                }
            }else{
                if(!wasClicked){
                    marked=true;
                    clicked=false;
                }
            }
        }else if (bombs.contains( this )) {
            if(!marked)
               displayLosingMessage();
        }else if (countBombs(r, c)>0) {
            setLabel("" + countBombs(r,c));
        }else{
            if (isValid(r-1,c-1)) {
                if(!buttons[r-1][c-1].isClicked())
                    buttons[r-1][c-1].mousePressed();
            }
            if (isValid(r-1,c)) {
                if(!buttons[r-1][c].isClicked())
                    buttons[r-1][c].mousePressed();
            }
            if (isValid(r-1,c+1)) {
                if(!buttons[r-1][c+1].isClicked())
                    buttons[r-1][c+1].mousePressed();
            }
            if (isValid(r,c-1)) {
                if(!buttons[r][c-1].isClicked())
                    buttons[r][c-1].mousePressed();
            }
            if (isValid(r,c+1)) {
                if(!buttons[r][c+1].isClicked())
                    buttons[r][c+1].mousePressed();
            }
            if (isValid(r+1,c-1)) {
                if(!buttons[r+1][c-1].isClicked())
                    buttons[r+1][c-1].mousePressed();
            }
            if (isValid(r+1,c)) {
                if(!buttons[r+1][c].isClicked())
                    buttons[r+1][c].mousePressed();
            }
            if (isValid(r+1,c+1)) {
                if(!buttons[r+1][c+1].isClicked())
                    buttons[r+1][c+1].mousePressed();
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
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
        if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS) {
            return true;
        }else{
            return false;
        }
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if(isValid(row-1, col-1)){
            if (bombs.contains(buttons[row-1][col-1])) {
                numBombs++;
            }
        }
        if(isValid(row-1,col)){
            if (bombs.contains(buttons[row-1][col])) {
                numBombs++;
            }
        }
        if(isValid(row-1, col+1)){
            if (bombs.contains(buttons[row-1][col+1])) {
                numBombs++;
            }
        }
        if(isValid(row, col-1)){
            if (bombs.contains(buttons[row][col-1])) {
                numBombs++;
            }
        }
        if(isValid(row, col+1)){
            if (bombs.contains(buttons[row][col+1])) {
                numBombs++;
            }
        }
        if(isValid(row+1, col-1)){
            if (bombs.contains(buttons[row+1][col-1])) {
                numBombs++;
            }
        }
        if(isValid(row+1, col)){
            if (bombs.contains(buttons[row+1][col])) {
                numBombs++;
            }
        }
        if(isValid(row+1, col+1)){
            if (bombs.contains(buttons[row+1][col+1])) {
                numBombs++;
            }
        }
        return numBombs;
    }
}