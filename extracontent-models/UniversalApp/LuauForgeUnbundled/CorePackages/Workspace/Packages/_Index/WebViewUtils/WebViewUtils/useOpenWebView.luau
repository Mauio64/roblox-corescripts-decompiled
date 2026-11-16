local React = require("@game/CorePackages/Workspace/Packages/_Workspace/WebViewUtils/React")
local useEffect = React.useEffect
local useCallback = React.useCallback
local useRef = React.useRef

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/WebViewUtils/SharedFlags")
local getFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews
local fFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab

local FFlagUseWebViewSessionInOpenWebView = require("@game/CorePackages/Workspace/Packages/_Index/WebViewUtils/WebViewUtils/Flags/FFlagUseWebViewSessionInOpenWebView")
local openWebViewSession = require("@game/CorePackages/Workspace/Packages/_Index/WebViewUtils/WebViewUtils/openWebViewSession")

local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")

local function useOpenWebView()
	local v5 = useRef(nil)
	local v6 = useRef(nil)

	local v7 = useCallback(function()
		if v5.current then
			v5.current:Disconnect()
			v5.current = nil
		end

		if v6.current then
			v6.current()
			v6.current = nil
		end
	end, { v5, v6 })

	local v8 = useCallback(function(p2, p3, callback)
		if FFlagUseWebViewSessionInOpenWebView then
			v7()

			if not fFlagAppNavMyStatsTab then
				callback = nil
			end

			local v10, v11 = openWebViewSession(p2, p3, callback)
			v6.current = v11
		else
			if not getFFlagEnableUnifiedWebViews() then
				BrowserService:SendCommand(HttpService:JSONEncode({
					command = "open",
					url = p2,
					title = p3,
					visible = true,
					isGenericWebview = true,
					enableOverlayReplacement = true
				}))

				return
			end

			v7()

			v5.current = WebViewService.OnWindowClosed:Connect(function()
				WebViewService:CloseWindow()
				v7()

				if fFlagAppNavMyStatsTab and callback then
					callback()
				end
			end)

			WebViewService:OpenWindow(p2, p3, true)
		end
	end, { v7 })

	useEffect(function()
		return function()
			v7()
		end
	end, { v7 })

	return v8
end

return useOpenWebView
