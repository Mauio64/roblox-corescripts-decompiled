local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local PeoplePickerEmptyState = require(script.Parent.PeoplePickerEmptyState)
local PeoplePickerVirtualizedList = require(script.Parent.PeoplePickerVirtualizedList)
local usePeoplePickerListViewModel = require(script.Parent.usePeoplePickerListViewModel)
require(ShareSheet.Components.PeoplePicker.usePeoplePickerPagination)

local View = Foundation.View

local function PeoplePickerListContainer(props)
	local v = usePeoplePickerListViewModel(props)

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 1),
		testId = "share-sheet-people-picker-list"
	}

	local v3 = {
		List = React.createElement(PeoplePickerVirtualizedList, {
			scrollResetQuery = props.scrollResetQuery,
			items = v.items,
			onConversationActivated = props.onConversationActivated,
			paginationProps = props.paginationProps,
			skeletonCount = v.skeletonCount
		}),
		EmptyState = 0
	}
	local emptyState

	if v.shouldShowEmptyState then
		emptyState = React.createElement(PeoplePickerEmptyState, {
			testId = "share-sheet-people-picker-empty-state"
		})
	end

	v3.EmptyState = emptyState
	return createElement(View, v2, v3)
end

return PeoplePickerListContainer
