local t1 = {
	preScreenshot = function() -- line: 2
	end,
	postScreenshot = function() -- line: 3
	end
}

return {
	setPreScreenshotHook = function(p1) -- line: 7
		-- upvalues: t1 (copy)
		t1.preScreenshot = p1
	end,
	setPostScreenshotHook = function(p2) -- line: 10
		-- upvalues: t1 (copy)
		t1.postScreenshot = p2
	end,
	doPreScreenshot = function() -- line: 13
		-- upvalues: t1 (copy)
		t1.preScreenshot()
	end,
	doPostScreenshot = function() -- line: 16
		-- upvalues: t1 (copy)
		t1.postScreenshot()
	end
}
