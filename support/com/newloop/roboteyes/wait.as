package com.newloop.roboteyes
{

	import com.newloop.roboteyes.core.Waiter;
	
	public function wait(waitSeconds:Number):Waiter
	{
		return Waiter.createWaiter(waitSeconds);
	}

}