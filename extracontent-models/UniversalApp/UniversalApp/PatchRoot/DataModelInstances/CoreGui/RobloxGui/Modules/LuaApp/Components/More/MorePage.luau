local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local ExperimentLayers = require(CorePackages.Workspace.Packages.ExperimentLayers)
local AppBtidLayers = ExperimentLayers.AppBtidLayers
local AppUserLayers = ExperimentLayers.AppUserLayers
local MorePageGridLayout = require(Modules.LuaApp.Components.More.MorePageGridLayout)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableAccountSwitcherIxpExposureGating = SharedFlags.FFlagEnableAccountSwitcherIxpExposureGating
local useTTINavigationTracking = require(CorePackages.Workspace.Packages.TTINavigationTracking).useTTINavigationTracking

return function() -- line: 16
	-- upvalues: SharedFlags (copy), useTTINavigationTracking (copy), React (copy), IXPService (copy), AppUserLayers (copy), FFlagEnableAccountSwitcherIxpExposureGating (copy), AppBtidLayers (copy), Roact (copy), MorePageGridLayout (copy)
	if SharedFlags.FFlagLuaAppNavigationTTITracking then
		useTTINavigationTracking("NavigateTo_More")
	end

	React.useEffect(function() -- line: 22
		-- upvalues: IXPService (copy), AppUserLayers (copy)
		IXPService:LogUserLayerExposure(AppUserLayers.MorePageExposureLayer)
	end, {})
	React.useEffect(function() -- line: 26
		-- upvalues: FFlagEnableAccountSwitcherIxpExposureGating (copy), IXPService (copy), AppBtidLayers (copy)
		if FFlagEnableAccountSwitcherIxpExposureGating then
			IXPService:LogBrowserTrackerLayerExposure(AppBtidLayers.AccountSwitcherLayer)
		end
	end, {})

	return Roact.createElement(MorePageGridLayout)
end
