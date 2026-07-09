local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode

local function useExperienceDetailsConfiguration() -- line: 8
	-- upvalues: useUiModeInfo (copy), UiMode (copy), React (copy), IsVRAppBuild (copy)
	local v7 = useUiModeInfo().uiMode == UiMode.TenFoot

	return (React.useMemo(function() -- line: 12
		-- upvalues: v7 (copy), IsVRAppBuild (copy)
		return {
			showLogoTraySection = not v7,
			showEventsList = not v7,
			showCommunityLink = not v7 and not IsVRAppBuild(),
			showCornerGradientPropEnabled = v7
		}
	end, { v7 }))
end

return useExperienceDetailsConfiguration
