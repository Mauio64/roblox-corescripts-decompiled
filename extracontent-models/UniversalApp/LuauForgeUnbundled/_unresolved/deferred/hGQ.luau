local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dMA")
local appBtidLayers = module.AppBtidLayers
local appUserLayers = module.AppUserLayers

local module2 = require("@luauforge/deferred/hGR")

local useTTINavigationTracking = require("@luauforge/bundled/fwS").useTTINavigationTracking

local fFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled

local logCTAChangeMorePageFlyoutButtonTextExposure = require("@luauforge/bundled/fsS").Utils.logCTAChangeMorePageFlyoutButtonTextExposure

return function()
	useTTINavigationTracking("NavigateTo_More")

	React.useEffect(function()
		IXPService:LogUserLayerExposure(appUserLayers.MorePageExposureLayer)
	end, {})

	React.useEffect(function()
		IXPService:LogBrowserTrackerLayerExposure(appBtidLayers.AccountSwitcherLayer)
	end, {})

	if fFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled then
		React.useEffect(function()
			if logCTAChangeMorePageFlyoutButtonTextExposure then
				logCTAChangeMorePageFlyoutButtonTextExposure()
			end
		end, {})
	end

	return Roact.createElement(module2)
end
