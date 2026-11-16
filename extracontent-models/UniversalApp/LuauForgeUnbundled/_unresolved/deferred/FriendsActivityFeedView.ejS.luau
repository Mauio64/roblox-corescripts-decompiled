local module = require("@luauforge/deferred/ejR")
local module2 = require("@luauforge/deferred/ejT")
local module3 = require("@luauforge/deferred/ejU")

local module4 = require("@luauforge/bundled/ejP")
local module5 = require("@luauforge/deferred/ejV")
local module6 = require("@luauforge/deferred/ekN")
local module7 = require("@luauforge/deferred/ekO")
local module8 = require("@luauforge/deferred/ekP")

require("@luauforge/deferred/ekQ")

local loading = module2.Loading
local view = module2.View
local flatList = module3.FlatList
local feedStatus = module4.FeedStatus
local loadMoreStatus = module4.LoadMoreStatus
local activityFeedRowKind = module4.ActivityFeedRowKind

local function CenteredState(props)
	return module.createElement(view, {
		tag = {
			["col align-x-center align-y-center gap-medium padding-xlarge"] = true,
			["size-full"] = props.isScrollEnabled,
			["size-full-0 auto-y"] = not props.isScrollEnabled
		},
		LayoutOrder = props.layoutOrder
	}, props.children)
end

local function getRowKey(data, p2)
	if data.kind == activityFeedRowKind.Header then
		return `section-{data.section}`
	end

	local id = data.item.id

	if id == nil or id == "" then
		return (tostring(p2))
	end

	return id
end

local function renderRow(props, p2)
	if props.kind == activityFeedRowKind.Header then
		return module.createElement(module6, {
			section = props.section,
			layoutOrder = p2
		})
	end

	local item = props.item
	local v5 = module5[item.eventType]
	return module.createElement(v5, {
		item = item,
		onActivated = item.onActivated,
		layoutOrder = p2
	})
end

local function renderItem(p2)
	return renderRow(p2.item)
end

local function FriendsActivityFeedView(props)
	local status = props.status
	local loadMoreStatus2 = props.loadMoreStatus

	local v5 = module.useCallback(function()
		if not props.hasMore or loadMoreStatus2 ~= loadMoreStatus.Idle then
			return
		end

		props.onLoadMore()
	end, { props.hasMore, loadMoreStatus2, props.onLoadMore })

	local isScrollEnabled = props.isScrollEnabled ~= false

	if status == feedStatus.Loading then
		return module.createElement(
			CenteredState,
			{ isScrollEnabled = isScrollEnabled, layoutOrder = props.layoutOrder },
			{ Indicator = module.createElement(loading) }
		)
	end

	if status == feedStatus.Failed then
		return module.createElement(module7, {
			kind = "Error",
			isScrollEnabled = isScrollEnabled,
			layoutOrder = props.layoutOrder,
			onRetry = props.onRetry
		})
	end

	if status == feedStatus.Empty then
		return module.createElement(module7, {
			kind = "Empty",
			description = props.emptyStateDescription,
			isScrollEnabled = isScrollEnabled,
			layoutOrder = props.layoutOrder
		})
	end

	if isScrollEnabled then
		local createElement = module.createElement
		local v7 = { LayoutOrder = props.layoutOrder, tag = "size-full" }

		local createElement2 = module.createElement
		local v10 = {
			data = props.rows,
			renderItem = renderItem,
			keyExtractor = getRowKey,
			initialNumToRender = 10,
			windowSize = 3,
			onEndReached = 0,
			onEndReachedThreshold = 1,
			style = 0,
			contentContainerStyle = 0,
			ListFooterComponent = 0
		}

		if not props.enableContinuousLoad then
			v5 = nil
		end

		v10.onEndReached = v5

		v10.style = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0
		}

		v10.contentContainerStyle = { BackgroundTransparency = 1 }

		v10.ListFooterComponent = module.createElement(module8, {
			hasMore = props.hasMore,
			loadMoreStatus = loadMoreStatus2,
			enableContinuousLoad = props.enableContinuousLoad,
			onLoadMore = props.onLoadMore
		})
		return createElement(view, v7, { List = createElement2(flatList, v10) })
	else
		local v6 = {}

		for k, row in props.rows do
			local v7

			if row.kind == activityFeedRowKind.Header then
				v7 = `section-{row.section}`
			else
				v7 = row.item.id

				if v7 == nil or v7 == "" then
					v7 = tostring(k)
				end
			end

			v6[v7] = renderRow(row, k)
		end

		v6.LoadMore = module.createElement(module8, {
			layoutOrder = #props.rows + 1,
			hasMore = props.hasMore,
			loadMoreStatus = loadMoreStatus2,
			enableContinuousLoad = false,
			onLoadMore = props.onLoadMore
		})

		return module.createElement(
			view,
			{ LayoutOrder = props.layoutOrder, tag = "col size-full-0 auto-y" },
			v6
		)
	end
end

return FriendsActivityFeedView
