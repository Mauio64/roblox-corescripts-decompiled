local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local function useExperienceDetailsConfiguration()
	local v5 = useUiModeInfo().uiMode == uiMode.TenFoot

	return (React.useMemo(function()
		return {
			showLogoTraySection = not v5,
			showEventsList = not v5,
			showCommunityLink = not (v5 or isVRAppBuild()),
			showCornerGradientPropEnabled = v5
		}
	end, { v5 }))
end

return useExperienceDetailsConfiguration
