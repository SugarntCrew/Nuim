package backend;

typedef GameData = 
{
    var name:String;
    
    @:optional var description:String;
    @:optional var grid_image:String;
    @:optional var heroe_image:String;
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
            name: "Friday Night Funkin': Y-Sides",
            description: 'A remix mod made by a group of friends!',
            grid_image: 'ysides',
            heroe_image: 'ysides'
        },
        {
            name: "+2 Billetes",
            heroe_image: '2billetes'
        },
        {
            name: "My Hero Academia"
        }
    ];
}