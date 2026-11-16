local WebViewService = game:GetService("WebViewService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")

local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/SharedFlags").GetFFlagEnableUnifiedWebViews

local function openWebView(p2)
	if not getFFlagEnableUnifiedWebViews() then
		BrowserService:SendCommand(HttpService:JSONEncode({
			command = "open",
			url = p2,
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
	WebViewService:OpenWindow(p2, "", true)
end

return openWebView
