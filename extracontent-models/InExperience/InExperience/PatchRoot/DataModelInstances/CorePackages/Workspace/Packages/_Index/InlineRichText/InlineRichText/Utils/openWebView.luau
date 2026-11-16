local parent = script:FindFirstAncestor("InlineRichText").Parent

local WebViewService = game:GetService("WebViewService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews

local function openWebView(url: string)
	if not GetFFlagEnableUnifiedWebViews() then
		BrowserService:SendCommand(HttpService:JSONEncode({
			command = "open",
			url = url,
			title = "",
			visible = true,
			isGenericWebview = true,
			enableOverlayReplacement = true
		}))

		return
	end

	local onWindowClosedConnection = nil

	onWindowClosedConnection = WebViewService.OnWindowClosed:Connect(function()
		WebViewService:CloseWindow()

		if onWindowClosedConnection then
			onWindowClosedConnection:Disconnect()
			onWindowClosedConnection = nil
		end
	end)
	WebViewService:OpenWindow(url, "", true)
end

return openWebView
