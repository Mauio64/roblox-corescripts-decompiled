local CorePackages = game:GetService("CorePackages")
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
local FocusRoot = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusRoot
local React = require(CorePackages.Packages.React)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local FocusNavigableSurfaceIdentifierEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigableSurfaceIdentifierEnum
local DeviceType = RobloxAppEnums.DeviceType

function OverscanWrapper(p1) -- line: 15
	-- upvalues: DeviceType (copy), React (copy), CoreScriptsRootProvider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	return function(p2) -- line: 16
		-- upvalues: DeviceType (copy), React (copy), CoreScriptsRootProvider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), p1 (copy)
		local t1 = {
			deviceType = DeviceType.Console
		}

		return React.createElement(CoreScriptsRootProvider, {
			styleOverride = t1
		}, {
			FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
				isIsolated = true,
				isAutoFocusRoot = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
			}, {
				Overscan = React.createElement(p1, p2)
			})
		})
	end
end

return OverscanWrapper
