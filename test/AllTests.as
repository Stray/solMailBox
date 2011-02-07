package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
//	import model.UndoableNoteTest;
//	import ObjectReferenceTest;
//	import solmailboxclient.controller.MessageSignalTest;
//	import solmailboxclient.model.MailBoxTest;
//	import solmailboxclient.model.MailMessageTest;
//	import solmailboxclient.model.MessageStatusTest;
//	import solmailboxclient.model.SolMailBoxTest;
	import solmailboxclient.service.MailMonitorTest;
//	import view.NotebookTest;
//	import view.NotebookViewTest;
//	import xend_to_end.NotebookSavesLocallyEndToEndTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
//			addTest(new model.UndoableNoteTest());
//			addTest(new ObjectReferenceTest());
//			addTest(new solmailboxclient.controller.MessageSignalTest());
//			addTest(new solmailboxclient.model.MailBoxTest());
//			addTest(new solmailboxclient.model.MailMessageTest());
//			addTest(new solmailboxclient.model.MessageStatusTest());
//			addTest(new solmailboxclient.model.SolMailBoxTest());
			addTest(new solmailboxclient.service.MailMonitorTest());
//			addTest(new view.NotebookTest());
//			addTest(new view.NotebookViewTest());
//			addTest(new xend_to_end.NotebookSavesLocallyEndToEndTest());
		}
	}
}
