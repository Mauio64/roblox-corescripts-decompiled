local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local GetFFlagUseCommunitiesTranslation = require(NavigationRoduxParent.SharedFlags).GetFFlagUseCommunitiesTranslation
local NavigateDown = require(NavigationRodux.Thunks.NavigateDown)
local RobloxAppEnums = require(NavigationRoduxParent.RobloxAppEnums)
local UrlBuilder = require(NavigationRoduxParent.UrlBuilder)
local t = require(NavigationRoduxParent.t)
local AppPage = RobloxAppEnums.AppPage
local UrlBuilder2 = UrlBuilder.UrlBuilder

return function(p1) -- line: 14
	-- upvalues: t (copy), NavigateDown (copy), AppPage (copy), UrlBuilder2 (copy), GetFFlagUseCommunitiesTranslation (copy)
	assert(t.callback(p1) or t.none(p1), "")

	return NavigateDown({
		name = AppPage.GenericWebPage,
		detail = UrlBuilder2.static.groups(),
		extraProps = {
			titleKey = not GetFFlagUseCommunitiesTranslation() and "CommonUI.Features.Label.sGroups" or "CommonUI.Features.Label.Groups",
			onClose = p1
		}
	})
end
