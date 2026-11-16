local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local ContentProvider = game:GetService("ContentProvider")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local useOpenWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/WebViewUtils").useOpenWebView

local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local function getPurchaseRobuxUrl()
	local v5 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
	return `{string.gsub(v5, "http:", "https:")}upgrades/robux?ctx=build-uapp`
end

local function useOpenBuyRobuxWebView(callback, p2)
	local title = useLocalization({
		title = LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_SHEET_TITLE
	}).title
	local v5 = useOpenWebView()
	local ref = React.useRef(false)
	local v6 = React.useCallback(function()
		if not ref.current then
			return
		end

		ref.current = false

		if callback then
			callback()
		end
	end, { callback })

	React.useEffect(function()
		if callback == nil then
			return function() end
		end

		local onUnhideConnection = (p2 or AppLifecycleObserverService).OnUnhide:Connect(v6)
		return function()
			ref.current = false
			onUnhideConnection:Disconnect()
		end
	end, { p2, v6, callback })

	return React.useCallback(function()
		ref.current = callback ~= nil
		local v8 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
		local formatted = `{string.gsub(v8, "http:", "https:")}upgrades/robux?ctx=build-uapp`
		local v10 = if callback ~= nil then v6 else nil
		v5(formatted, title, v10)
	end, { v6, callback, v5, title })
end

return useOpenBuyRobuxWebView
