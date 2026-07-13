package backend;

typedef GameData = 
{
    var name:String;
    
    @:optional var grid_image:String;
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
            name: "Y-Sides",
            grid_image: 'ysides'
        },
        {
            name: "+2 Billetes"
        },
        {
            name: "My Hero Academia"
        }
    ];
}