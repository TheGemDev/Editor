package io;

import haxe.Json;
import js.Browser;
import js.html.Document;
import js.html.ImageElement;
import js.node.Buffer;
import js.node.Fs;
import electron.FileFilter;
import electron.renderer.Remote;
import electron.main.Dialog;

class FileSystem
{

	public static function chooseFile(title:String, filters:Array<FileFilter>)
	{
		var files = Dialog.showOpenDialog(
			Remote.getCurrentWindow(),
			{
				title: title,
				properties: ['openFile'],
				filters: filters
			}
		);

		if (files != null) return files[0];
		return '';
	}

	public static function chooseSaveFile(title:String, filters:Array<FileFilter>):String
	{
		var file = Dialog.showSaveDialog(
			Remote.getCurrentWindow(),
			{
				title: title,
				filters: filters
			}
		);
		if (file != null) return file;
		return '';
	}

	public static function chooseFolder(title:String):String
	{
		var files = Dialog.showOpenDialog(
			Remote.getCurrentWindow(),
			{
				title: title,
				properties: ['openDirectory']
			}
		);
		if (files != null) return files[0];
		return '';
	}

	public static function showQuestion(title:String, question:String, confirm:String, deny:String):Bool
	{
		var result = Dialog.showMessageBox(
			Remote.getCurrentWindow(),
			{
				message: question,
				title: title,
				type: 'warning',
				buttons: [confirm, deny],
				cancelId: 1,
				defaultId: 1
			}
		);
		
		return (result == 0);
	}

	public static function removeFolder(dir:String)
	{
		if (!exists(dir)) return;
	}

	public static function exists(path:String):Bool
	{
		return Fs.existsSync(path);
	}

	public static function readDirectory(path:String):Array<String>
	{
		return Fs.readdirSync(path);
	}

	public static function stat(path:String):Dynamic
	{
		return Fs.statSync(path);
	}

	public static function loadString(path:String):String
	{
		return Fs.readFileSync(path, "utf8");
	}
	
	public static function loadImage(path:String):ImageElement
	{
		if (FileSystem.exists(path))
		{
			var image = Browser.document.createImageElement();
			var b = new Buffer(Fs.readFileSync(path));
			image.src = "data:image/png;base64," + b.toString("base64");
			return image;
		}
		return null;
	}

	public static function saveString(data:String, path:String)
	{
		Fs.writeFileSync(path, data);
	}

	/*
			JSON
	*/

	public static function stringToJSON(str:String):Dynamic
	{
		return Json.parse(str);
	}

	public static function JSONtoString(data:Dynamic):String
	{
		return Json.stringify(data, null, '\t');
	}

	public static function loadJSON(path:String):Dynamic
	{
		return FileSystem.stringToJSON(FileSystem.loadString(path));
	}

	public static function saveJSON(data:Dynamic, path:String):String
	{
		var str = FileSystem.JSONtoString(data);
		FileSystem.saveString(str, path);
		return str;
	}

	/*
			XML
	*/

	// TODO - I don't know what this is -01010111
	/*public static function stringToXML(str:String):Document
	{
		return $.parseXML(str);
	}*/

	public static function XMLtoString(xml:Document, ?pretty:Bool):String
	{
		var str = xml.documentElement.outerHTML;
		// TODO - ugh do we have to? -01010111
		//if (pretty == true) str = FileSystem.prettyXML(str);
		return str;
	}

	// TODO - dependant on stringToXML() -01010111
	/*public static function loadXML(path:String):Document
	{
		return FileSystem.stringToXML(FileSystem.loadString(path));
	}*/

	public static function saveXML(xml:Document, path:String, ?pretty:Bool):String
	{
		var str = FileSystem.XMLtoString(xml, pretty);
		FileSystem.saveString(str, path);
		return str;
	}

	// TODO - ugh do we have to? (part two) -01010111
	/*public static function prettyXML(xml:String):String
	{
		var formatted = '';
		var reg = ~/(>)(<)(\/*)/g;
		xml = xml.replace(reg, '$1\r\n$2$3');
		var pad = 0;
		jQuery.each(xml.split('\r\n'), function(index, node) {
			var indent = 0;
			if (node.match( ~/.+<\/\w[^>]*>$/ )) {
				indent = 0;
			} else if (node.match( ~/^<\/\w/ )) {
				if (pad != 0) {
					pad -= 1;
				}
			} else if (node.match( ~/^<\w[^>]*[^\/]>.*$/ )) {
				indent = 1;
			} else {
				indent = 0;
			}

			var padding = '';
			for (var i = 0; i < pad; i++) {
				padding += '  ';
			}

			formatted += padding + node + '\r\n';
			pad += indent;
		});

		return formatted;
	}*/

}

enum UnsavedOptions
{
	Save;
	NoSave;
	Cancel;
}