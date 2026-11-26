local module = require("@luauforge/bundled/dVn")

local v5 = {
	["webViewUrlAccountSettings"] = module.WWW_URL .. "my/account#!/security?src=authpopup",
	webViewUrlEmailHighlight = module.WWW_URL .. "my/account#!/security?src=emailhighlight",
	webViewUrlHelpPage = "https://en.help.roblox.com/hc/articles/212459863"
}

function v5.getWebViewUrlAccountSettings()
	return v5.webViewUrlAccountSettings
end

function v5.getWebViewUrlEmailHighlight()
	return v5.webViewUrlEmailHighlight
end

function v5.getWebViewUrlHelpPage()
	return v5.webViewUrlHelpPage
end

return v5
