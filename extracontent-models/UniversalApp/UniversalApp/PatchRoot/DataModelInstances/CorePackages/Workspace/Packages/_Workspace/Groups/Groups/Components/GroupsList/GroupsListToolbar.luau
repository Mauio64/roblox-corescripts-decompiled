local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local Foundation = require(GroupsParent.Foundation)
local useLocalization = require(GroupsParent.Localization).Hooks.useLocalization
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local TextKeys = require(Groups.Common.TextKeys)
local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)
local useGroupsAnalytics = require(Groups.Hooks.useGroupsAnalytics)
local EventNames = require(Groups.Analytics.EventNames)
local SearchBarWrapper = require(script.Parent.SearchBarWrapper)

local function GroupsListToolbar(t1: {[any]: any}) -- line: 26
	-- upvalues: useGroupsWrapperContext (copy), useGroupsAnalytics (copy), useLocalization (copy), TextKeys (copy), React (copy), EventNames (copy), View (copy), SearchBarWrapper (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v17 = useGroupsWrapperContext()
	local v18 = useGroupsAnalytics()
	local v19 = useLocalization({
		searchPlaceholder = TextKeys.LabelSearchMyGroups,
		createGroup = TextKeys.ActionCreateGroup
	})
	local v20 = t1.searchPlaceholder or v19.searchPlaceholder
	local v21 = React.useCallback(function() -- line: 36
		-- upvalues: v18 (copy), EventNames (copy), v17 (copy)
		v18.fireAnalyticsEvent(EventNames.GroupsListCreateGroupClicked)
		v17.navigateTo.createGroup()
	end, {
		v17.navigateTo.createGroup,
		v18
	})

	return React.createElement(View, {
		tag = "col size-full-0 auto-y align-x-left gap-medium",
		LayoutOrder = t1.layoutOrder
	}, {
		Search = React.createElement(SearchBarWrapper, {
			LayoutOrder = 1,
			placeholderText = v20,
			onTextChanged = t1.onSearchTextChanged
		}),
		CreateGroupButton = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Button = React.createElement(Button, {
				text = v19.createGroup,
				variant = ButtonVariant.Standard,
				size = InputSize.Medium,
				width = UDim.new(1, 0),
				isDisabled = t1.canCreateGroup == false,
				onActivated = v21
			})
		})
	})
end

return GroupsListToolbar
