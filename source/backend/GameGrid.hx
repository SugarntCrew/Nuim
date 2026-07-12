package backend;

typedef GameData = 
{
    var name:String;
}

class GameGrid
{
    public static var games(default, default):Array<GameData> = [
        {
            name: "Hola caracola"
        },
        {
            name: "Mario Wonder"
        },
        {
            name: "Tears of the Kingdom"
        },
        {
            name: "Fortnite"
        },
        {
            name: "Y-Sides"
        },
        {
            name: "+2 Billetes"
        },
        {
            name: "My Hero Academia"
        }
    ];
}