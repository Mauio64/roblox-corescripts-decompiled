local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local BannerContainer = require(Modules.LuaApp.Components.Banner.BannerContainer)
local useShowSecurityBanner = require(Modules.LuaApp.Components.Banner.useShowSecurityBanner)
local useShowSiteMessageBanner = require(Modules.LuaApp.Components.Banner.useShowSiteMessageBanner)
local DiscoveryAvailability = require(CorePackages.Workspace.Packages.DiscoveryAvailability)
local ApiFetchOmniRecommendations = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendations
local useClientCacheFallbackBannerConfig = DiscoveryAvailability.useClientCacheFallbackBannerConfig

local function useBannerContainer(b1: boolean?) -- line: 13
	-- upvalues: React (copy), useShowSecurityBanner (copy), useShowSiteMessageBanner (copy), useClientCacheFallbackBannerConfig (copy), ApiFetchOmniRecommendations (copy), BannerContainer (copy)
	local v12, v13 = React.useState(Vector2.zero)
	local v14 = useShowSecurityBanner()
	local u15 = useShowSiteMessageBanner()
	local v16 = useClientCacheFallbackBannerConfig(ApiFetchOmniRecommendations)

	if b1 then
		u15 = false
	end

	return React.useMemo(function() -- line: 24
		-- upvalues: React (copy), BannerContainer (copy), u15 (ref), v14 (copy), v16 (copy), v13 (copy)
		return React.createElement(BannerContainer, {
			showSiteMessageBanner = u15,
			showSecurityBanner = v14,
			clientCacheFallbackBannerConfig = v16,
			onSizeChanged = v13
		})
	end, {
		v14,
		u15,
		v16,
		v12
	}), v12.Y
end

return useBannerContainer
