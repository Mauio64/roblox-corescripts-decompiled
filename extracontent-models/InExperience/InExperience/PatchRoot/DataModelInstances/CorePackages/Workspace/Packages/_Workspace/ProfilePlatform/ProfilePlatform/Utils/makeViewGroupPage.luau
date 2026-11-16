local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
require(parent.NavigationRodux)
local Responsive = require(parent.Responsive)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local TextKeys = require(ProfilePlatform.Common.TextKeys)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources

local function makeViewGroupPage(groupId: string, onClose)
	local v = Responsive.GetInputModeStore(false).getPreferredInputType(false) == Responsive.Input.Directional

	if FFlagEnableGroupOverviewPane and not v then
		return {
			name = AppPage.Groups,
			extraProps = { groupId = groupId, source = Sources.ProfilePlatform }
		}
	end

	return {
		name = AppPage.GenericWebPage,
		detail = urlBuilder.user.group({ groupId = groupId }),
		extraProps = { titleKey = TextKeys.Community, onClose = onClose }
	}
end

return makeViewGroupPage
