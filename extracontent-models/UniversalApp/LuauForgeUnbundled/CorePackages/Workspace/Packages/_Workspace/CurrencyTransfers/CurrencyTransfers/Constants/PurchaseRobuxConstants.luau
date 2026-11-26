local ContentProvider = game:GetService("ContentProvider")

return {
	getPurchaseRobuxUrl = function()
		local v5 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
		return string.gsub(v5, "http:", "https:") .. "upgrades/robux?ctx=navpopover"
	end,
	PURCHASE_ROBUX_WEBVIEW_TITLE = "Buy Robux"
}
