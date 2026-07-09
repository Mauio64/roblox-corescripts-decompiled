local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local RoactNavigation = require(SocialTabsPageParent.RoactNavigation)
local useNavigationProps = require(SocialTabsPageParent.RobloxAppNavigation).useNavigationProps
local SocialTabsPage2 = require(SocialTabsPage.Components.SocialTabsPage)
local SocialTabsPageRouter = require(script.Parent.SocialTabsPageRouter)
local v8 = RoactNavigation.createRobloxSwitchNavigator(SocialTabsPageRouter, {
	resetOnBlur = false,
	keepVisitedScreensMounted = true,
	backBehavior = RoactNavigation.BackBehavior.None
})

local function SocialTabsPageNavigatorComponent(t1: {[any]: any}) -- line: 21
	-- upvalues: useNavigationProps (copy), React (copy), v8 (copy), SocialTabsPage2 (copy)
	local navigation = t1.navigation
	local v13 = useNavigationProps(function(_, p2) -- line: 24
		return {
			profileId = p2.profileId,
			title = p2.title,
			initialTabId = p2.initialTabId,
			tabConfig = p2.tabConfig,
			pageWidth = p2.pageWidth
		}
	end)
	local v14 = React.useCallback(function() -- line: 34
		-- upvalues: React (copy), v8 (copy), navigation (copy)
		return React.createElement(v8, {
			navigation = navigation
		})
	end, { navigation })

	return React.createElement(SocialTabsPage2, {
		renderNavigator = v14,
		tabConfig = v13.tabConfig,
		profileId = v13.profileId,
		title = v13.title,
		initialTabId = v13.initialTabId,
		pageWidth = v13.pageWidth
	})
end

local v10 = React.PureComponent:extend("SocialTabsPageNavigatorClassWrapper")

function v10.render(p3) -- line: 52
	-- upvalues: React (copy), SocialTabsPageNavigatorComponent (copy)
	return React.createElement(SocialTabsPageNavigatorComponent, p3.props)
end

v10.router = v8.router

return v10
