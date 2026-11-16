local getFFlagUseCommunitiesTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/SharedFlags").GetFFlagUseCommunitiesTranslation

local NavigateDown = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/NavigateDown")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppEnums")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/UrlBuilder")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/t")

local appPage = RobloxAppEnums.AppPage
local urlBuilder = UrlBuilder.UrlBuilder

return function(onClose)
	assert(t.callback(onClose) or t.none(onClose), "")
	return NavigateDown({
		name = appPage.GenericWebPage,
		detail = urlBuilder.static.groups(),
		extraProps = {
			titleKey = getFFlagUseCommunitiesTranslation() and "CommonUI.Features.Label.Groups" or "CommonUI.Features.Label.sGroups",
			onClose = onClose
		}
	})
end
