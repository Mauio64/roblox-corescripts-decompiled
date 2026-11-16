local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ViewRecyclerReact")

local PeoplePickerListView = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerList/PeoplePickerListView")
local ShareSheetConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants")
local usePeoplePickerListItemViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerList/usePeoplePickerListItemViewModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerList/usePeoplePickerListViewModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/usePeoplePickerPagination")

local useTokens = Foundation.Hooks.useTokens

local function PeoplePickerListItem(p2)
	local v5 = usePeoplePickerListItemViewModel(p2)

	return React.createElement(PeoplePickerListView.Item, v5)
end

local function getItemKey(data)
	if data.kind == "conversation" then
		return `item--{data.item.id}`
	end

	return `skeleton--{data.index}`
end

local function ConversationRowView(p2)
	local v5 = SignalsReact.useSignalState(p2.itemSignal)
	local item = v5.item

	return React.createElement(PeoplePickerListItem, {
		description = item.description,
		isLoading = item.isLoading,
		isSelected = item.isSelected,
		primaryUserId = item.primaryUserId,
		secondUserId = item.secondUserId,
		title = item.displayName,
		onActivated = function()
			v5.onConversationActivated(item.id)
		end,
		testId = `share-sheet-people-picker-row--{item.id}`
	})
end

local function SkeletonRowView(p2)
	local v5 = SignalsReact.useSignalState(p2.itemSignal)

	return React.createElement(PeoplePickerListItem, {
		description = "",
		isLoading = true,
		isSelected = false,
		primaryUserId = "",
		title = "",
		onActivated = function() end,
		testId = `share-sheet-people-picker-skeleton--{v5.index}`
	})
end

local recyclableView = ViewRecyclerReact.createRecyclableView(ConversationRowView)
local recyclableView2 = ViewRecyclerReact.createRecyclableView(SkeletonRowView)

local function getItemType(p2)
	if p2.kind == "conversation" then
		return recyclableView
	end

	return recyclableView2
end

local function useMeasuredLayout(estimatedRowHeight)
	local v5 = React.useMemo(function()
		return ViewRecyclerReact.Layout.measured({ estimatedItemLength = estimatedRowHeight })
	end, { estimatedRowHeight })

	React.useEffect(function()
		return function()
			v5.destroy()
		end
	end, { v5 })

	return v5
end

local function PeoplePickerVirtualizedList(props)
	local v5 = useTokens()
	local v6 = React.useMemo(function()
		local count = #props.items
		local result = table.create(count + props.skeletonCount)

		for k, item in props.items do
			result[k] = {
				kind = "conversation",
				item = item,
				onConversationActivated = props.onConversationActivated
			}
		end

		for i = 1, props.skeletonCount do
			result[count + i] = { kind = "skeleton", index = i }
		end

		return result
	end, { props.items, props.onConversationActivated, props.skeletonCount })
	local v7 = React.useMemo(function()
		return { items = v6, getItemKey = getItemKey }
	end, { v6 })
	local v8 = useMeasuredLayout(PeoplePickerListView.getItemLayoutMetrics(v5).estimatedRowHeight)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(props.scrollResetQuery)
	React.useEffect(function()
		if ref2.current == props.scrollResetQuery then
			return
		end

		ref2.current = props.scrollResetQuery

		local current = ref.current

		if current then
			current.scrollToOffset(0)
		end
	end, { props.scrollResetQuery })

	return React.createElement(ViewRecyclerReact.VirtualList, {
		data = v7,
		layout = v8,
		axis = ViewRecyclerReact.Axis.Y,
		itemType = getItemType,
		overscan = math.max(0, ShareSheetConstants.FIntShareSheetPeoplePickerOverscanRows),
		endReachedThreshold = props.paginationProps.endReachedThreshold,
		listRef = ref,
		onContentLengthChanged = props.paginationProps.onContentLengthChanged,
		onEndReached = props.paginationProps.onEndReached,
		onScrollOffsetChanged = props.paginationProps.onScrollOffsetChanged,
		onViewportChanged = props.paginationProps.onViewportChanged,
		scrollingFrameRef = props.paginationProps.scrollingFrameRef,
		scrollingFrameProps = {
			Name = "ShareSheetPeoplePickerScrollingFrame",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			Selectable = false
		}
	})
end

return PeoplePickerVirtualizedList
