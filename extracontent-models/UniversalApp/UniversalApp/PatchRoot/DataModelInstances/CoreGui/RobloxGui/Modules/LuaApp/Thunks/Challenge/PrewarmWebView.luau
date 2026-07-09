local Modules = game:GetService("CoreGui").RobloxGui.Modules
local BrowserService = game:GetService("BrowserService")
local WebViewService = game:GetService("WebViewService")
local HttpService = game:GetService("HttpService")
local Url = require(Modules.LuaApp.Http.Url)
local GetFFlagLuaAppUseStaticCdnUrlForChallengeHybridWebView = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseStaticCdnUrlForChallengeHybridWebView)
local GetFFlagEnableUnifiedStaticWebViews = require(Modules.LuaApp.Flags.GetFFlagEnableUnifiedStaticWebViews)
local t1 = {}

local function cleanup() -- line: 14
	-- upvalues: t1 (copy), GetFFlagEnableUnifiedStaticWebViews (copy), WebViewService (copy), BrowserService (copy)
	for _, v in ipairs(t1) do
		v:Disconnect()
	end

	table.clear(t1)

	if GetFFlagEnableUnifiedStaticWebViews() then
		WebViewService:CloseWindow()

		return
	end

	BrowserService:CloseBrowserWindow()
end

return {
	init = function() -- line: 29
		-- upvalues: GetFFlagEnableUnifiedStaticWebViews (copy), t1 (copy), WebViewService (copy), cleanup (copy), BrowserService (copy), GetFFlagLuaAppUseStaticCdnUrlForChallengeHybridWebView (copy), Url (copy), HttpService (copy)
		if GetFFlagEnableUnifiedStaticWebViews() then
			table.insert(t1, WebViewService.OnWindowClosed:Connect(cleanup))
			table.insert(t1, WebViewService.OnJavaScriptCall:Connect(cleanup))
		else
			table.insert(t1, BrowserService.BrowserWindowClosed:Connect(function() -- line: 35
			end))
			table.insert(t1, BrowserService.JavaScriptCallback:Connect(cleanup))
		end

		local v12 = (GetFFlagLuaAppUseStaticCdnUrlForChallengeHybridWebView() and Url.STATIC_CDN_URL or Url.WWW_URL) .. "challenge/cdn/hybrid"

		if GetFFlagEnableUnifiedStaticWebViews() then
			WebViewService:OpenWindow(v12, "Prewarm WebView", false)

			return
		end

		local json = HttpService:JSONEncode({
			command = "open",
			title = "Prewarm WebView",
			visible = false,
			modal = true,
			isGenericWebview = true,
			enableOverlayReplacement = false,
			displayOrder = -2000,
			url = v12
		})

		BrowserService:SendCommand(json)
	end,
	cleanup = cleanup
}
