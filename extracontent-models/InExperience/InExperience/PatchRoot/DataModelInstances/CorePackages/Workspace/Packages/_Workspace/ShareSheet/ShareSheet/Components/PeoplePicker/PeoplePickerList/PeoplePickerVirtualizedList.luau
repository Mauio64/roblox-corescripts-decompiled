local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local ViewRecycler = require(parent.ViewRecycler)

local PeoplePickerListView = require(script.Parent.PeoplePickerListView)
local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
local usePeoplePickerListItemViewModel = require(script.Parent.usePeoplePickerListItemViewModel)
require(script.Parent.usePeoplePickerListViewModel)
require(ShareSheet.Components.PeoplePicker.usePeoplePickerPagination)

local useTokens = Foundation.Hooks.useTokens

local function PeoplePickerListItem(p)
	local v = usePeoplePickerListItemViewModel(p)

	return React.createElement(PeoplePickerListView.Item, v)
end

local function getItemKey(data)
	if data.kind == "conversation" then
		return `item--{data.item.id}`
	end

	return `skeleton--{data.index}`
end

local function ConversationRowView(p)
	local v = SignalsReact.useSignalState(p.itemSignal)
	local item = v.item

	return React.createElement(PeoplePickerListItem, {
		description = item.description,
		isLoading = item.isLoading,
		isSelected = item.isSelected,
		primaryUserId = item.primaryUserId,
		secondUserId = item.secondUserId,
		title = item.displayName,
		onActivated = function()
			v.onConversationActivated(item.id)
		end,
		testId = `share-sheet-people-picker-row--{item.id}`
	})
end

local function SkeletonRowView(p)
	local v = SignalsReact.useSignalState(p.itemSignal)

	return React.createElement(PeoplePickerListItem, {
		description = "",
		isLoading = true,
		isSelected = false,
		primaryUserId = "",
		title = "",
		onActivated = function() end,
		testId = `share-sheet-people-picker-skeleton--{v.index}`
	})
end

local recyclableView = ViewRecycler.createRecyclableView(ConversationRowView)
local recyclableView2 = ViewRecycler.createRecyclableView(SkeletonRowView)

local function getItemType(p)
	if p.kind == "conversation" then
		return recyclableView
	end

	return recyclableView2
end

local function useMeasuredLayout(estimatedRowHeight: number)
	local v = React.useMemo(function()
		return ViewRecycler.Layout.measured({ estimatedItemLength = estimatedRowHeight })
	end, { estimatedRowHeight })

	React.useEffect(function()
		return function()
			v.destroy()
		end
	end, { v })

	return v
end

local function PeoplePickerVirtualizedList(props)
	local v = useTokens()
	local items = React.useMemo(function()
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
	local v2 = React.useMemo(function()
		return { items = items, getItemKey = getItemKey }
	end, { items })
	local layout = useMeasuredLayout(PeoplePickerListView.getItemLayoutMetrics(v).estimatedRowHeight)
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

	return React.createElement(ViewRecycler.VirtualList, {
		data = v2,
		layout = layout,
		axis = ViewRecycler.Axis.Y,
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
