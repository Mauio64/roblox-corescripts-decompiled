local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local ArgCheck = require(NavigationRoduxParent.ArgCheck)
local NavigateDown = require(NavigationRodux.Thunks.NavigateDown)
local RobloxAppEnums = require(NavigationRoduxParent.RobloxAppEnums)
local UrlBuilder = require(NavigationRoduxParent.UrlBuilder)
local AppPage = RobloxAppEnums.AppPage
local UrlBuilder2 = UrlBuilder.UrlBuilder

return function(p1) -- line: 12
	-- upvalues: ArgCheck (copy), NavigateDown (copy), AppPage (copy), UrlBuilder2 (copy)
	ArgCheck.isTypeOrNil(p1, "function", "onClose")

	return NavigateDown({
		name = AppPage.SettingsSubPage,
		detail = UrlBuilder2.static.settings.privacy(),
		extraProps = {
			titleKey = "Feature.AccountSettings.Heading.Tab.Privacy",
			onClose = p1
		}
	})
end
