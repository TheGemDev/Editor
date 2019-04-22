package modules.tiles;

import modules.tiles.tools.*;
import level.data.Level;
import level.data.Layer;
import level.editor.LayerEditor;
import level.editor.Tool;
import project.data.LayerTemplate;
import project.data.LayerDefinition;

class TileLayerTemplate extends LayerTemplate
{
  public static function startup()
	{
		var tools:Array<Tool> = [
        new TilePencilTool(),
        new TileRectangleTool(),
        new TileLineTool(),
        new TileFloodTool(),
        new TileEyedropperTool(),
    ];
    var n = new LayerDefinition(TileLayerTemplate, TileLayerTemplateEditor, "tile", "layer-tiles", "Tile Layer", tools, 2);
    LayerDefinition.definitions.push(n);
	}

  public var exportMode:Int = TileExportModes.IDS;
  public var trimEmptyTiles:Bool = true;
	public var defaultTileset:String = null;
    
  override function createEditor(id:Int): LayerEditor
  {
    return new TileLayerEditor(id);
  }

  override function createLayer(level:Level, id:Int):Layer
  {
    return new TileLayer(level, id);
  }

  override function save():Dynamic
  {
    var data:Dynamic = super.save();
              
    data.exportMode = exportMode;
    if (defaultTileset != null) data.defaultTileset = defaultTileset;
    else data.defaultTileset = "";
        
    return data;
  }
  
  override function load(data: Dynamic):LayerTemplate
  {
    super.load(data);
      
    exportMode = Imports.integer(data.exportMode, TileExportModes.IDS);
    defaultTileset = data.defaultTileset;
      
    return this;
  }
}