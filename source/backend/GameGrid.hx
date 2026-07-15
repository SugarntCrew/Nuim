package backend;

typedef GameData = 
{
    var name:String;
    
    @:optional var description:String;
    @:optional var grid_image:String;
    @:optional var heroe_image:String;
    @:optional var developer:String;
    @:optional var publisher:String;
    @:optional var genre:String;
    @:optional var release:String;
    @:optional var version:String;
    @:optional var gamebanana_url:String;
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
            heroe_image: 'ysides',
            developer: 'SugarntCrew',
            publisher: 'SugarntCrew',
            genre: 'Rythm',
            release: '2026',
            version: 'v2.0.1',
            gamebanana_url: 'https://gamebanana.com/mods/586813'
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