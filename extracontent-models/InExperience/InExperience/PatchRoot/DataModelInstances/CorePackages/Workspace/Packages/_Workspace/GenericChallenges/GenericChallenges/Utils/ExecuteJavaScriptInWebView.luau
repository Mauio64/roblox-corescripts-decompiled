local BrowserService = game:GetService("BrowserService")

return {
	Execute = function(s1: string, s2: string) -- line: 5
		-- upvalues: BrowserService (copy)
		local v4 = "(function() { CoreRobloxUtilities.hybridResponseService.injectNativeResponse(" .. s1 .. ", " .. s2 .. "); })();"

		BrowserService:ExecuteJavaScript(v4)
	end
}
