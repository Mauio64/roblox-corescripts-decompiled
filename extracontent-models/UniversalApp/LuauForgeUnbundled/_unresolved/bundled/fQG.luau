local BrowserService = game:GetService("BrowserService")
local WebViewService = game:GetService("WebViewService")
local HttpService = game:GetService("HttpService")
local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

local module2 = require("@luauforge/bundled/fQH")

local module3 = require("@luauforge/bundled/fQI")

local connections = {}

local function cleanup()
	for i, connection in ipairs(connections) do
		connection:Disconnect()
	end

	table.clear(connections)

	if module3() then
		WebViewService:CloseWindow()
	else
		BrowserService:CloseBrowserWindow()
	end
end

return {
	init = function()
		if module3() then
			table.insert(connections, WebViewService.OnWindowClosed:Connect(cleanup))
			table.insert(connections, WebViewService.OnJavaScriptCall:Connect(cleanup))
		else
			table.insert(connections, BrowserService.BrowserWindowClosed:Connect(function() end))
			table.insert(connections, BrowserService.JavaScriptCallback:Connect(cleanup))
		end

		local v5 = (module2() and Url.STATIC_CDN_URL or Url.WWW_URL) .. "challenge/cdn/hybrid"

		if module3() then
			WebViewService:OpenWindow(v5, "Prewarm WebView", false)
			return
		end

		BrowserService:SendCommand((HttpService:JSONEncode({
			command = "open",
			url = v5,
			title = "Prewarm WebView",
			visible = false,
			modal = true,
			isGenericWebview = true,
			enableOverlayReplacement = false,
			displayOrder = -2000
		})))
	end,
	cleanup = cleanup
}
