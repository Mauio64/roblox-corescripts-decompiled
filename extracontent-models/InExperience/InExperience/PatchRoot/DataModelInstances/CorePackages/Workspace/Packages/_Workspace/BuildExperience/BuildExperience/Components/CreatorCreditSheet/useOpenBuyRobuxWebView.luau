local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local ContentProvider = game:GetService("ContentProvider")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView

local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local function getPurchaseRobuxUrl() -- 1 equivalent call inferred from this helper
	local v = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
	return `{string.gsub(v, "http:", "https:")}upgrades/robux?ctx=build-uapp`
end

local function useOpenBuyRobuxWebView(callback, p)
	local title = useLocalization({
		title = LocalizationStrings.CREATOR_CREDIT_BUY_ROBUX_SHEET_TITLE
	}).title
	local v = useOpenWebView()
	local ref = React.useRef(false)
	local v2 = React.useCallback(function()
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

		local onUnhideConnection = (p or AppLifecycleObserverService).OnUnhide:Connect(v2)
		return function()
			ref.current = false
			onUnhideConnection:Disconnect()
		end
	end, { p, v2, callback })

	return React.useCallback(function()
		ref.current = callback ~= nil
		local purchaseRobuxUrl = getPurchaseRobuxUrl() -- inferred equivalent call
		local v3

		if callback ~= nil then
			v3 = v2
		end

		v(purchaseRobuxUrl, title, v3)
	end, { v2, callback, v, title })
end

return useOpenBuyRobuxWebView
