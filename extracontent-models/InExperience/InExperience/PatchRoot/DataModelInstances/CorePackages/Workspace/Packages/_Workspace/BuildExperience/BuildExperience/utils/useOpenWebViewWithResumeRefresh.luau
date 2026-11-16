local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView

local function useOpenWebViewWithResumeRefresh(p: string, p2: string, callback, p3)
	local v = useOpenWebView()
	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local v2 = React.useCallback(function()
		if not ref.current then
			return
		end

		ref.current = false

		if callback ~= nil then
			callback()
		end
	end, { callback })
	local v3 = React.useCallback(function()
		if not ref2.current then
			return
		end

		ref2.current = false
		ref.current = false

		if callback ~= nil then
			callback()
		end
	end, { callback })

	React.useEffect(function()
		if callback == nil then
			return function() end
		end

		local onUnhideConnection = (p3 or AppLifecycleObserverService).OnUnhide:Connect(v2)
		return function()
			ref.current = false
			ref2.current = false
			onUnhideConnection:Disconnect()
		end
	end, { p3, v2, callback })

	return React.useCallback(function()
		ref.current = callback ~= nil
		ref2.current = callback ~= nil
		local v4

		if callback ~= nil then
			v4 = v3
		end

		v(p, p2, v4)
	end, { v3, callback, v, p2, p })
end

return useOpenWebViewWithResumeRefresh
