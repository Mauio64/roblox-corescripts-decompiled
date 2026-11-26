local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/RoactNavigation")
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/RobloxAppNavigation").useNavigationProps

local SocialTabsPage = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Components/SocialTabsPage")
local SocialTabsPageRouter = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Navigation/SocialTabsPageRouter")

local useProfileDockedPanelWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/ProfilePlatformCommon").Hooks.useProfileDockedPanelWidth
local useIsProfileSplitDetail = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/ProfilePlatformCommon").Hooks.useIsProfileSplitDetail
local useStatusBarHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/RobloxAppHooks").useStatusBarHeight
local fFlagSocialTabsPageSplitPaneLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SharedFlags").FFlagSocialTabsPageSplitPaneLayout

local robloxSwitchNavigator = RoactNavigation.createRobloxSwitchNavigator(SocialTabsPageRouter, {
	resetOnBlur = false,
	keepVisitedScreensMounted = true,
	backBehavior = RoactNavigation.BackBehavior.None
})

local function SocialTabsPageNavigatorComponent(p2)
	local navigation = p2.navigation

	local v5 = useNavigationProps(function(p3, data)
		return {
			profileId = data.profileId,
			title = data.title,
			initialTabId = data.initialTabId,
			tabConfig = data.tabConfig,
			dockToProfilePanel = data.dockToProfilePanel
		}
	end)

	local v6 = useProfileDockedPanelWidth(v5.dockToProfilePanel)
	local v7 = if fFlagSocialTabsPageSplitPaneLayout then useIsProfileSplitDetail() else false
	local v8 = not fFlagSocialTabsPageSplitPaneLayout and 0 or useStatusBarHeight()

	local v9 = React.useCallback(function()
		return React.createElement(robloxSwitchNavigator, { navigation = navigation })
	end, { navigation })

	local createElement = React.createElement
	local v11 = {
		renderNavigator = v9,
		tabConfig = v5.tabConfig,
		profileId = v5.profileId,
		title = v5.title,
		initialTabId = v5.initialTabId,
		pageWidth = v6,
		fillContainer = fFlagSocialTabsPageSplitPaneLayout and v7 and true or nil,
		topInset = 0,
		hideBackButton = 0
	}

	if not (fFlagSocialTabsPageSplitPaneLayout and v7) then
		v8 = nil
	end

	v11.topInset = v8
	v11.hideBackButton = fFlagSocialTabsPageSplitPaneLayout and v7 and true or nil
	return createElement(SocialTabsPage, v11)
end

local extended = React.PureComponent:extend("SocialTabsPageNavigatorClassWrapper")

function extended.render(p2)
	return React.createElement(SocialTabsPageNavigatorComponent, p2.props)
end

extended.router = robloxSwitchNavigator.router

return extended
