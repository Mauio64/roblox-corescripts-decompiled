local CorePackages = game:GetService("CorePackages")
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider

local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot

local React = require(CorePackages.Packages.React)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)

local FocusNavigationUtils2 = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils2.FocusNavigableSurfaceIdentifierEnum

local DeviceType = RobloxAppEnums.DeviceType

function OverscanWrapper(p)
	return function(p2)
		local styleOverride = { deviceType = DeviceType.Console }

		return React.createElement(CoreScriptsRootProvider, { styleOverride = styleOverride }, {
			FocusNavigationCoreScriptsWrapper = React.createElement(
				FocusRoot,
				{
					surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
					isIsolated = true,
					isAutoFocusRoot = true
				},
				{ Overscan = React.createElement(p, p2) }
			)
		})
	end
end

return OverscanWrapper
