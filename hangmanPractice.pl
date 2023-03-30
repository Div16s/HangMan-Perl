#!/usr/bin/perl

package HangMan{

    #Array named words to store some random words, which will be used by the program for guessing
    @words = (
        "computer",      "radio",        "calculator",    "teacher",
        "bureau",        "police",       "geometry",      "president",
        "subject",       "country",      "enviroment",    "classroom",
        "animals",       "province",     "month",         "politics",
        "puzzle",        "instrument",   "kitchen",       "language",
        "vampire",       "ghost",        "solution",      "service",
        "software",      "virus25",      "security",      "phonenumber",
        "expert",        "website",      "agreement",     "support",
        "compatibility", "advanced",     "search",        "triathlon",
        "immediately",   "encyclopedia", "endurance",     "distance",
        "nature",        "history",      "organization",  "international",
        "championship",  "government",   "popularity",    "thousand",
        "feature",       "wetsuit",      "fitness",       "legendary",
        "variation",     "equal",        "approximately", "segment",
        "priority",      "physics",      "branche",       "science",
        "mathematics",   "lightning",    "dispersion",    "accelerator",
        "detector",      "terminology",  "design",        "operation",
        "foundation",    "application",  "prediction",    "reference",
        "measurement",   "concept",      "perspective",   "overview",
        "position",      "airplane",     "symmetry",      "dimension",
        "toxic",         "algebra",      "illustration",  "classic",
        "verification",  "citation",     "unusual",       "resource",
        "analysis",      "license",      "comedy",        "screenplay",
        "production",    "release",      "emphasis",      "director",
        "trademark",     "vehicle",      "aircraft",      "experiment"
    ); 

    #Array named allParts to store all the parts that can be hung
    @allParts = ('O', '|', '/', '\\', '/', '\\');

    #Array named hangedParts to store all the parts that has been hung
    @hangedParts = (' ', ' ', ' ', ' ', ' ', ' ');
    
    #intial states of useful variables
    @word;   #stores the random word chosen by the computer
    $win=0;  #stores the state of wining/losing of user, 1 if user wins else 0
    $guessesLeft = 6; #the number of wrong gueses a user is allowed to make
    $guessesMade = 0;  #the number of correct letters a user have guessed from the word
    @guesses;   #stores all the guesses correct/wrong made so far
    @guessedWord; 
    $letter;    #stores the letter entered by the user

    sub Clear() {

        @word        = ();
        $win         = 0;
        $guessesLeft = 6;
        $guessesMade = 0;
        @guesses     = ();
        @guessedWord = ();
        @hangedParts = ( ' ', ' ', ' ', ' ', ' ', ' ',);
    }

    sub start {
        #This function is called every time when new game starts

        #Before the start of every new game
        Clear();

        #taking a random word from the words array using rand function
        $word = uc @words[rand($#words+1)];

        @word = split('',$word);

        #Making the guessedWord of size equals of random word and replcing characters by _
        for($i=0; $i<$#word+1; $i++){
            push @guessedWord, '_';
        }

        print "\nYou only have 6 guesses\n";

        while($win==0){
            Guess();
        }

        if($win==1){
            print "\nHurray! You have guessed it! It was $word!\n";
        }
        else{
            print "  _ _ \n |   | \n |   " . @hangedParts[0] . " \n";
            print " |  "
                . @hangedParts[2]
                . @hangedParts[1]
                . @hangedParts[3] . "\n";
            print " |   " . @hangedParts[1] . "\n";
            print " |  "
                . @hangedParts[4] . " "
                . @hangedParts[5]
                . "\n_|_    \n";
            print "\nOops Sorry, You ran out of guesses!\n";
            print "\nThe word is $word\n";
        }
    }

    sub Guess {
        #This function will be called to ask user to make a guess
        $input = 0;

        while($input==0){
            #while $input is 0 that means correct input has'nt been given

            Display();

            #Taking input
            $letter = <STDIN>;
            $letter = uc substr($letter, 0 ,1);

            if($letter eq "\n" || $letter eq " "){
                #if input is blank, display the below message and ask for input again
                print "\nInput should be a single alpha-numeric character\n";
            }
            else{
                $input=1;
            }
        }

        #Calling update function to update the word by letter guess
        Update();
    }

    sub Display {
        #Function to display current state of hangman, word guessed so far, guesses made and guess left
        print "  _ _  \n |   | \n |   " . @hangedParts[0] . " \n";
        print " |  "
          . @hangedParts[2]
          . @hangedParts[1]
          . @hangedParts[3]
          . " Here is your word: @guessedWord\n";
        print " |   "
          . @hangedParts[1]
          . " Guesses made so far: [@guesses]\n";
        print " |  "
            . @hangedParts[4] . " "
            . @hangedParts[5]
            . "\n_|_     \n";
        print "\nGuesses Left: $guessesLeft\n";
        print "\nMake A Guess: ";
    }

    sub Update {
        #Function to update the guessed word with the letter given as input

        for ($i=0; $i<=$#guesses; $i++){
            if($letter eq @guesses[$i]){
                print "\nYou've already guessed this\n";
                return;
            }
        }

        $correctGuess = -1;
        for($i=0; $i<$#word+1; $i++){
            if(@word[$i] eq $letter){
                @guessedWord[$i] = $letter;
                $correctGuess = 1;
                $guessesMade++;
            }
        }

        push @guesses, $letter;

        if($correctGuess == 1){
            print "\nGood Guess!\n";
        }
        else{
            print"\nWrong Guess!\n";

            @hangedParts[6-$guessesLeft] = @allParts[6-$guessesLeft];
            $guessesLeft--;
        }

        if($guessesLeft==0){
            $win=-1;
        }
        elsif($guessesMade == $#word+1){
            $win=1
        }
    }
}

$play=1;
print "\n||  HANGMAN GAME  ||\n";

while($play==1){

    #intializing the variable $game to the class HangMan
    $game = HangMan;

    #Starting the game by calling the start function inside class HangMan
    $game->start;

    #After a game we update #play to 0
    $play=0;

    #Asking the user if he/she wishes to play a new game
    print "\nIf you wish to play another game press Y/y: ";
    $choice = <STDIN>;

    $choice = uc substr($choice, 0, 1);
    if($choice eq 'Y'){
        $play=1;
    }
}