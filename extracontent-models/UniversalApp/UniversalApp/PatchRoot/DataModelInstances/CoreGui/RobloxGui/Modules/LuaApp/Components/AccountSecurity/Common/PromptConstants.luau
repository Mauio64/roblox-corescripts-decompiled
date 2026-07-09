local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local t1 = {
	webViewUrlAccountSettings = Url.WWW_URL .. "my/account#!/security?src=authpopup",
	webViewUrlEmailHighlight = Url.WWW_URL .. "my/account#!/security?src=emailhighlight",
	webViewUrlHelpPage = "https://en.help.roblox.com/hc/articles/212459863"
}

function t1.getWebViewUrlAccountSettings() -- line: 15
	-- upvalues: t1 (copy)
	return t1.webViewUrlAccountSettings
end
function t1.getWebViewUrlEmailHighlight() -- line: 19
	-- upvalues: t1 (copy)
	return t1.webViewUrlEmailHighlight
end
function t1.getWebViewUrlHelpPage() -- line: 23
	-- upvalues: t1 (copy)
	return t1.webViewUrlHelpPage
end

return t1
