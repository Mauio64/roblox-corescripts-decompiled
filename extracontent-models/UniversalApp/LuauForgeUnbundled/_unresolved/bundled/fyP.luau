local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local useProperty = require("@luauforge/bundled/fyQ").useProperty
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local uiMode = RobloxAppEnums.UiMode

local module3 = require("@luauforge/bundled/fyR")
local module4 = require("@luauforge/bundled/fyV")
local clientCacheFallbackBanner = require("@luauforge/bundled/fzV").ClientCacheFallbackBanner

local function hasMultipleBanners(...): boolean
	local count = 0

	for k, v5 in { ... } do
		if v5 then
			count += 1
		end
	end

	return count > 1
end

return function(props)
	local v5 = useDesignTokens()
	local v6 = useUiModeInfo().uiMode ~= uiMode.TenFoot
	local banner = v5.LuaApps.Banner

	local showSecurityBanner = props.showSecurityBanner
	local showSiteMessageBanner = props.showSiteMessageBanner
	local v7

	if props.clientCacheFallbackBannerConfig then
		v7 = props.clientCacheFallbackBannerConfig.shouldShowBanner or false
	else
		v7 = false
	end

	local securityBanner = banner.securityBanner
	local siteMessageBanner = banner.siteMessageBanner

	local height = showSecurityBanner and securityBanner.height or 0
	local height2 = siteMessageBanner.height or 0

	local v8 = not hasMultipleBanners(showSecurityBanner, showSiteMessageBanner, v7) and 0
		or banner.verticalPadding

	local ref = React.useRef(nil)
	local v9 = useProperty(ref, "AbsoluteSize")

	local onSizeChanged = props.onSizeChanged
	React.useLayoutEffect(function()
		if onSizeChanged and v9 then
			onSizeChanged(v9)
		end
	end, { v9, onSizeChanged })

	local createElement = React.createElement
	local v11 = {
		Size = props.Size or UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = props.Position,
		BackgroundTransparency = 1,
		ref = ref
	}

	local v12 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v8)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, banner.leftMargin),
			PaddingRight = UDim.new(0, banner.rightMargin),
			PaddingTop = UDim.new(0, banner.topMargin),
			PaddingBottom = UDim.new(0, banner.bottomMargin)
		}),
		SiteMessageBanner = 0,
		AccountSecurityPromptBanner = 0,
		ClientCacheFallbackBanner = 0
	}

	local v13 = if showSiteMessageBanner then React.createElement(module3, {
		Size = UDim2.new(1, 0, 0, height2),
		LayoutOrder = 1
	}) else nil
	v12.SiteMessageBanner = v13

	v12.AccountSecurityPromptBanner = React.createElement(module4, {
		isInteractive = v6,
		Size = UDim2.new(1, 0, 0, height),
		LayoutOrder = 2
	})

	local v14 = if v7 and props.clientCacheFallbackBannerConfig then React.createElement(clientCacheFallbackBanner, {
		LayoutOrder = 3,
		onRefreshButtonClick = props.clientCacheFallbackBannerConfig.onRefreshButtonClick
	}) else nil
	v12.ClientCacheFallbackBanner = v14
	return createElement("Frame", v11, v12)
end
