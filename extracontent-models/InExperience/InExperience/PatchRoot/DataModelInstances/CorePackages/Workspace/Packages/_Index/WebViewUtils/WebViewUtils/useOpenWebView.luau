local parent = script:FindFirstAncestor("WebViewUtils").Parent

local React = require(parent.React)
local useEffect = React.useEffect
local useCallback = React.useCallback
local useRef = React.useRef

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab

local FFlagUseWebViewSessionInOpenWebView = require(script.Parent.Flags.FFlagUseWebViewSessionInOpenWebView)
local openWebViewSession = require(script.Parent.openWebViewSession)

local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")

local function useOpenWebView()
	local v = useRef(nil)
	local v2 = useRef(nil)

	local v3 = useCallback(function()
		if v.current then
			v.current:Disconnect()
			v.current = nil
		end

		if v2.current then
			v2.current()
			v2.current = nil
		end
	end, { v, v2 })

	local v4 = useCallback(function(url: string, title: string, callback)
		if FFlagUseWebViewSessionInOpenWebView then
			v3()

			if not FFlagAppNavMyStatsTab then
				callback = nil
			end

			local _, current = openWebViewSession(url, title, callback)
			v2.current = current
		else
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

			v3()

			v.current = WebViewService.OnWindowClosed:Connect(function()
				WebViewService:CloseWindow()
				v3()

				if FFlagAppNavMyStatsTab and callback then
					callback()
				end
			end)

			WebViewService:OpenWindow(url, title, true)
		end
	end, { v3 })

	useEffect(function()
		return function()
			v3()
		end
	end, { v3 })

	return v4
end

return useOpenWebView
