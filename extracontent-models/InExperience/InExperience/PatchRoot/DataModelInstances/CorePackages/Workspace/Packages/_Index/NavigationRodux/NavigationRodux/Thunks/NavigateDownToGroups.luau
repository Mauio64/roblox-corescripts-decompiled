local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagUseCommunitiesTranslation = SharedFlags.GetFFlagUseCommunitiesTranslation

local NavigateDown = require(NavigationRodux.Thunks.NavigateDown)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UrlBuilder = require(parent.UrlBuilder)
local t = require(parent.t)

local AppPage = RobloxAppEnums.AppPage
local urlBuilder = UrlBuilder.UrlBuilder

return function(onClose)
	assert(t.callback(onClose) or t.none(onClose), "")
	return NavigateDown({
		name = AppPage.GenericWebPage,
		detail = urlBuilder.static.groups(),
		extraProps = {
			titleKey = GetFFlagUseCommunitiesTranslation() and "CommonUI.Features.Label.Groups" or "CommonUI.Features.Label.sGroups",
			onClose = onClose
		}
	})
end
