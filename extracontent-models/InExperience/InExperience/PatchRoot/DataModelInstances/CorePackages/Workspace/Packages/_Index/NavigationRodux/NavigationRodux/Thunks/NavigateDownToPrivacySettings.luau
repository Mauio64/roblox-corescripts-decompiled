local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent

local ArgCheck = require(parent.ArgCheck)
local NavigateDown = require(NavigationRodux.Thunks.NavigateDown)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UrlBuilder = require(parent.UrlBuilder)

local AppPage = RobloxAppEnums.AppPage
local urlBuilder = UrlBuilder.UrlBuilder

return function(onClose)
	ArgCheck.isTypeOrNil(onClose, "function", "onClose")

	return NavigateDown({
		name = AppPage.SettingsSubPage,
		detail = urlBuilder.static.settings.privacy(),
		extraProps = { titleKey = "Feature.AccountSettings.Heading.Tab.Privacy", onClose = onClose }
	})
end
