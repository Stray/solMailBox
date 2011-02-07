package model {

	import asunit.framework.TestCase;

	public class UndoableNoteTest extends TestCase {
		private var undoableNote:UndoableNote; 
		
		private const ENTRIES:Array = ['1', '12', '123', '1234', '12345', '2345', '345', '45', '5']

		public function UndoableNoteTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			createUndoChain();
		}

		override protected function tearDown():void {
			super.tearDown();
			undoableNote = null;
		}

		public function testInstantiated():void {
			assertTrue("undoableNote is UndoableNote", undoableNote is UndoableNote);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
	   	public function test_undoChain_undoes_correctly():void {
	   	    
			var reverseEntries:Array = ENTRIES.slice().reverse();
	        trace("reverseEntries: " + reverseEntries);
	
			var iLength:uint = reverseEntries.length;
	   	    for (var i:int = 0; i < iLength; i++)
	   	    {
	   	    	assertEquals("finds correct value: " + i, reverseEntries[i], undoableNote.text);
				undoableNote = undoableNote.undoTo;
	   	    }

   	    	assertEquals("finds correct value once at end", reverseEntries[iLength-1], undoableNote.text);
			undoableNote = undoableNote.undoTo;
   	    	assertEquals("finds correct value once at end", reverseEntries[iLength-1], undoableNote.text);
			undoableNote = undoableNote.undoTo;
   	    	assertEquals("finds correct value once at end", reverseEntries[iLength-1], undoableNote.text);
	   	}
	
	 	public function test_undoChain_redoes_correctly():void {
			var iLength:uint = ENTRIES.length;
	   	    for (var i:int = 0; i < iLength; i++)
	   	    {
				undoableNote = undoableNote.undoTo;
	   	    }

			for (i = 0; i < iLength; i++)
	   	    {
	   	    	assertEquals("finds correct value: " + i, ENTRIES[i], undoableNote.text);
				undoableNote = undoableNote.redoTo;
	   	    }
	
	    	assertEquals("finds correct value once at end", ENTRIES[iLength-1], undoableNote.text);
			undoableNote = undoableNote.redoTo;
   	    	assertEquals("finds correct value once at end", ENTRIES[iLength-1], undoableNote.text);
			undoableNote = undoableNote.redoTo;
   	    	assertEquals("finds correct value once at end", ENTRIES[iLength-1], undoableNote.text);
   	
		}
		
		public function test_undoChain_is_edited_correctly():void {
	   	    
			var reverseEntries:Array = ENTRIES.slice().reverse();
	
			var iLength:uint = 3;
	   	    for (var i:int = 0; i < iLength; i++)
	   	    {
	   	    	assertEquals("finds correct value: " + i, reverseEntries[i], undoableNote.text);
				undoableNote = undoableNote.undoTo;
	   	    }
	 		
			undoableNote = new UndoableNote("a", undoableNote);
			undoableNote = new UndoableNote("ab", undoableNote);
			undoableNote = new UndoableNote("abc", undoableNote);
			
			var finalEntries:Array = ENTRIES.slice().reverse();
			finalEntries.unshift("a");
			finalEntries.unshift("ab");
			finalEntries.unshift("abc");
			
			var jLength:uint = finalEntries.length;
	   	    for (var j:int = 0; j < iLength; j++)
	   	    {
	   	    	assertEquals("finds correct value: " + j,  finalEntries[j], undoableNote.text);
				undoableNote = undoableNote.undoTo;
	   	    }
	 
	   	} 
	
	
	
		protected function createUndoChain():void
		{
			var iLength:uint = ENTRIES.length;
			for (var i:int = 0; i < iLength; i++)
			{
				undoableNote = new UndoableNote(ENTRIES[i], undoableNote);
			}
		}
	   	
		
	}
}