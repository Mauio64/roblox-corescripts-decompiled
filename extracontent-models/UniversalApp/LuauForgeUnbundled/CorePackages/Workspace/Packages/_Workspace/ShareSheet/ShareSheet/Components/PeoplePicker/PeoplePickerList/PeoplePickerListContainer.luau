local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local PeoplePickerEmptyState = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerList/PeoplePickerEmptyState")
local PeoplePickerVirtualizedList = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerList/PeoplePickerVirtualizedList")
local usePeoplePickerListViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerList/usePeoplePickerListViewModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/usePeoplePickerPagination")

local view = Foundation.View

local function PeoplePickerListContainer(props)
	local v5 = usePeoplePickerListViewModel(props)

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 1),
		testId = "share-sheet-people-picker-list"
	}

	local v8 = {
		List = React.createElement(PeoplePickerVirtualizedList, {
			scrollResetQuery = props.scrollResetQuery,
			items = v5.items,
			onConversationActivated = props.onConversationActivated,
			paginationProps = props.paginationProps,
			skeletonCount = v5.skeletonCount
		}),
		EmptyState = 0
	}

	local v9 = if v5.shouldShowEmptyState then React.createElement(PeoplePickerEmptyState, {
		testId = "share-sheet-people-picker-empty-state"
	}) else nil
	v8.EmptyState = v9
	return createElement(view, v7, v8)
end

return PeoplePickerListContainer
