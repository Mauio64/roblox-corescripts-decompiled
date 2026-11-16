local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/frv")
local module2 = require("@luauforge/bundled/fsC")
local module3 = require("@luauforge/bundled/fsD")
local module4 = require("@luauforge/bundled/fsB")
local apiFetchOmniRecommendations = require("@luauforge/bundled/dpZ").Modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendations
local useClientCacheFallbackBannerConfig = module4.useClientCacheFallbackBannerConfig
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableSduiHomePage

local function refreshSduiHomePage()
	local module5 = require("@luauforge/bundled/fsF")
	return module5.refreshHomePage(module5.HomeConstants.RequestIntent.ManualRefresh, nil, false)
end

local function useBannerContainer(p2)
	local state, setState = React.useState(Vector2.zero)
	local v5 = module2()
	local v6 = module3()
	local v9 = if fFlagLuaAppEnableSduiHomePage then refreshSduiHomePage else nil
	local v10 = useClientCacheFallbackBannerConfig(apiFetchOmniRecommendations, v9)

	if p2 then
		v6 = false
	end

	return React.useMemo(function()
		return React.createElement(module, {
			showSiteMessageBanner = v6,
			showSecurityBanner = v5,
			clientCacheFallbackBannerConfig = v10,
			onSizeChanged = setState
		})
	end, { v5, v6, v10, state }), state.Y
end

return useBannerContainer
