local Parent = script:FindFirstAncestor("InlineRichText").Parent
local WebViewService = game:GetService("WebViewService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local GetFFlagEnableUnifiedWebViews = require(Parent.SharedFlags).GetFFlagEnableUnifiedWebViews

local function openWebView(s1: string) -- line: 10
	-- upvalues: GetFFlagEnableUnifiedWebViews (copy), WebViewService (copy), BrowserService (copy), HttpService (copy)
	if GetFFlagEnableUnifiedWebViews() then
		local u8 = nil

		u8 = WebViewService.OnWindowClosed:Connect(function() -- line: 14
			-- upvalues: WebViewService (copy), u8 (ref)
			WebViewService:CloseWindow()

			if u8 then
				u8:Disconnect()
				u8 = nil
			end
		end)
		WebViewService:OpenWindow(s1, "", true)

		return
	end

	BrowserService:SendCommand(HttpService:JSONEncode({
		command = "open",
		title = "",
		visible = true,
		isGenericWebview = true,
		enableOverlayReplacement = true,
		url = s1
	}))
end

return openWebView
