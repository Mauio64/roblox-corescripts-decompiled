local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

local v5 = {
	["webViewUrlAccountSettings"] = Url.WWW_URL .. "my/account#!/security?src=authpopup",
	webViewUrlEmailHighlight = Url.WWW_URL .. "my/account#!/security?src=emailhighlight",
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
