local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local useEffectOnce = require(GroupsParent.RoactUtils).Hooks.useEffectOnce
local Foundation = require(GroupsParent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local FullscreenPageWithSafeArea = require(GroupsParent.AppBlox).FullscreenPageWithSafeArea
local GroupsList = require(Groups.Components.GroupsList)
local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)
local useGroupsListData = require(Groups.Hooks).useGroupsListData
local useGroupsAnalytics = require(Groups.Hooks.useGroupsAnalytics)
local EventNames = require(Groups.Analytics.EventNames)

local function GroupsPage(_: {[any]: any}) -- line: 25
	-- upvalues: useGroupsWrapperContext (copy), useTokens (copy), useGroupsListData (copy), useGroupsAnalytics (copy), useEffectOnce (copy), EventNames (copy), React (copy), FullscreenPageWithSafeArea (copy), View (copy), GroupsList (copy)
	local v16 = useGroupsWrapperContext()
	local v17 = useTokens()
	local v18 = useGroupsListData(v16.userId)
	local v19 = useGroupsAnalytics()

	useEffectOnce(function() -- line: 32
		-- upvalues: v19 (copy), EventNames (copy)
		v19.fireAnalyticsEvent(EventNames.GroupsListPageExposure)
	end, not v18.isLoading and not v18.loadFailure)

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v17.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v17.Color.Surface.Surface_0.Transparency
	}, {
		GroupsPageContent = React.createElement(View, {
			tag = "col size-full-full padding-x-xlarge padding-y-xxlarge"
		}, {
			Content = React.createElement(GroupsList, {
				layoutOrder = 1,
				groupsList = v18.groupsList,
				canCreateGroup = v18.canCreateGroup,
				isLoading = v18.isLoading,
				loadFailure = v18.loadFailure
			})
		})
	})
end

return GroupsPage
