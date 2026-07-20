package backend;

typedef GameData = 
{
    var name:String;
    var game_location:String;
    
    @:optional var description:String;
    @:optional var grid_image:String;
    @:optional var heroe_image:String;
    @:optional var developer:String;
    @:optional var publisher:String;
    @:optional var genre:String;
    @:optional var release:String;
    @:optional var version:String;
    @:optional var url:String; // this can be api url or fnf mod url in some cases
}

class GameGrid
{
    public static var games(default, default):Array<GameData> = [
        {
            name: "Hola caracola",
            game_location: ""
        },
        {
            name: "Mario Wonder",
            game_location: ""
        },
        {
            name: "Tears of the Kingdom",
            game_location: ""
        },
        {
            name: "Fortnite",
            game_location: ""
        },
        {
            name: "Friday Night Funkin': Y-Sides",
            game_location: "C:\\Users\\ismae\\Documents\\GitHub\\FNF-Y-SIDES-DEV\\export\\release\\windows\\bin\\YSides.exe",
            description: 'A remix mod made by a group of friends!',
            grid_image: 'ysides',
            heroe_image: 'ysides',
            developer: 'SugarntCrew',
            publisher: 'SugarntCrew',
            genre: 'Rythm',
            release: '2026',
            version: 'v2.0.1',
            url: 'https://gamebanana.com/mods/586813'
        },
        {
            name: "+2 Billetes",
            game_location: "",
            heroe_image: '2billetes'
        },
        {
            name: "My Hero Academia",
            game_location: ""
        },
        {
            name: "Infected Beats",
            game_location: "",
            url: 'https://gamebanana.com/mods/473596'
        },
        {
            name: "Springfunked",
            game_location: "",
            url: 'https://gamebanana.com/mods/615034'
        },
        {
            name: "Prange Guy",
            game_location: "",
            grid_image: 'prange',
            heroe_image: 'prange',
            url: 'https://gamebanana.com/mods/693558',
        },
        {
            name: "VS Gameoverse",
            game_location: "",
            grid_image: 'gameoverse',
            heroe_image: 'gameoverse',
            url: 'https://gamebanana.com/mods/680661',
        },
        {
            name: "VS Teto",
            game_location: "",
            grid_image: 'teto',
            heroe_image: 'teto',
            url: 'https://gamebanana.com/mods/669566',
        },
        {
            name: "gBvNeverEvers",
            game_location: "",
            grid_image: 'teto',
            heroe_image: 'teto',
            url: 'https://gamebanana.com/mods/479317',
        },
        {
            name: "Mr. Tronco ",
            game_location: "",
            grid_image: 'teto',
            heroe_image: 'teto',
            url: 'https://gamebanana.com/mods/436927',
        }
    ];
}