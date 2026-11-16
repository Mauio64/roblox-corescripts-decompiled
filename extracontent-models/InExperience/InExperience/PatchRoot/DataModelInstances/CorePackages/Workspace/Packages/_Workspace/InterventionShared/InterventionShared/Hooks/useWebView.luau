local parent = script:FindFirstAncestor("InterventionShared").Parent

local React = require(parent.React)
local useEffect = React.useEffect
local useCallback = React.useCallback
local useRef = React.useRef

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews

local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")

local function useWebView(url: string, title: string)
	local v = useRef(nil)

	local v2 = useCallback(function()
		if v.current then
			v.current:Disconnect()
			v.current = nil
		end
	end, { v })

	local v3 = useCallback(function()
		if not GetFFlagEnableUnifiedWebViews() then
			BrowserService:SendCommand(HttpService:JSONEncode({
				command = "open",
				url = url,
				title = title,
				visible = true,
				isGenericWebview = true,
				enableOverlayReplacement = true
			}))

			return
		end

		v2()

		v.current = WebViewService.OnWindowClosed:Connect(function()
			WebViewService:CloseWindow()
			v2()
		end)

		WebViewService:OpenWindow(url, title, true)
	end, { url, title, v2 })

	useEffect(function()
		return function()
			v2()
		end
	end, { v2 })

	return v3
end

return useWebView
