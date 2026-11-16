local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local useEffect = React.useEffect
local useCallback = React.useCallback
local useRef = React.useRef

local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/SharedFlags").GetFFlagEnableUnifiedWebViews

local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")

local function useWebView(p2, p3)
	local v5 = useRef(nil)

	local v6 = useCallback(function()
		if v5.current then
			v5.current:Disconnect()
			v5.current = nil
		end
	end, { v5 })

	local v7 = useCallback(function()
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

		v6()

		v5.current = WebViewService.OnWindowClosed:Connect(function()
			WebViewService:CloseWindow()
			v6()
		end)

		WebViewService:OpenWindow(p2, p3, true)
	end, { p2, p3, v6 })

	useEffect(function()
		return function()
			v6()
		end
	end, { v6 })

	return v7
end

return useWebView
