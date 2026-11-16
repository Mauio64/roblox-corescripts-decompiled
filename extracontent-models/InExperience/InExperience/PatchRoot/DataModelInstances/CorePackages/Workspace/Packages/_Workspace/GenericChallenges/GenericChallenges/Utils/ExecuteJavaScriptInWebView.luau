local BrowserService = game:GetService("BrowserService")

return {
	Execute = function(p: string, p2: string)
		BrowserService:ExecuteJavaScript("(function() { CoreRobloxUtilities.hybridResponseService.injectNativeResponse(" .. p .. ", " .. p2 .. "); })();")
	end
}
