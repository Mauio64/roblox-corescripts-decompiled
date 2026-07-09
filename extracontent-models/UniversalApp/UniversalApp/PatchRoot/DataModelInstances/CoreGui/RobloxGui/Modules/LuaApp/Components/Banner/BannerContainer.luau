local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local useProperty = require(CorePackages.Workspace.Packages.GuiObjectUtils).useProperty
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local UiMode = RobloxAppEnums.UiMode
local SiteMessageBanner = require(Modules.LuaApp.Components.SiteMessageBanner)
local PromptBannerV2 = require(Modules.LuaApp.Components.AccountSecurity.PromptBannerV2)
local ClientCacheFallbackBanner = require(CorePackages.Workspace.Packages.DiscoveryAvailability).ClientCacheFallbackBanner

local function hasMultipleBanners(...) -- line: 32
	local n1 = 0

	for _, v16 in { ... } do
		if v16 then
			n1 += 1
		end
	end

	return n1 > 1
end

return function(t1: {[any]: any}) -- line: 43
	-- upvalues: useDesignTokens (copy), useUiModeInfo (copy), UiMode (copy), hasMultipleBanners (copy), React (copy), useProperty (copy), SiteMessageBanner (copy), PromptBannerV2 (copy), ClientCacheFallbackBanner (copy)
	local v18 = useDesignTokens()
	local v19 = useUiModeInfo().uiMode ~= UiMode.TenFoot
	local Banner = v18.LuaApps.Banner
	local showSecurityBanner = t1.showSecurityBanner
	local showSiteMessageBanner = t1.showSiteMessageBanner
	local v23 = not not t1.clientCacheFallbackBannerConfig and (t1.clientCacheFallbackBannerConfig.shouldShowBanner or false)
	local securityBanner = Banner.securityBanner
	local siteMessageBanner = Banner.siteMessageBanner
	local v26 = not showSecurityBanner and 0 or (securityBanner.height or 0)
	local v27 = siteMessageBanner.height or 0
	local v28 = not hasMultipleBanners(showSecurityBanner, showSiteMessageBanner, v23) and 0 or Banner.verticalPadding
	local v29 = React.useRef(nil)
	local v30 = useProperty(v29, "AbsoluteSize")
	local onSizeChanged = t1.onSizeChanged

	React.useLayoutEffect(function() -- line: 69
		-- upvalues: onSizeChanged (copy), v30 (copy)
		if onSizeChanged and v30 then
			onSizeChanged(v30)
		end
	end, {
		v30,
		onSizeChanged
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = t1.Size or UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = t1.Position,
		ref = v29
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v28)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, Banner.leftMargin),
			PaddingRight = UDim.new(0, Banner.rightMargin),
			PaddingTop = UDim.new(0, Banner.topMargin),
			PaddingBottom = UDim.new(0, Banner.bottomMargin)
		}),
		SiteMessageBanner = if not showSiteMessageBanner then nil else React.createElement(SiteMessageBanner, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v27)
		}),
		AccountSecurityPromptBanner = React.createElement(PromptBannerV2, {
			LayoutOrder = 2,
			isInteractive = v19,
			Size = UDim2.new(1, 0, 0, v26)
		}),
		ClientCacheFallbackBanner = if not v23 or not t1.clientCacheFallbackBannerConfig then nil else React.createElement(ClientCacheFallbackBanner, {
			LayoutOrder = 3,
			onRefreshButtonClick = t1.clientCacheFallbackBannerConfig.onRefreshButtonClick
		})
	})
end
