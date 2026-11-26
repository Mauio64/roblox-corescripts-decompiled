local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useOpenWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/WebViewUtils").useOpenWebView

local function useOpenWebViewWithResumeRefresh(p2, p3, callback, p4)
	local v5 = useOpenWebView()
	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local v6 = React.useCallback(function()
		if not ref.current then
			return
		end

		ref.current = false

		if callback ~= nil then
			callback()
		end
	end, { callback })
	local v7 = React.useCallback(function()
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

		local onUnhideConnection = (p4 or AppLifecycleObserverService).OnUnhide:Connect(v6)
		return function()
			ref.current = false
			ref2.current = false
			onUnhideConnection:Disconnect()
		end
	end, { p4, v6, callback })

	return React.useCallback(function()
		ref.current = callback ~= nil
		ref2.current = callback ~= nil
		local v11 = if callback ~= nil then v7 else nil
		v5(p2, p3, v11)
	end, { v7, callback, v5, p3, p2 })
end

return useOpenWebViewWithResumeRefresh
