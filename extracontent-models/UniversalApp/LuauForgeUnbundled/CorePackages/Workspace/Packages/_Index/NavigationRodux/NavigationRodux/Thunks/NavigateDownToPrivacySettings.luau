local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/ArgCheck")
local NavigateDown = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/NavigateDown")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppEnums")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/UrlBuilder")

local appPage = RobloxAppEnums.AppPage
local urlBuilder = UrlBuilder.UrlBuilder

return function(onClose)
	ArgCheck.isTypeOrNil(onClose, "function", "onClose")

	return NavigateDown({
		name = appPage.SettingsSubPage,
		detail = urlBuilder.static.settings.privacy(),
		extraProps = {
			titleKey = "Feature.AccountSettings.Heading.Tab.Privacy",
			onClose = onClose
		}
	})
end
