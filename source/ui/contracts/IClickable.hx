package ui.contracts;

interface IClickable 
{
    public function onHover():Void;
    public function hover(hover:Bool):Void;
    public function onUnhover():Void;
    public function onClick(?customBehavior:Dynamic):Void;    
}