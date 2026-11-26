local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Localization").Hooks.useLocalization

local view = Foundation.View
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/TextKeys")
local useGroupsWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Contexts/useGroupsWrapperContext")
local useGroupsAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Hooks/useGroupsAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Analytics/EventNames")
local SearchBarWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsList/SearchBarWrapper")

local function GroupsListToolbar(props)
	local v5 = useGroupsWrapperContext()
	local v6 = useGroupsAnalytics()
	local v7 = useLocalization({
		searchPlaceholder = TextKeys.LabelSearchMyGroups,
		createGroup = TextKeys.ActionCreateGroup
	})

	local searchPlaceholder = props.searchPlaceholder or v7.searchPlaceholder

	local v8 = React.useCallback(function()
		v6.fireAnalyticsEvent(EventNames.GroupsListCreateGroupClicked)
		v5.navigateTo.createGroup()
	end, { v5.navigateTo.createGroup, v6 })

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col size-full-0 auto-y align-x-left gap-medium"
		},
		{
			Search = React.createElement(SearchBarWrapper, {
				LayoutOrder = 1,
				placeholderText = searchPlaceholder,
				onTextChanged = props.onSearchTextChanged
			}),
			CreateGroupButton = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "col",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				},
				{
					Button = React.createElement(button, {
						text = v7.createGroup,
						variant = buttonVariant.Standard,
						size = inputSize.Medium,
						width = UDim.new(1, 0),
						isDisabled = props.canCreateGroup == false,
						onActivated = v8
					})
				}
			)
		}
	)
end

return GroupsListToolbar
