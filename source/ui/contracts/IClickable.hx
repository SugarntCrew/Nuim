package ui.contracts;

interface IClickable 
{
    public function hover(hover:Bool):Void;
    public function onHover():Void;
    public function onClick(?customBehavior:Dynamic):Void;    
}