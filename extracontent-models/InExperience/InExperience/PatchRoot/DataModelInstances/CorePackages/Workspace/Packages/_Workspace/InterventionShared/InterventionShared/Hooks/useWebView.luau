local Parent = script:FindFirstAncestor("InterventionShared").Parent
local React = require(Parent.React)
local useEffect = React.useEffect
local useCallback = React.useCallback
local useRef = React.useRef
local GetFFlagEnableUnifiedWebViews = require(Parent.SharedFlags).GetFFlagEnableUnifiedWebViews
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")

local function useWebView(s1: string, s2: string) -- line: 20
	-- upvalues: useRef (copy), useCallback (copy), GetFFlagEnableUnifiedWebViews (copy), WebViewService (copy), BrowserService (copy), HttpService (copy), useEffect (copy)
	local v13 = useRef(nil)
	local v14 = useCallback(function() -- line: 23
		-- upvalues: v13 (copy)
		if v13.current then
			v13.current:Disconnect()
			v13.current = nil
		end
	end, { v13 })
	local v15 = useCallback(function() -- line: 30
		-- upvalues: GetFFlagEnableUnifiedWebViews (copy), v14 (copy), v13 (copy), WebViewService (copy), s1 (copy), s2 (copy), BrowserService (copy), HttpService (copy)
		if GetFFlagEnableUnifiedWebViews() then
			v14()
			v13.current = WebViewService.OnWindowClosed:Connect(function() -- line: 36
				-- upvalues: WebViewService (copy), v14 (copy)
				WebViewService:CloseWindow()
				v14()
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
	end, {
		s1,
		s2,
		v14
	})

	useEffect(function() -- line: 55
		-- upvalues: v14 (copy)
		return function() -- line: 56
			-- upvalues: v14 (copy)
			v14()
		end
	end, { v14 })

	return v15
end

return useWebView
