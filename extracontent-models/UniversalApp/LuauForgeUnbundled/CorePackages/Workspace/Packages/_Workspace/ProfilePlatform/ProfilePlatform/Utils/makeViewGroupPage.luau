local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Responsive")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UrlBuilder").UrlBuilder

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local fFlagEnableGroupOverviewPane = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableGroupOverviewPane
local sources = SocialLuaAnalytics.Analytics.Enums.Sources

local function makeViewGroupPage(p2, onClose)
	local v5 = Responsive.GetInputModeStore(false).getPreferredInputType(false) == Responsive.Input.Directional

	if fFlagEnableGroupOverviewPane and not v5 then
		return {
			name = appPage.Groups,
			extraProps = { groupId = p2, source = sources.ProfilePlatform }
		}
	end

	return {
		name = appPage.GenericWebPage,
		detail = urlBuilder.user.group({ groupId = p2 }),
		extraProps = { titleKey = TextKeys.Community, onClose = onClose }
	}
end

return makeViewGroupPage
