local Parent = script:FindFirstAncestor("WebViewUtils").Parent
local React = require(Parent.React)
local useEffect = React.useEffect
local useCallback = React.useCallback
local useRef = React.useRef
local SharedFlags = require(Parent.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")

local function useOpenWebView() -- line: 25
	-- upvalues: useRef (copy), useCallback (copy), GetFFlagEnableUnifiedWebViews (copy), WebViewService (copy), FFlagAppNavMyStatsTab (copy), BrowserService (copy), HttpService (copy), useEffect (copy)
	local v13 = useRef(nil)
	local v14 = useCallback(function() -- line: 28
		-- upvalues: v13 (copy)
		if v13.current then
			v13.current:Disconnect()
			v13.current = nil
		end
	end, { v13 })
	local v15 = useCallback(function(s1: string, s2: string, p1: ((...any) -> ...any)?) -- line: 35
		-- upvalues: GetFFlagEnableUnifiedWebViews (copy), v14 (copy), v13 (copy), WebViewService (copy), FFlagAppNavMyStatsTab (copy), BrowserService (copy), HttpService (copy)
		if GetFFlagEnableUnifiedWebViews() then
			v14()
			v13.current = WebViewService.OnWindowClosed:Connect(function() -- line: 41
				-- upvalues: WebViewService (copy), v14 (copy), FFlagAppNavMyStatsTab (copy), p1 (copy)
				WebViewService:CloseWindow()
				v14()

				if FFlagAppNavMyStatsTab and p1 then
					p1()
				end
			end)
			WebViewService:OpenWindow(s1, s2, true)

			return
		end

		BrowserService:SendCommand(HttpService:JSONEncode({
			command = "open",
			visible = true,
			isGenericWebview = true,
			enableOverlayReplacement = true,
			url = s1,
			title = s2
		}))
	end, { v14 })

	useEffect(function() -- line: 63
		-- upvalues: v14 (copy)
		return function() -- line: 64
			-- upvalues: v14 (copy)
			v14()
		end
	end, { v14 })

	return v15
end

return useOpenWebView
