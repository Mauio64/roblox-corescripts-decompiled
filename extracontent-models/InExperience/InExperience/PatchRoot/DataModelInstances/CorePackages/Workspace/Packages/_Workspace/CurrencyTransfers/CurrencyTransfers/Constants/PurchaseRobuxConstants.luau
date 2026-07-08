local ContentProvider = game:GetService("ContentProvider")

return {
	PURCHASE_ROBUX_WEBVIEW_TITLE = "Buy Robux",
	getPurchaseRobuxUrl = function() -- line: 6
		-- upvalues: ContentProvider (copy)
		local v2 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")

		return string.gsub(v2, "http:", "https:") .. "upgrades/robux?ctx=navpopover"
	end
}
