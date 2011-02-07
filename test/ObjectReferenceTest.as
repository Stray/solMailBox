package  {

	import asunit.framework.TestCase;
	import flash.utils.Dictionary;

	public class ObjectReferenceTest extends TestCase {

		public function ObjectReferenceTest(methodName:String=null) {
			super(methodName);
		}

		override protected function setUp():void {
			super.setUp();
		}

		override protected function tearDown():void {
			super.tearDown();
		}

		public function test_object():void {
			var obj:Object = {};  
			var nullObject:Object;
			var nullDate:Date;
			obj["test"]    = "test is a key!";
			obj[" "]       = "space is a key!";
			obj[null]      = "null is a key!";
			obj[undefined] = "undefined is a key!";
			obj[""]        = "Empty string is a key!";
			obj[nullObject]   = "null object is a key";
			obj[nullDate]   = "null date is a key";

			trace(obj["test"]);
			trace(obj["not a key"]); //Just as a test
			trace(obj[" "]);
			trace(obj[null]);   // Traces null date
			trace(obj['null']);  // Traces null date 
			trace(obj[undefined]);
			trace(obj[""]);
			trace(obj[nullObject]); // Traces null date 
			trace(obj[nullDate]); // Traces null date   
	
			/* output
	
				[trace] test is a key!
				[trace] undefined
				[trace] space is a key!
				[trace] null date is a key
				[trace] null date is a key
				[trace] undefined is a key!
				[trace] Empty string is a key!
				[trace] null date is a key
				[trace] null date is a key
	
			*/
	
			for (var v:* in obj)
			{
				trace("key: " + v + " -> " + obj[v]);
			} 
	
			/* output - note that keys are overwritten
	
				[trace] key:   -> space is a key!
				[trace] key: null -> null date is a key
				[trace] key: undefined -> undefined is a key!
				[trace] key: test -> test is a key!
				[trace] key:  -> Empty string is a key!
		
		   */
		} 

		public function test_dictionary():void {
			var dict:Dictionary = new Dictionary(); 
			var nullObject:Object;
			var nullDate:Date;

			dict["test"]    = "test is a key!";
			dict[" "]       = "space is a key!";
			dict[null]      = "null is a key!";
			dict[undefined] = "undefined is a key!";
			dict[""]        = "Empty string is a key!";
			dict[nullObject]   = "null object is a key";
			dict[nullDate]   = "null date is a key";
	
			trace(dict["test"]);
			trace(dict["not a key"]); //Just as a test
			trace(dict[" "]);
			trace(dict[null]);
			trace(dict['null']);
			trace(dict[undefined]);
			trace(dict[""]); 
			trace(dict[nullObject]); 
			trace(dict[nullDate]);
	
			for (var v:* in dict)
			{
				trace("key: " + v + " -> " + dict[v]);
			}
		} 
		
		public function test_vector_map():void {
			var v1:Vector.<uint> = new <uint>[1,2,3];
			trace(v1); 
			
			var v2:Vector.<uint> = v1.map(addFive, v1);
			trace(v2);
			trace("v1 post: " + v1);
		}             
		
		protected function addFive(item:uint, index:int, vector:Vector.<uint>):uint
		{
			return item+5;
		} 
		
	    public function test_array_map():void {
			var v1:Array = [1,2,3];
			trace(v1);
			var v2:Array = v1.map(addSix);
			trace(v2);
		}             
		
		protected function addSix(item:uint, index:int, array:Array):uint
		{
			return item+6;
		}  
		
		
	}
}