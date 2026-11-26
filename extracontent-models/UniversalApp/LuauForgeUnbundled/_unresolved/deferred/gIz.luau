local BrowserService = game:GetService("BrowserService")

return {
	Execute = function(p2, p3)
		BrowserService:ExecuteJavaScript("(function() { CoreRobloxUtilities.hybridResponseService.injectNativeResponse(" .. p2 .. ", " .. p3 .. "); })();")
	end
}
