local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local TextKeys = require(Groups.Common.TextKeys)
local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)
local useGroupsAnalytics = require(Groups.Hooks.useGroupsAnalytics)
local EventNames = require(Groups.Analytics.EventNames)
local SearchBarWrapper = require(script.Parent.SearchBarWrapper)

local function GroupsListToolbar(props)
	local v = useGroupsWrapperContext()
	local v2 = useGroupsAnalytics()
	local v3 = useLocalization({
		searchPlaceholder = TextKeys.LabelSearchMyGroups,
		createGroup = TextKeys.ActionCreateGroup
	})

	local searchPlaceholder = props.searchPlaceholder or v3.searchPlaceholder

	local onActivated = React.useCallback(function()
		v2.fireAnalyticsEvent(EventNames.GroupsListCreateGroupClicked)
		v.navigateTo.createGroup()
	end, { v.navigateTo.createGroup, v2 })

	return React.createElement(
		View,
		{ LayoutOrder = props.layoutOrder, tag = "col size-full-0 auto-y align-x-left gap-medium" },
		{
			Search = React.createElement(SearchBarWrapper, {
				LayoutOrder = 1,
				placeholderText = searchPlaceholder,
				onTextChanged = props.onSearchTextChanged
			}),
			CreateGroupButton = React.createElement(
				View,
				{
					LayoutOrder = 2,
					tag = "col",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				},
				{
					Button = React.createElement(Button, {
						text = v3.createGroup,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium,
						width = UDim.new(1, 0),
						isDisabled = props.canCreateGroup == false,
						onActivated = onActivated
					})
				}
			)
		}
	)
end

return GroupsListToolbar
