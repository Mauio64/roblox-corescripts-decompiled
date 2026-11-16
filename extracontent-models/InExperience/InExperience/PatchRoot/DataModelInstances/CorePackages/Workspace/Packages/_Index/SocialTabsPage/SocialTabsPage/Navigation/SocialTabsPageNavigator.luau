local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps

local SocialTabsPage2 = require(SocialTabsPage.Components.SocialTabsPage)
local SocialTabsPageRouter = require(script.Parent.SocialTabsPageRouter)

local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local useProfileDockedPanelWidth = ProfilePlatformCommon.Hooks.useProfileDockedPanelWidth
local ProfilePlatformCommon2 = require(parent.ProfilePlatformCommon)
local useIsProfileSplitDetail = ProfilePlatformCommon2.Hooks.useIsProfileSplitDetail
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useStatusBarHeight = RobloxAppHooks.useStatusBarHeight
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialTabsPageSplitPaneLayout = SharedFlags.FFlagSocialTabsPageSplitPaneLayout

local robloxSwitchNavigator = RoactNavigation.createRobloxSwitchNavigator(SocialTabsPageRouter, {
	resetOnBlur = false,
	keepVisitedScreensMounted = true,
	backBehavior = RoactNavigation.BackBehavior.None
})

local function SocialTabsPageNavigatorComponent(p)
	local navigation = p.navigation

	local v = useNavigationProps(function(_, data)
		return {
			profileId = data.profileId,
			title = data.title,
			initialTabId = data.initialTabId,
			tabConfig = data.tabConfig,
			dockToProfilePanel = data.dockToProfilePanel
		}
	end)

	local pageWidth = useProfileDockedPanelWidth(v.dockToProfilePanel)
	local v2

	if FFlagSocialTabsPageSplitPaneLayout then
		v2 = useIsProfileSplitDetail()
	else
		v2 = false
	end

	local topInset = not FFlagSocialTabsPageSplitPaneLayout and 0 or useStatusBarHeight()

	local renderNavigator = React.useCallback(function()
		return React.createElement(robloxSwitchNavigator, { navigation = navigation })
	end, { navigation })

	local createElement = React.createElement
	local v3 = {
		renderNavigator = renderNavigator,
		tabConfig = v.tabConfig,
		profileId = v.profileId,
		title = v.title,
		initialTabId = v.initialTabId,
		pageWidth = pageWidth,
		fillContainer = FFlagSocialTabsPageSplitPaneLayout and v2 and true or nil,
		topInset = 0,
		hideBackButton = 0
	}

	if not (FFlagSocialTabsPageSplitPaneLayout and v2) then
		topInset = nil
	end

	v3.topInset = topInset
	v3.hideBackButton = FFlagSocialTabsPageSplitPaneLayout and v2 and true or nil
	return createElement(SocialTabsPage2, v3)
end

local extended = React.PureComponent:extend("SocialTabsPageNavigatorClassWrapper")

function extended.render(p)
	return React.createElement(SocialTabsPageNavigatorComponent, p.props)
end

extended.router = robloxSwitchNavigator.router

return extended
