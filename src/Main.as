package 
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import br.com.stimuli.loading.BulkLoader;
	
	import fl.controls.Button;
	import fl.controls.Label;
	
	import suity.TotalVars;
	import suity.utils.StringUtils;
	
	/**
	 * ...
	 * @author 不再迟疑
	 */
	public class Main extends Sprite 
	{ 
        private var url:String="Java.txt";  
		private var client_protocol:XML;
		private var totalStr:String;
		private var bodyStr:String;
		private var funcObject:Object = new Object();
		private var vars:Array = new Array();
		private var totalVars:TotalVars = new TotalVars();
		private var loader:BulkLoader;
		private var macros:Array = new Array();
		private var textLog:TextField;
		private var xmlBtn:Button = new Button();
		private var xmlLabel:Label = new Label();
		private var targetBtn:Button = new Button();
		private var targetLabel:Label = new Label();
		private var runBtn:Button = new Button();
		private var selectedSaveFile:File;
		private var xmlPath:String="";
		private var savePath:String = "";
		private var shareObject:SharedObject;
		public function Main():void 
		{
			MonsterDebugger.initialize(this);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			shareObject = SharedObject.getLocal("config");
			NameAndClass.init();
			loader = new BulkLoader("main-site");
			loader.logLevel = BulkLoader.LOG_INFO;
			loader.add("assets/Java.txt", {id:"java"}); 
			loader.add("assets/Macro.txt", {id:"macro"}); 
			loader.add("assets/ClientPkg.txt", { id:"clientpkg" } ); 
			loader.add("assets/Http.txt", {id:"http"}); 
			loader.addEventListener(BulkLoader.COMPLETE, onAllItemsLoaded);
			
			textLog = new TextField();
			addChild(textLog);
			addChild(runBtn);
			addChild(xmlBtn);
			addChild(targetBtn);
			addChild(xmlLabel);
			addChild(targetLabel);
			
			textLog.width = stage.stageWidth;
			textLog.height = stage.stageHeight;
			textLog.appendText("引擎启动中\n");
			
			xmlLabel.width = stage.stageWidth;
			xmlLabel.x = xmlBtn.width;			
			
			targetBtn.y = xmlBtn.height;
			targetLabel.width = stage.stageWidth;
			targetLabel.x = targetBtn.width;
			targetLabel.y = xmlBtn.height;			
			
			runBtn.y = targetBtn.y + targetBtn.height;	
			textLog.y = runBtn.y + runBtn.height;
			
			savePath = shareObject.data["savePath"];
			xmlPath = shareObject.data["xmlPath"];
			if (savePath == null)
			{
				savePath = "";
			}
			if (xmlPath == null)
			{
				xmlPath = "";
			}
			setTimeout(function():void
			{
				xmlBtn.label = "选择xml文件";
				targetBtn.label = "选择目标地址";
				runBtn.label = "运行";	
				targetLabel.text = savePath;
				xmlLabel.text = xmlPath;
			},500);
			xmlBtn.addEventListener(MouseEvent.CLICK, onXML);
			targetBtn.addEventListener(MouseEvent.CLICK, onTarget);
			runBtn.addEventListener(MouseEvent.CLICK, onRun);
			
		}    
		
		private function onRun(e:MouseEvent):void 
		{
			if (savePath == ""||xmlPath=="")
			{
				textLog.appendText("信息不完整\n");
				return;
			}
			loader.add(xmlPath, {id:"client_protocol"}); 
			loader.start();    
		}
		
		private function onTarget(e:MouseEvent):void 
		{
			selectedSaveFile = File.applicationDirectory;
			selectedSaveFile.addEventListener(Event.SELECT, onSelectedSaveFile);
			selectedSaveFile.browseForDirectory("选择输出目录");
		}
		
		private function onSelectedSaveFile(e:Event):void 
		{
			savePath = (e.target as File).nativePath;
			shareObject.data["savePath"] = savePath;
			targetLabel.text = savePath;
		}
		
		private function onXML(e:MouseEvent):void 
		{
			selectedSaveFile = File.applicationDirectory;
			selectedSaveFile.addEventListener(Event.SELECT, onSelectedXMLFile);
			var txtFilter:FileFilter = new FileFilter("XML", "*.xml"); 
			selectedSaveFile.browse([txtFilter]);
		}
		
		private function onSelectedXMLFile(e:Event):void 
		{
			xmlPath = (e.target as File).nativePath;
			shareObject.data["xmlPath"] = xmlPath;
			flash.net.SharedObject
			xmlLabel.text = xmlPath;
		}
		public function onAllItemsLoaded(evt:Event):void 
		{  
			client_protocol = loader.getXML("client_protocol");
			startMacroTex();
			startJavaTex();
			startClientPkgTex();
			startHttpTex();
		}
		
		private function startMacroTex():void 
		{
			var nameClass:NameAndClass;
			var i:int;
			totalStr = loader.getText("macro");
			findFunc();			
			totalVars.ClASS_NAME = "Macro";
			totalVars.DESC = "Macro系统命令字";
			var macroXmlList:XMLList = client_protocol.macro;
			vars.length = 0;
			for (i = 0; i < macroXmlList.length(); i++)
			{				
				nameClass = new NameAndClass(macroXmlList[i].@name.toString(), macroXmlList[i].@type.toString(),"", "", macroXmlList[i].@desc.toString(), macroXmlList[i].@value.toString(),macroXmlList[i].@annotation.toString());
				macros.push(macroXmlList[i].@name.toString());
				vars.push(nameClass);				
			}	
			getOne();
		}
		private function startClientPkgTex():void 
		{
			totalStr = loader.getText("clientpkg");
			findFunc();			
			var protocolXmlList:XMLList = client_protocol.protocol;			
			for (var i:int = 0; i < protocolXmlList.length(); i++)
			{	
				totalVars.ClASS_NAME = "Protocol"+protocolXmlList[i].@name.toString();
				totalVars.DESC = protocolXmlList[i].@desc;
				totalVars.URL = protocolXmlList[i].@url;
				totalVars.RESP = protocolXmlList[i].@resp;
				totalVars.HTTPM = (protocolXmlList[i].@httpmethod.toString()).toLocaleUpperCase();
				vars.length = 0;
				var paraXmlList:XMLList = protocolXmlList[i].para;
				for (var j:int = 0; j < paraXmlList.length(); j++)
				{
					var nameClass:NameAndClass = new NameAndClass(paraXmlList[j].@name.toString(), paraXmlList[j].@type.toString(), "", "", paraXmlList[j].@desc.toString(), paraXmlList[j].@id.toString(), paraXmlList[j].@annotation.toString());
					vars.push(nameClass);		
				}
				getOne();		
			}			
		}
		private function startHttpTex():void 
		{
			totalStr = loader.getText("http");
			findFunc();			
			var protocolXmlList:XMLList = client_protocol.http;			
			for (var i:int = 0; i < protocolXmlList.length(); i++)
			{	
				totalVars.ClASS_NAME = "Http"+protocolXmlList[i].@name.toString();
				totalVars.DESC = protocolXmlList[i].@desc;
				totalVars.URL = protocolXmlList[i].@url;
				totalVars.HTTPM = (protocolXmlList[i].@httpmethod.toString()).toLocaleUpperCase();
				vars.length = 0;
				var paraXmlList:XMLList = protocolXmlList[i].para;
				for (var j:int = 0; j < paraXmlList.length(); j++)
				{
					var nameClass:NameAndClass = new NameAndClass(paraXmlList[j].@name.toString(), paraXmlList[j].@type.toString(), "", "", paraXmlList[j].@desc.toString(), paraXmlList[j].@id.toString(), paraXmlList[j].@annotation.toString());
					vars.push(nameClass);		
				}
				getOne();		
			}			
		}
		private function startJavaTex():void
		{
			totalStr = loader.getText("java");
			findFunc();
			var structXmlList:XMLList = client_protocol.struct;
			for (var i:int = 0; i < structXmlList.length(); i++)
			{
				totalVars.ClASS_NAME = structXmlList[i].@name.toString();
				totalVars.DESC = structXmlList[i].@desc.toString();
				totalVars.EXTEND = structXmlList[i].@extend.toString();
				vars.length = 0;
				var entryXmlList:XMLList = structXmlList[i].entry;
				for (var j:int = 0; j < entryXmlList.length(); j++)
				{
					var nameClass:NameAndClass = new NameAndClass(entryXmlList[j].@name.toString(), entryXmlList[j].@type.toString(), "","", entryXmlList[j].@desc.toString(), "",entryXmlList[j].@annotation.toString());
					vars.push(nameClass);
				}
				getOne("bean/");
			}			
		}
		private function getOne(path:String=""):void
		{
			var outString:String = bodyStr;
			for (var prm:String in funcObject)
			{
				outString = StringUtils.replace(outString, StringUtils.Format("<<{0}>>", prm), creatFunc(prm));
			}
			outString = replaceTotal(outString); 
			writeOne(path+totalVars.ClASS_NAME, outString);
			textLog.appendText("生成协议:"+totalVars.ClASS_NAME+"\n");
		}
		private function writeOne(name:String,outString:String):void
		{
			var file:File = new File(savePath).resolvePath(name+".java");
			var filestr:FileStream = new FileStream();
			filestr.open(file,FileMode.WRITE);
			filestr.writeUTFBytes(outString);
			filestr.close();
		}
		private function replaceTotal(str:String):String
		{
			str = StringUtils.replace(str, "@class_name", totalVars.ClASS_NAME);
			str = StringUtils.replace(str, "@class_url", totalVars.URL);
			str = StringUtils.replace(str, "@class_resp", totalVars.RESP);
			str = StringUtils.replace(str, "@class_httpmethod", totalVars.HTTPM);
			
			if (totalVars.EXTEND != "")
			{
				str = StringUtils.replace(str, "@class_extends", "extends "+totalVars.EXTEND);
			}else{
				str = StringUtils.replace(str, "@class_extends", "");
			}
			str = StringUtils.replace(str, "@desc", totalVars.DESC);
			return str;
		}
		private function findMacro(value:String):String
		{
			if (macros.indexOf(value) >= 0)
			{
				return "Macro." + value;
			}else
			{
				return value;
			}
		}
		private function findFunc():void
		{
			funcObject = new Object();
			var splic:Array = totalStr.split("<<<");
			bodyStr = splic[0];
			for (var i:int = 1; i < splic.length; i++)
			{
				var tempSplic:Array = String(splic[i]).split(">>>");
				funcObject[tempSplic[0]] = tempSplic[1];
			}			
		}
		private function creatFunc(str:String):String
		{
			var temp:String = "";
			var once:String = funcObject[str];
			once = StringUtils.clearnorr(once);
			var duanlo:Boolean = false;
			if (once.charAt(once.length-1) == ';'||once.charAt(once.length-1) == '}')
			{
				duanlo = true;
			}
			for (var i:int = 0; i < vars.length; i++)
			{					
				temp += replace(once,vars[i]);
				if (duanlo) 
				{
					if (i < vars.length - 1)
					{
						temp += "\n";
					}
				}
				else
				{
					if (i < vars.length)
					{
						temp+= ",  ";
					}
				}
			}
			return temp;
		}
		private function replace(str:String,nameAndClass:NameAndClass):String
		{
			str = StringUtils.replace(str, "@vars_annotation", nameAndClass.annotation);
			str = StringUtils.replace(str, "@vars_name", nameAndClass.name);
			str = StringUtils.replace(str, "@vars_class", nameAndClass.getClass());
			str = StringUtils.replace(str, "@vars_desc", nameAndClass.desc);
			str = StringUtils.replace(str, "@vars_formate_class", nameAndClass.getClassFormate());				
			str = StringUtils.replace(str, "@macros_name", nameAndClass.mname);	
			str = StringUtils.replace(str, "@macros_class", nameAndClass.getClass());
			str = StringUtils.replace(str, "@macros_desc", nameAndClass.desc);			
			str = StringUtils.replace(str, "@find_macros_value", findMacro(nameAndClass.value));			
			str = StringUtils.replace(str, "@macros_value", nameAndClass.mvalue);			
			return str;
		}
	}
	
}