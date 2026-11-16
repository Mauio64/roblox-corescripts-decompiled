local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local SafeFlags = require(parent2.SafeFlags)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local console = LuauPolyfill.console

local v = SafeFlags.createGetFFlag("VirtualizedListStableCells")()

local function isIndexTruthy(initialScrollIndex: number?): boolean -- 5 equivalent calls inferred from this helper
	return initialScrollIndex ~= nil and initialScrollIndex ~= 1
end

local Batchinator = require(parent.Interaction.Batchinator)

local FillRateHelper = require(script.Parent.FillRateHelper)

local v2 = {
	findNodeHandle = function(_)
		warn("ReactNative.findNodeHandle is not implemented")
	end
}

local ScrollView = require(parent.Components.ScrollView.ScrollView)
local StyleSheet = require(parent.StyleSheet.StyleSheet)

local View = require(parent.Components.View.View)

local ViewabilityHelper = require(script.Parent.ViewabilityHelper)

local function fn(...)
	return {}
end

local infoLog = require(parent.Utilities.infoLog)
local invariant = require(parent.jsUtils.invariant)

local VirtualizeUtils = require(script.Parent.VirtualizeUtils)
local keyExtractor = VirtualizeUtils.keyExtractor
local computeWindowedRenderLimits = VirtualizeUtils.computeWindowedRenderLimits

local React = require(parent2.React)

require(parent.Components.ScrollView.ScrollView)

local VirtualizedListContext = require(script.Parent.VirtualizedListContext)
local VirtualizedListCellContextProvider = VirtualizedListContext.VirtualizedListCellContextProvider
local virtualizedListContext = VirtualizedListContext.VirtualizedListContext
local VirtualizedListContextProvider = VirtualizedListContext.VirtualizedListContextProvider

local describeNestedLists
local v3 = nil
local v4 = nil

local function RefreshControl(p)
	return React.createElement("Frame", { Name = "RCTRefreshControl" }, p.children)
end

local v5 = false
local v6 = ""

local function horizontalOrDefault(horizontal: boolean?) -- 9 equivalent calls inferred from this helper
	return horizontal ~= nil and horizontal
end

local function initialNumToRenderOrDefault(initialNumToRender: number?) -- 2 equivalent calls inferred from this helper
	return if initialNumToRender == nil then 10 else initialNumToRender
end

local function maxToRenderPerBatchOrDefault(maxToRenderPerBatch: number?) -- 3 equivalent calls inferred from this helper
	if maxToRenderPerBatch == nil then
		return 10
	end

	return maxToRenderPerBatch
end

local function onEndReachedThresholdOrDefault(onEndReachedThreshold: number?) -- 2 equivalent calls inferred from this helper
	if onEndReachedThreshold == nil then
		return 2
	end

	return onEndReachedThreshold
end

local function scrollEventThrottleOrDefault(scrollEventThrottle: number?) -- 1 equivalent call inferred from this helper
	if scrollEventThrottle == nil then
		return 50
	end

	return scrollEventThrottle
end

local function windowSizeOrDefault(windowSize: number?) -- 3 equivalent calls inferred from this helper
	return if windowSize == nil then 21 else windowSize
end

local function compareItemDataOrDefault(callback)
	if callback == nil then
		return function(p, p2): boolean
			return p == p2
		end
	end

	return callback
end

local extended = React.PureComponent:extend("VirtualizedList")
extended.contextType = virtualizedListContext

function extended:init(props)
	self.props = props
	self._viewabilityTuples = {}
	self._averageCellLength = 0

	self._cellKeysToChildListKeys = Map.new()
	self._cellRefs = {}
	self._cellLayoutHandlers = {}
	self._cellRefHandlers = {}
	self._frames = {}
	self._footerLength = 0
	self._hasDoneInitialScroll = false
	self._hasInteracted = false
	self._hasMore = false
	self._hasWarned = {}
	self._headerLength = 0
	self._hiPriInProgress = false
	self._highestMeasuredFrameIndex = 1
	self._indicesToKeys = Map.new()
	self._nestedChildLists = Map.new()

	self._offsetFromParentVirtualizedList = 0
	self._prevParentOffset = 0
	self._scrollMetrics = {
		contentLength = 0,
		dOffset = 0,
		dt = 10,
		offset = 0,
		timestamp = 0,
		velocity = 0,
		visibleLength = 0
	}

	self._scrollRef = nil
	self._sentEndForContentLength = 0
	self._totalCellLength = 0
	self._totalCellsMeasured = 0

	self._canvasPosition = Vector2.new(0, 0)
	self._canvasSize = UDim2.new(0, 0, 0, 0)

	self._invertedCanvasLength = self.props.getItemLayout and 0 or self.props.invertedCanvasLength or 1000

	function self._getFrameMetrics(p: number)
		local data = self.props.data
		local getItem = self.props.getItem
		local getItemCount = self.props.getItemCount
		local getItemLayout = self.props.getItemLayout
		invariant(p <= getItemCount(data), "Tried to get frame for out of range index " .. tostring(p))

		local v7 = getItem(data, p)

		if v7 ~= nil then
			v7 = self._frames[self:_keyExtractor(v7, p)]
		end

		if (not v7 or v7.index ~= p) and getItemLayout then
			return (getItemLayout(data, p))
		end

		return v7
	end

	invariant(
		windowSizeOrDefault(props.windowSize) > 0, -- inferred equivalent call
		"VirtualizedList: The windowSize prop must be present and set to a value greater than 0."
	)

	self._fillRateHelper = FillRateHelper.new(self._getFrameMetrics)
	function self._updateCellsToRender()
		local data = self.props.data
		local getItemCount = self.props.getItemCount
		local v7 = onEndReachedThresholdOrDefault(self.props.onEndReachedThreshold) -- inferred equivalent call

		local virtualizationDisabled = self:_isVirtualizationDisabled()
		self:_updateViewableItems(data)

		if not Boolean.toJSBoolean(data) then
			return
		end

		self:setState(function(p)
			local result = nil

			local contentLength = self._scrollMetrics.contentLength
			local offset = self._scrollMetrics.offset
			local visibleLength = self._scrollMetrics.visibleLength

			if virtualizationDisabled then
				local v8

				if contentLength - visibleLength - offset < v7 * visibleLength then
					v8 = maxToRenderPerBatchOrDefault(self.props.maxToRenderPerBatch) -- inferred equivalent call
				else
					v8 = 0
				end

				result = {
					first = 1,
					last = math.min(p.last + v8, getItemCount(data))
				}
			elseif
				visibleLength > 0
				and contentLength > 0
				and (not isIndexTruthy(self.props.initialScrollIndex) or Boolean.toJSBoolean(self._scrollMetrics.offset)) -- inferred equivalent call
			then
				result = computeWindowedRenderLimits(
					self.props.data,
					self.props.getItemCount,
					maxToRenderPerBatchOrDefault(self.props.maxToRenderPerBatch), -- inferred equivalent call
					windowSizeOrDefault(self.props.windowSize), -- inferred equivalent call
					p,
					self._getFrameMetricsApprox,
					self._scrollMetrics
				)
			end

			if result ~= nil and self._nestedChildLists.size > 0 then
				local first = result.first
				local last = result.last

				while first <= last do
					local v8 = self._indicesToKeys:get(first)

					if Boolean.toJSBoolean(v8) then
						v8 = self._cellKeysToChildListKeys:get(v8)
					end

					if not Boolean.toJSBoolean(v8) then
						continue
					end

					local flag = false

					for _, v9 in ipairs(v8) do
						local v10 = self._nestedChildLists:get(v9)

						if v10 and v10.ref and v10.ref:hasMore() then
							flag = true
							break
						end
					end

					if flag then
						result.last = first
						break
					end

					first += 1
				end
			end

			if result ~= nil and result.first == p.first and result.last == p.last then
				result = nil
			end

			return result
		end)
	end
	self._updateCellsToRenderBatcher = Batchinator.new(
		self._updateCellsToRender,
		self.props.updateCellsBatchingPeriod == nil and 50 or self.props.updateCellsBatchingPeriod
	)

	if self.props.viewabilityConfigCallbackPairs then
		self._viewabilityTuples = Array.map(self.props.viewabilityConfigCallbackPairs, function(p)
			return {
				viewabilityHelper = ViewabilityHelper.new(p.viewabilityConfig),
				onViewableItemsChanged = p.onViewableItemsChanged
			}
		end)
	else
		local onViewableItemsChanged = self.props.onViewableItemsChanged
		local viewabilityConfig = self.props.viewabilityConfig

		if onViewableItemsChanged then
			table.insert(self._viewabilityTuples, {
				viewabilityHelper = ViewabilityHelper.new(viewabilityConfig),
				onViewableItemsChanged = onViewableItemsChanged
			})
		end
	end

	local state = {
		first = not isIndexTruthy(self.props.initialScrollIndex) and 1 or self.props.initialScrollIndex, -- inferred equivalent call
		last = 0,
		firstItemTracked = 0,
		scrollPositionDelta = 0
	}

	local v7 = self.props.getItemCount(self.props.data) + 1
	local v8 = not isIndexTruthy(self.props.initialScrollIndex) and 1 or self.props.initialScrollIndex -- inferred equivalent call
	state.last = math.min(v7, v8 + initialNumToRenderOrDefault(self.props.initialNumToRender)) - 1 -- inferred equivalent call
	local firstItemTracked

	if self.props.data and self.props.getItemCount(self.props.data) > 0 then
		firstItemTracked = self.props.getItem(self.props.data, 1)
	else
		firstItemTracked = Object.None
	end

	state.firstItemTracked = firstItemTracked

	if self:_isNestedWithSameOrientation() then
		local nestedChildState = self.context.getNestedChildState(self:_getListKey())

		if Boolean.toJSBoolean(nestedChildState) then
			self.state = nestedChildState
			self._frames = nestedChildState.frames
			state = nestedChildState
		end
	end

	self.state = state

	function self._getScrollMetrics()
		return self._scrollMetrics
	end

	function self._getOutermostParentListRef()
		if self:_isNestedWithSameOrientation() then
			return self.context.getOutermostParentListRef()
		end

		return self
	end

	function self._getNestedChildState(p: string)
		local v9 = self._nestedChildLists:get(p)
		return v9 and v9.state
	end

	function self._registerAsNestedChild(data): nil
		local v9 = self._cellKeysToChildListKeys:get(data.cellKey) or Set.new()
		v9:add(data.key)
		self._cellKeysToChildListKeys:set(data.cellKey, v9)
		local v10 = self._nestedChildLists:get(data.key)

		if v10 and v10.ref ~= nil then
			console.error("A VirtualizedList contains a cell which itself contains " .. "more than one VirtualizedList of the same orientation as the parent " .. "list. You must pass a unique listKey prop to each sibling list.\n\n" .. describeNestedLists(Object.assign({}, data, {
				horizontal = Boolean.toJSBoolean(data.ref.props.horizontal)
			})))
		end

		self._nestedChildLists:set(data.key, { ref = data.ref, state = nil })

		if self._hasInteracted then
			data.ref:recordInteraction()
		end

		return nil
	end

	function self._unregisterAsNestedChild(p)
		self._nestedChildLists:set(p.key, { ref = nil, state = p.state })
	end

	function self._onUpdateSeparators(p, p2)
		Array.forEach(p, function(p3)
			local v9

			if p3 == nil then
				v9 = false
			else
				v9 = self._cellRefs[tostring(p3)]
			end

			if Boolean.toJSBoolean(v9) then
				return v9:updateSeparatorProps(p2)
			end
		end)
	end

	function self._getSpacerKey(flag: boolean): string
		return if flag then "height" else "width"
	end

	function self._captureScrollRef(scrollRef)
		self._scrollRef = scrollRef
	end

	function self._defaultRenderScrollComponent(props2)
		local onRefresh = props2.onRefresh

		if self:_isNestedWithSameOrientation() then
			return React.createElement(View, props2)
		end

		if not onRefresh then
			return React.createElement(ScrollView, props2)
		end

		invariant(
			typeof(props2.refreshing) == "boolean",
			"`refreshing` prop must be set as a boolean in order to use `onRefresh`, but got `" .. (props2.refreshing == nil and "undefined" or tostring(props2.refreshing) .. "`")
		)

		local createElement = React.createElement

		local assign = Object.assign
		local clone = table.clone(props2)
		local refreshControl

		if props2.refreshControl == nil then
			refreshControl = React.createElement(RefreshControl, {
				refreshing = props2.refreshing,
				onRefresh = onRefresh,
				progressViewOffset = props2.progressViewOffset
			})
		else
			refreshControl = props2.refreshControl
		end

		return createElement(ScrollView, assign(clone, { refreshControl = refreshControl }))
	end

	function self._onCellUnmount(p: string)
		local frame = self._frames[p]

		if frame ~= nil then
			self._frames[p] = Object.assign({}, frame, { inLayout = false })
		end

		if v then
			self._cellLayoutHandlers[p] = nil
			self._cellRefHandlers[p] = nil
		end
	end

	function self._onLayout(p)
		if self:_isNestedWithSameOrientation() then
			self:measureLayoutRelativeToContainingList()
		else
			self._scrollMetrics.visibleLength = self:_selectLength({
				width = p.AbsoluteSize.X,
				height = p.AbsoluteSize.Y
			})
		end

		if self.props.onLayout then
			self.props.onLayout(p)
		end

		self:_scheduleCellsToRenderUpdate()
		self:_maybeCallOnEndReached()
	end

	function self._onLayoutEmpty(p)
		if self.props.onLayout then
			self.props.onLayout(p)
		end
	end

	function self._onLayoutFooter(p)
		self:_triggerRemeasureForChildListsInCell(self:_getFooterCellKey())
		self._footerLength = self:_selectLength({
			height = p.AbsoluteSize.Y,
			width = p.AbsoluteSize.X
		})
	end

	function self._onLayoutHeader(p)
		self._headerLength = self:_selectLength({
			height = p.AbsoluteSize.Y,
			width = p.AbsoluteSize.X
		})
	end

	function self._onContentSizeChange(width: number, height: number)
		if
			width > 0
			and height > 0
			and self.props.initialScrollIndex ~= nil
			and self.props.initialScrollIndex > 1
			and not self._hasDoneInitialScroll
		then
			if self.props.contentOffset == nil then
				self:scrollToIndex({ animated = false, index = self.props.initialScrollIndex })
			end

			self._hasDoneInitialScroll = true
		elseif self.props.inverted and width > 0 and height > 0 and not self._hasDoneInitialScroll then
			self._hasDoneInitialScroll = true
			task.defer(function()
				while self:getScrollRef() == nil do
					task.wait()
				end

				if self.props.contentOffset == nil then
					local current = self:getScrollRef()._nativeRef.current

					if self.props.horizontal then
						current.CanvasPosition = Vector2.new(current.AbsoluteCanvasSize.X, current.CanvasPosition.Y)
					else
						current.CanvasPosition = Vector2.new(current.CanvasPosition.X, current.AbsoluteCanvasSize.Y)
					end
				end
			end)
		end

		if self.props.onContentSizeChange then
			self.props.onContentSizeChange(width, height)
		end

		self._scrollMetrics.contentLength = self:_selectLength({ height = height, width = width })
		self:_scheduleCellsToRenderUpdate()
		self:_maybeCallOnEndReached()
	end

	function self._convertParentScrollMetrics(p)
		local offset = p.offset - self._offsetFromParentVirtualizedList

		local visibleLength = p.visibleLength
		local dOffset = offset - self._scrollMetrics.offset
		return {
			visibleLength = visibleLength,
			contentLength = self._scrollMetrics.contentLength,
			offset = offset,
			dOffset = dOffset
		}
	end

	function self._onScroll(instance)
		self._nestedChildLists:forEach(function(p)
			if p.ref then
				p.ref._onScroll(instance)
			end
		end)

		if self.props.onScroll then
			self.props.onScroll(instance)
		end

		local now = os.clock()
		local v9 = instance:GetChildren()[1]
		local visibleLength = self:_selectLength({
			height = instance.AbsoluteSize.Y,
			width = instance.AbsoluteSize.X
		})
		local contentLength = self:_selectLength({
			height = v9.AbsoluteSize.Y,
			width = v9.AbsoluteSize.X
		})
		local offset

		if self.props.inverted then
			offset = self:_selectOffset({
				x = instance.AbsoluteCanvasSize.X - instance.CanvasPosition.X - visibleLength,
				y = instance.AbsoluteCanvasSize.Y - instance.CanvasPosition.Y - visibleLength
			})
		else
			offset = self:_selectOffset({
				x = instance.CanvasPosition.X,
				y = instance.CanvasPosition.Y
			})
		end

		local dOffset = offset - self._scrollMetrics.offset

		if self:_isNestedWithSameOrientation() then
			if self._scrollMetrics.contentLength == 0 then
				return
			end

			local convertParentScrollMetrics = self._convertParentScrollMetrics({ visibleLength, offset })

			visibleLength = convertParentScrollMetrics.visibleLength
			contentLength = convertParentScrollMetrics.contentLength
			offset = convertParentScrollMetrics.offset
			dOffset = convertParentScrollMetrics.dOffset
		end

		local dt = not Boolean.toJSBoolean(self._scrollMetrics.timestamp) and 1
			or math.max(1, (now - self._scrollMetrics.timestamp) * 1000)

		local velocity = dOffset / dt

		if
			dt > 500
			and self._scrollMetrics.dt > 500
			and 5 * visibleLength < contentLength
			and not self._hasWarned.perf
		then
			infoLog(
				"VirtualizedList: You have a large list that is slow to update - make sure your renderItem function renders components that follow React performance best practices like PureComponent, shouldComponentUpdate, etc.",
				{ dt = dt, prevDt = self._scrollMetrics.dt, contentLength = contentLength }
			)

			self._hasWarned.perf = true
		end

		self._scrollMetrics = {
			contentLength = contentLength,
			dt = dt,
			dOffset = dOffset,
			offset = offset,
			timestamp = now,
			velocity = velocity,
			visibleLength = visibleLength
		}

		local scrollPositionDelta = self.state.scrollPositionDelta

		if scrollPositionDelta > 0 then
			self:setState(function(p)
				return {
					scrollPositionDelta = 0,
					first = p.first + scrollPositionDelta,
					last = p.last + scrollPositionDelta
				}
			end)
		end

		self:_updateViewableItems(self.props.data)

		if not self.props then
			return
		end

		self:_maybeCallOnEndReached()

		if velocity ~= 0 then
			self._fillRateHelper:activate()
		end

		self:_computeBlankness()
		self:_scheduleCellsToRenderUpdate()
	end

	function self._onScrollBeginDrag(p)
		self._nestedChildLists:forEach(function(p2)
			if p2.ref then
				p2.ref._onScrollBeginDrag(p)
			end
		end)
		Array.forEach(self._viewabilityTuples, function(p2)
			p2.viewabilityHelper:recordInteraction()
		end)
		self._hasInteracted = true

		if self.props.onScrollBeginDrag then
			self.props.onScrollBeginDrag(p)
		end
	end

	function self._onScrollEndDrag(p)
		self._nestedChildLists:forEach(function(p2)
			if p2.ref then
				p2.ref._onScrollEndDrag(p)
			end
		end)

		if Boolean.toJSBoolean(nil) then
			self._scrollMetrics.velocity = self:_selectOffset(nil)
		end

		self:_computeBlankness()

		if self.props.onScrollEndDrag then
			self.props.onScrollEndDrag(p)
		end
	end

	function self._onMomentumScrollBegin(p)
		self._nestedChildLists:forEach(function(p2)
			if p2.ref then
				p2.ref._onMomentumScrollBegin(p)
			end
		end)

		if self.props.onMomentumScrollBegin then
			self.props.onMomentumScrollBegin(p)
		end
	end

	function self._onMomentumScrollEnd(p)
		self._nestedChildLists:forEach(function(p2)
			if p2.ref then
				p2.ref._onMomentumScrollEnd(p)
			end
		end)
		self._scrollMetrics.velocity = 0
		self:_computeBlankness()

		if self.props.onMomentumScrollEnd then
			self.props.onMomentumScrollEnd(p)
		end
	end

	function self._createViewToken(p: number, isViewable: boolean)
		local data = self.props.data
		local item = self.props.getItem(data, p)
		return {
			index = p,
			item = item,
			key = self:_keyExtractor(item, p),
			isViewable = isViewable
		}
	end

	function self._getFrameMetricsApprox(p: number)
		local frameMetrics = self._getFrameMetrics(p)

		if frameMetrics ~= nil and frameMetrics.index == p then
			return frameMetrics
		end

		invariant(
			not self.props.getItemLayout,
			"Should not have to estimate frames when a measurement metrics function is provided"
		)

		return {
			length = self._averageCellLength,
			offset = self._averageCellLength * (p - 1)
		}
	end
end

function extended:scrollToEnd(p)
	local animated = p == nil or p.animated
	local itemCount = self.props.getItemCount(self.props.data)
	local frameMetricsApprox = self._getFrameMetricsApprox(itemCount)
	local v7 = self.props.inverted and 0
		or math.max(
			0,
			frameMetricsApprox.offset + frameMetricsApprox.length + self._footerLength - self._scrollMetrics.visibleLength
		)

	if self._scrollRef == nil then
		return
	end

	if self._scrollRef.scrollTo == nil then
		console.warn("No scrollTo method provided. This may be because you have two nested VirtualizedLists with the same orientation, or because you are using a custom component that does not implement scrollTo.")

		return
	end

	self._scrollRef.scrollTo(horizontalOrDefault(self.props.horizontal) and { -- inferred equivalent call
		x = v7,
		animated = animated
	} or { y = v7, animated = animated })
end

function extended:scrollToIndex(data)
	local data2 = self.props.data
	local horizontal = self.props.horizontal
	local getItemCount = self.props.getItemCount
	local getItemLayout = self.props.getItemLayout
	local onScrollToIndexFailed = self.props.onScrollToIndexFailed

	local animated = data.animated
	local index = data.index
	local viewOffset = data.viewOffset
	local viewPosition = data.viewPosition
	invariant(index >= 1, ("scrollToIndex out of range: requested index %d but minimum is 1"):format(index))

	invariant(
		getItemCount(data2) >= 1,
		("scrollToIndex out of range: item length %d but minimum is 1"):format(getItemCount(data2))
	)

	invariant(
		index <= getItemCount(data2),
		("scrollToIndex out of range: requested index %d is out of 1 to %d"):format(index, getItemCount(data2))
	)

	if getItemLayout or not (self._highestMeasuredFrameIndex < index) then
		local current

		if self:getScrollRef() then
			current = self:getScrollRef()._nativeRef.current
		end

		if current == nil then
			return
		end

		local absoluteCanvasSize = current.AbsoluteCanvasSize
		local absoluteSize = current.AbsoluteSize

		local frameMetricsApprox = self._getFrameMetricsApprox(index)
		local v7

		if self.props.inverted then
			local v8

			if horizontal then
				v8 = absoluteCanvasSize.X
			else
				v8 = absoluteCanvasSize.Y
			end

			local v9

			if horizontal then
				v9 = absoluteSize.X
			else
				v9 = absoluteSize.Y
			end

			v7 = v8 - v9 - frameMetricsApprox.offset - (Boolean.toJSBoolean(viewPosition) and viewPosition or 0) * (self._scrollMetrics.visibleLength - frameMetricsApprox.length)
		else
			v7 = frameMetricsApprox.offset - (Boolean.toJSBoolean(viewPosition) and viewPosition or 0) * (self._scrollMetrics.visibleLength - frameMetricsApprox.length)
		end

		local v8 = math.max(0, v7) - (Boolean.toJSBoolean(viewOffset) and viewOffset or 0)

		if self._scrollRef == nil then
			return
		end

		if self._scrollRef.scrollTo == nil then
			console.warn("No scrollTo method provided. This may be because you have two nested VirtualizedLists with the same orientation, or because you are using a custom component that does not implement scrollTo.")
		else
			self._scrollRef.scrollTo(horizontal and { x = v8, animated = animated } or {
				y = v8,
				animated = animated
			})
		end
	else
		invariant(
			Boolean.toJSBoolean(onScrollToIndexFailed),
			"scrollToIndex should be used in conjunction with getItemLayout or onScrollToIndexFailed, otherwise there is no way to know the location of offscreen indices or handle failures."
		)

		onScrollToIndexFailed({
			averageItemLength = self._averageCellLength,
			highestMeasuredFrameIndex = self._highestMeasuredFrameIndex,
			index = index
		})
	end
end

function extended:scrollToItem(p)
	local item = p.item
	local data = self.props.data
	local getItem = self.props.getItem
	local itemCount = self.props.getItemCount(data)
	local v7 = 1

	while v7 <= itemCount do
		if getItem(data, v7) == item then
			self:scrollToIndex(Object.assign({}, p, { index = v7 }))
			break
		end

		v7 += 1
	end
end

function extended:scrollToOffset(p)
	local current

	if self:getScrollRef() then
		current = self:getScrollRef()._nativeRef.current
	end

	if current == nil then
		return
	end

	local animated = p.animated
	local v7 = p.offset

	if self._scrollRef == nil then
		return
	end

	if self.props.inverted then
		local absoluteCanvasSize = current.AbsoluteCanvasSize
		local absoluteSize = current.AbsoluteSize
		local v8

		if self.props.horizontal then
			v8 = absoluteCanvasSize.X
		else
			v8 = absoluteCanvasSize.Y
		end

		local v9 = v8 - v7
		local v10

		if self.props.horizontal then
			v10 = absoluteSize.X
		else
			v10 = absoluteSize.Y
		end

		v7 = v9 - v10
	end

	if self._scrollRef.scrollTo == nil then
		console.warn("No scrollTo method provided. This may be because you have two nested VirtualizedLists with the same orientation, or because you are using a custom component that does not implement scrollTo.")

		return
	end

	self._scrollRef.scrollTo(horizontalOrDefault(self.props.horizontal) and { -- inferred equivalent call
		x = v7,
		animated = animated
	} or { y = v7, animated = animated })
end

function extended:recordInteraction()
	self._nestedChildLists:forEach(function(p)
		if p.ref then
			p.ref:recordInteraction()
		end
	end)
	Array.forEach(self._viewabilityTuples, function(p)
		p.viewabilityHelper:recordInteraction()
	end)
	self:_updateViewableItems(self.props.data)
end

function extended:flashScrollIndicators()
	if self._scrollRef == nil then
		return
	end

	self._scrollRef:flashScrollIndicators()
end

function extended:getScrollResponder()
	if self._scrollRef and self._scrollRef.getScrollResponder then
		return self._scrollRef:getScrollResponder()
	end

	return nil
end

function extended:getScrollableNode()
	if self._scrollRef and self._scrollRef.getScrollableNode then
		return self._scrollRef:getScrollableNode()
	end

	return v2.findNodeHandle(self._scrollRef)
end

function extended:getScrollRef()
	if self._scrollRef and self._scrollRef.getScrollRef then
		return self._scrollRef:getScrollRef()
	end

	return self._scrollRef
end

function extended:setNativeProps(p)
	if self._scrollRef then
		self._scrollRef:setNativeProps(p)
	end
end

function extended:_getCellKey()
	if self.context and self.context.cellKey then
		return self.context.cellKey
	end

	return "rootList"
end

function extended:_getListKey()
	if Boolean.toJSBoolean(self.props.listKey) then
		return self.props.listKey
	end

	return (self:_getCellKey())
end

function extended:_getDebugInfo()
	local debugInfo = {
		listKey = self:_getListKey(),
		cellKey = self:_getCellKey(),
		horizontal = horizontalOrDefault(self.props.horizontal), -- inferred equivalent call
		parent = 0
	}
	local parent3

	if self.context then
		parent3 = self.context.debugInfo
	end

	debugInfo.parent = parent3
	return debugInfo
end

function extended:hasMore()
	return self._hasMore
end

function extended:componentDidMount()
	if self:_isNestedWithSameOrientation() then
		self.context.registerAsNestedChild({
			cellKey = self:_getCellKey(),
			key = self:_getListKey(),
			ref = self,
			parentDebugInfo = self.context.debugInfo
		})
	end
end

function extended:componentWillUnmount()
	if self:_isNestedWithSameOrientation() then
		self.context.unregisterAsNestedChild({
			key = self:_getListKey(),
			state = { first = self.state.first, last = self.state.last, frames = self._frames }
		})
	end

	self:_updateViewableItems(nil)
	self._updateCellsToRenderBatcher:dispose({ abort = true })
	Array.forEach(self._viewabilityTuples, function(p)
		p.viewabilityHelper:dispose()
	end)
	self._fillRateHelper:deactivateAndFlush()
end

function extended.getDerivedStateFromProps(data, data2)
	local data3 = data.data
	local getItemCount = data.getItemCount
	local maintainVisibleContentPosition = data.maintainVisibleContentPosition
	local firstItemTracked = data2.firstItemTracked
	local scrollPositionDelta = data2.scrollPositionDelta
	local compareItemData = data.compareItemData
	local fn2 = compareItemData == nil and function(p, p2): boolean
		return p == p2
	end or compareItemData
	local v7

	if data3 and getItemCount(data3) > 0 then
		v7 = data.getItem(data3, 1)
	end

	local function findItem(data4, firstItemTracked2)
		local v8 = nil

		for i = 1, #data4 do
			if fn2(data4[i], firstItemTracked2) then
				v8 = i
				break
			end
		end

		return if v8 == nil then 1 else v8
	end

	if maintainVisibleContentPosition and scrollPositionDelta == 0 and firstItemTracked ~= nil and v7 ~= nil then
		scrollPositionDelta = fn2(firstItemTracked, v7) and 0 or findItem(data3, firstItemTracked) - 1
	end

	local itemCount = getItemCount(data3)
	local v8 = maxToRenderPerBatchOrDefault(data.maxToRenderPerBatch) -- inferred equivalent call
	local first = math.max(1, (math.min(data2.first, itemCount - v8)))

	if itemCount > 0 and itemCount < first + scrollPositionDelta then
		console.warn("WARNING: maintainVisibleContentPosition failed because scrollPositionDelta was out of bounds. This could indicate that items in `data` are getting removed, items are getting added to the middle of `data`, or a different `data` array is getting passed in. Consider changing the `key` prop of the List if the `data` prop is significantly altered.")
		scrollPositionDelta = 0
	end

	if scrollPositionDelta > 0 then
		for i = 1, math.min(scrollPositionDelta, itemCount) do
			local item = data.getItem(data3, i)
			item.shouldResizeOnMount = true
		end
	end

	return {
		first = first,
		last = math.max(1, (math.min(data2.last, itemCount))),
		firstItemTracked = v7 or Object.None,
		scrollPositionDelta = scrollPositionDelta
	}
end

function extended:_pushCells(list, list2, object, count: number, p: number, inversionStyle)
	local cellRendererComponent = self.props.CellRendererComponent
	local itemSeparatorComponent = self.props.ItemSeparatorComponent
	local data = self.props.data
	local getItem = self.props.getItem
	local getItemCount = self.props.getItemCount
	local horizontal = self.props.horizontal
	local v7 = self.props.ListHeaderComponent and 1 or 0
	local itemCount = getItemCount(data)

	local v8 = math.min(itemCount, p)
	local prevCellKey = nil

	while count <= v8 do
		local item = getItem(data, count)

		local keyExtractor2 = self:_keyExtractor(item, count)
		self._indicesToKeys:set(count, keyExtractor2)

		if object:has(count + v7) then
			table.insert(list2, #list)
		end

		local createElement = React.createElement
		local v9 = v4
		local itemSeparatorComponent2

		if count < itemCount then
			itemSeparatorComponent2 = itemSeparatorComponent
		end

		local v10 = {
			CellRendererComponent = cellRendererComponent,
			ItemSeparatorComponent = itemSeparatorComponent2,
			cellKey = keyExtractor2,
			fillRateHelper = self._fillRateHelper,
			horizontal = horizontal,
			index = count,
			inversionStyle = inversionStyle,
			item = item,
			key = keyExtractor2,
			prevCellKey = prevCellKey,
			onUpdateSeparators = self._onUpdateSeparators,
			onLayout = 0,
			onUnmount = 0,
			parentProps = 0,
			ref = 0,
			isSequentiallySelectable = 0
		}
		local v11 = count
		v10.onLayout = not v and function(p2)
			return self:_onCellLayout(p2, keyExtractor2, v11)
		end or self:_getCellLayoutHandler(keyExtractor2, count)

		v10.onUnmount = self._onCellUnmount
		v10.parentProps = self.props
		v10.ref = not v and function(p2)
			self._cellRefs[tostring(keyExtractor2)] = p2
		end or self:_getCellRefHandler(keyExtractor2)
		v10.isSequentiallySelectable = self.props.isSequentiallySelectable
		table.insert(list, createElement(v9, v10))

		count += 1
		prevCellKey = keyExtractor2
	end
end

function extended:_isVirtualizationDisabled()
	return self.props.disableVirtualization ~= nil and self.props.disableVirtualization
end

function extended:_isNestedWithSameOrientation(): boolean
	local context = self.context

	if context == nil then
		return false
	end

	return Boolean.toJSBoolean(context.horizontal) == horizontalOrDefault(self.props.horizontal) -- inferred equivalent call
end

function extended:_keyExtractor(p, p2: number)
	if self.props.keyExtractor ~= nil then
		return self.props.keyExtractor(p, p2)
	end

	local v7 = keyExtractor(p, p2)

	if v7 == tostring(p2) then
		v5 = true

		if p.type ~= nil and Boolean.toJSBoolean(p.type.displayName) then
			v6 = p.type.displayName
		end
	end

	return v7
end

function extended:render()
	if _G.__DEV__ then
		local v7 = fn(self.props.contentContainerStyle)

		if v7 ~= nil and v7.flexWrap == "wrap" then
			console.warn("`flexWrap: `wrap`` is not supported with the `VirtualizedList` components.Consider using `numColumns` with `FlatList` instead.")
		end
	end

	local listEmptyComponent = self.props.ListEmptyComponent
	local listFooterComponent = self.props.ListFooterComponent
	local listHeaderComponent = self.props.ListHeaderComponent
	local data = self.props.data
	local horizontal = self.props.horizontal

	local virtualizationDisabled = self:_isVirtualizationDisabled()
	local v7

	if self.props.inverted then
		if horizontalOrDefault(self.props.horizontal) then -- inferred equivalent call
			v7 = v3.horizontallyInverted
		else
			v7 = v3.verticallyInverted
		end
	end

	local children = {}
	local v8 = Set.new(self.props.stickyHeaderIndices)
	local stickyHeaderIndices = {}

	if listHeaderComponent then
		if v8:has(0) then
			table.insert(stickyHeaderIndices, 0)
		end

		local v9

		if React.isValidElement(listHeaderComponent) then
			v9 = listHeaderComponent
		else
			v9 = React.createElement(listHeaderComponent, nil)
		end

		local createElement = React.createElement

		local v10 = {
			cellKey = self:_getCellKey() .. "-header",
			key = "$header",
			Name = "$header"
		}
		local createElement2 = React.createElement

		local listHeaderComponent2 = {
			Name = "ListHeaderComponent",
			onLayout = self._onLayoutHeader,
			style = StyleSheet.compose(v7, self.props.ListHeaderComponentStyle),
			LayoutOrder = self.props.inverted and 999999998 or -999999998,
			AutomaticSize = 0,
			Size = 0
		}
		local automaticSize

		if horizontal then
			automaticSize = Enum.AutomaticSize.X
		else
			automaticSize = Enum.AutomaticSize.Y
		end

		listHeaderComponent2.AutomaticSize = automaticSize
		local size

		if horizontal then
			size = UDim2.new(0, 0, 1, 0)
		else
			size = UDim2.new(1, 0, 0, 0)
		end

		listHeaderComponent2.Size = size
		table.insert(
			children,
			createElement(VirtualizedListCellContextProvider, v10, createElement2(View, listHeaderComponent2, v9))
		)
	end

	local itemCount = self.props.getItemCount(data)

	if itemCount > 0 then
		v5 = false
		v6 = ""
		local spacerKey = self._getSpacerKey(not horizontal)

		local indexTruthy = isIndexTruthy(self.props.initialScrollIndex) -- inferred equivalent call
		local v9

		if indexTruthy then
			v9 = -1
		else
			v9 = initialNumToRenderOrDefault(self.props.initialNumToRender) - 1 -- inferred equivalent call
		end

		local v10 = v9 + 1

		local first = self.state.first
		local last = self.state.last
		local scrollPositionDelta = self.state.scrollPositionDelta

		if scrollPositionDelta > 0 then
			first += scrollPositionDelta
			last += scrollPositionDelta
		end

		self:_pushCells(children, stickyHeaderIndices, v8, 1, v10, v7)
		local v11 = math.max(v10 + 1, first)

		if not virtualizationDisabled and v10 + 1 < first then
			local v12 = false

			if v8.size > 0 then
				local v13 = v11 - 1
				local v14 = listHeaderComponent and 1 or 0

				while v10 < v13 do
					if v8:has(v13 + v14) then
						local frameMetricsApprox = self._getFrameMetricsApprox(v10)
						local frameMetricsApprox2 = self._getFrameMetricsApprox(v13)
						local v15 = frameMetricsApprox2.offset - frameMetricsApprox.offset - (isIndexTruthy(self.props.initialScrollIndex) and 0 or frameMetricsApprox.length) -- inferred equivalent call

						local createElement = React.createElement
						local size

						if spacerKey == "height" then
							size = UDim2.new(1, 0, 0, v15)
						else
							size = UDim2.new(0, v15, 1, 0)
						end

						table.insert(children, createElement(View, {
							key = "$sticky_lead",
							Name = "$sticky_lead",
							style = { Size = size }
						}))

						self:_pushCells(children, stickyHeaderIndices, v8, v13, v13, v7)
						local v16 = self._getFrameMetricsApprox(first).offset - frameMetricsApprox2.offset + frameMetricsApprox2.length

						local createElement2 = React.createElement
						local size2

						if spacerKey == "height" then
							size2 = UDim2.new(1, 0, 0, v16)
						else
							size2 = UDim2.new(0, v16, 1, 0)
						end

						table.insert(children, createElement2(View, {
							key = "$sticky_trail",
							Name = "$sticky_trail",
							style = { Size = size2 }
						}))
						v12 = true
						break
					end

					v13 -= 1
				end
			end

			if not v12 then
				local frameMetricsApprox = self._getFrameMetricsApprox(v10)
				local v13 = self._getFrameMetricsApprox(first).offset - (frameMetricsApprox.offset + frameMetricsApprox.length)

				local createElement = React.createElement
				local size

				if spacerKey == "height" then
					size = UDim2.new(1, 0, 0, v13)
				else
					size = UDim2.new(0, v13, 1, 0)
				end

				local lead_spacer = {
					key = "$lead_spacer",
					Name = "$lead_spacer",
					style = { Size = size },
					LayoutOrder = self.props.inverted and 999999999 or -999999999
				}
				table.insert(children, createElement(View, lead_spacer))
			end
		end

		self:_pushCells(children, stickyHeaderIndices, v8, v11, last, v7)

		if not self._hasWarned.keys and v5 then
			console.warn(
				"VirtualizedList: missing keys for items, make sure to specify a key or id property on each item or provide a custom keyExtractor.",
				v6
			)

			self._hasWarned.keys = true
		end

		if not virtualizationDisabled and last < itemCount then
			local frameMetricsApprox = self._getFrameMetricsApprox(last)
			local v12

			if self.props.getItemLayout then
				v12 = itemCount
			else
				v12 = math.min(itemCount, self._highestMeasuredFrameIndex)
			end

			local frameMetricsApprox2 = self._getFrameMetricsApprox(v12)

			local v13 = frameMetricsApprox2.offset + frameMetricsApprox2.length - (frameMetricsApprox.offset + frameMetricsApprox.length)

			local createElement = React.createElement
			local size

			if spacerKey == "height" then
				size = UDim2.new(1, 0, 0, v13)
			else
				size = UDim2.new(0, v13, 1, 0)
			end

			local tail_spacer = {
				key = "$tail_spacer",
				Name = "$tail_spacer",
				style = { Size = size },
				LayoutOrder = self.props.inverted and -999999999 or 999999999
			}
			table.insert(children, createElement(View, tail_spacer))
		end
	elseif listEmptyComponent then
		if not React.isValidElement(listEmptyComponent) then
			listEmptyComponent = React.createElement(listEmptyComponent, nil)
		end

		table.insert(children, React.cloneElement(listEmptyComponent, {
			key = "$empty",
			Name = "$empty",
			onLayout = function(p)
				self._onLayoutEmpty(p)

				if listEmptyComponent.props.onLayout then
					listEmptyComponent.props.onLayout(p)
				end
			end,
			style = StyleSheet.compose(v7, listEmptyComponent.props.style)
		}))
	end

	if listFooterComponent then
		if not React.isValidElement(listFooterComponent) then
			listFooterComponent = React.createElement(listFooterComponent, nil)
		end

		local createElement = React.createElement

		local v9 = { cellKey = self:_getFooterCellKey(), key = "$footer", Name = "$footer" }
		local createElement2 = React.createElement

		local listFooterComponent2 = {
			Name = "ListFooterComponent",
			onLayout = self._onLayoutFooter,
			style = StyleSheet.compose(v7, self.props.ListFooterComponentStyle),
			LayoutOrder = self.props.inverted and -999999998 or 999999998,
			AutomaticSize = 0,
			Size = 0
		}
		local automaticSize

		if horizontal then
			automaticSize = Enum.AutomaticSize.X
		else
			automaticSize = Enum.AutomaticSize.Y
		end

		listFooterComponent2.AutomaticSize = automaticSize
		local size

		if horizontal then
			size = UDim2.new(0, 0, 1, 0)
		else
			size = UDim2.new(1, 0, 0, 0)
		end

		listFooterComponent2.Size = size
		table.insert(
			children,
			createElement(
				VirtualizedListCellContextProvider,
				v9,
				createElement2(View, listFooterComponent2, listFooterComponent)
			)
		)
	end

	if self.props.inverted and not self.props.getItemLayout then
		if self:getScrollRef() == nil or self:getScrollRef()._nativeRef.current == nil then
			local canvasPosition

			if self.props.horizontal then
				canvasPosition = Vector2.new(self._invertedCanvasLength, 0)
			else
				canvasPosition = Vector2.new(0, self._invertedCanvasLength)
			end

			self._canvasPosition = canvasPosition
			local canvasSize

			if self.props.horizontal then
				canvasSize = UDim2.new(0, self._invertedCanvasLength, 1, 0)
			else
				canvasSize = UDim2.new(1, 0, 0, self._invertedCanvasLength)
			end

			self._canvasSize = canvasSize
		else
			local current = self:getScrollRef()._nativeRef.current
			local canvasPosition = current.CanvasPosition
			local frameMetricsApprox = self._getFrameMetricsApprox((math.min(self._highestMeasuredFrameIndex, itemCount)))
			local v9 = frameMetricsApprox.offset + frameMetricsApprox.length
			local v10

			if self.props.optimizeInvertedCanvasResize then
				v10 = self._invertedCanvasLength - self._footerLength < v9
			else
				v10 = v9 ~= self._invertedCanvasLength - self._footerLength
			end

			if
				itemCount <= self._highestMeasuredFrameIndex
				and v9 ~= self._invertedCanvasLength - self._footerLength
			then
				local v11 = v9 + self._footerLength - self._invertedCanvasLength
				self._invertedCanvasLength = v9 + self._footerLength
				local udim

				if self.props.horizontal then
					udim = UDim2.new(0, self._invertedCanvasLength, 1, 0)
				else
					udim = UDim2.new(1, 0, 0, self._invertedCanvasLength)
				end

				current.CanvasSize = udim
				local canvasPosition2

				if self.props.horizontal then
					canvasPosition2 = Vector2.new(canvasPosition.X + v11, canvasPosition.Y)
				else
					canvasPosition2 = Vector2.new(canvasPosition.X, canvasPosition.Y + v11)
				end

				self._canvasPosition = canvasPosition2

				self._canvasSize = udim
			elseif v10 and self.state.scrollPositionDelta == 0 then
				local invertedCanvasLength = self._invertedCanvasLength
				local v11 = self._scrollMetrics.visibleLength * windowSizeOrDefault(self.props.windowSize) * 0.5 -- inferred equivalent call
				local invertedCanvasLength2 = frameMetricsApprox.offset + self._scrollMetrics.visibleLength + v11
				local v12 = invertedCanvasLength2 - invertedCanvasLength
				self._invertedCanvasLength = invertedCanvasLength2
				local udim

				if self.props.horizontal then
					udim = UDim2.new(0, self._invertedCanvasLength, 1, 0)
				else
					udim = UDim2.new(1, 0, 0, self._invertedCanvasLength)
				end

				current.CanvasSize = udim
				local canvasPosition2

				if self.props.horizontal then
					canvasPosition2 = Vector2.new(canvasPosition.X + v12, canvasPosition.Y)
				else
					canvasPosition2 = Vector2.new(canvasPosition.X, canvasPosition.Y + v12)
				end

				current.CanvasPosition = canvasPosition2

				self._canvasPosition = current.CanvasPosition
				self._canvasSize = udim
			end
		end
	elseif self.props.inverted and self.props.getItemLayout then
		local frameMetricsApprox = self._getFrameMetricsApprox(itemCount)

		if self:getScrollRef() == nil or self:getScrollRef()._nativeRef.current == nil then
			self._invertedCanvasLength = frameMetricsApprox.offset + frameMetricsApprox.length
		else
			local current = self:getScrollRef()._nativeRef.current
			local canvasPosition = current.CanvasPosition
			local invertedCanvasLength = self._invertedCanvasLength
			self._invertedCanvasLength = frameMetricsApprox.offset + frameMetricsApprox.length

			if invertedCanvasLength ~= self._invertedCanvasLength then
				local v9 = self._invertedCanvasLength - invertedCanvasLength
				local canvasPosition2

				if self.props.horizontal then
					canvasPosition2 = canvasPosition + Vector2.new(v9, 0)
				else
					canvasPosition2 = canvasPosition + Vector2.new(0, v9)
				end

				current.CanvasPosition = canvasPosition2
			end
		end
	end

	local assign = Object.assign
	local clone = table.clone(self.props)
	local v9 = {
		onContentSizeChange = self._onContentSizeChange,
		onLayout = self._onLayout,
		onScroll = self._onScroll,
		onScrollBeginDrag = self._onScrollBeginDrag,
		onScrollEndDrag = self._onScrollEndDrag,
		onMomentumScrollBegin = self._onMomentumScrollBegin,
		onMomentumScrollEnd = self._onMomentumScrollEnd,
		scrollEventThrottle = scrollEventThrottleOrDefault(self.props.scrollEventThrottle), -- inferred equivalent call
		invertStickyHeaders = 0,
		stickyHeaderIndices = 0,
		style = 0,
		layoutStyle = 0,
		AutomaticCanvasSize = 0,
		CanvasSize = 0,
		CanvasPosition = 0
	}
	local invertStickyHeaders

	if self.props.invertStickyHeaders == nil then
		invertStickyHeaders = self.props.inverted
	else
		invertStickyHeaders = self.props.invertStickyHeaders
	end

	v9.invertStickyHeaders = invertStickyHeaders

	v9.stickyHeaderIndices = stickyHeaderIndices

	v9.style = self.props.style

	v9.layoutStyle = v7 or nil
	local automaticCanvasSize

	if self.props.inverted and not self.props.getItemLayout then
		automaticCanvasSize = Enum.AutomaticSize.None
	end

	v9.AutomaticCanvasSize = automaticCanvasSize
	local canvasSize

	if self.props.inverted then
		canvasSize = self._canvasSize
	end

	v9.CanvasSize = canvasSize
	local canvasPosition

	if self.props.inverted then
		canvasPosition = self._canvasPosition
	end

	v9.CanvasPosition = canvasPosition
	local v10 = assign(clone, v9)

	self._hasMore = self.state.last < self.props.getItemCount(self.props.data)
	local createElement = React.createElement

	local v11 = {
		value = {
			cellKey = nil,
			getScrollMetrics = self._getScrollMetrics,
			horizontal = horizontalOrDefault(self.props.horizontal), -- inferred equivalent call
			getOutermostParentListRef = self._getOutermostParentListRef,
			getNestedChildState = self._getNestedChildState,
			registerAsNestedChild = self._registerAsNestedChild,
			unregisterAsNestedChild = self._unregisterAsNestedChild,
			debugInfo = self:_getDebugInfo()
		}
	}

	local cloneElement = React.cloneElement
	local v12

	if self.props.renderScrollComponent then
		v12 = self.props.renderScrollComponent
	else
		v12 = self._defaultRenderScrollComponent
	end

	local element = createElement(
		VirtualizedListContextProvider,
		v11,
		cloneElement(v12(v10), { ref = self._captureScrollRef }, children)
	)
	local v13

	if _G.__DEV__ then
		v13 = React.createElement(ScrollView.Context.Consumer, nil, function(p)
			if p == nil then
				return element
			end

			if
				not p.horizontal == not horizontalOrDefault(self.props.horizontal) -- inferred equivalent call
				and not self._hasWarned.nesting
				and self.context == nil
			then
				console.error("VirtualizedLists should never be nested inside plain ScrollViews with the same orientation because it can break windowing and other functionality - use another VirtualizedList-backed container instead.")

				self._hasWarned.nesting = true
			end

			return element
		end)
	else
		v13 = element
	end

	if self.props.debug then
		return React.createElement(View, { style = v3.debug, Name = "debug" }, v13, self:_renderDebugOverlay())
	end

	return v13
end

function extended:componentDidUpdate(p)
	local data = self.props.data
	local extraData = self.props.extraData

	if data ~= p.data or extraData ~= p.extraData then
		Array.forEach(self._viewabilityTuples, function(p2)
			p2.viewabilityHelper:resetViewableIndices()
		end)
	end

	local hiPriInProgress = self._hiPriInProgress
	self:_scheduleCellsToRenderUpdate()

	if hiPriInProgress then
		self._hiPriInProgress = false
	end
end

function extended:_computeBlankness()
	self._fillRateHelper:computeBlankness(self.props, self.state, self._scrollMetrics)
end

function extended:_getCellLayoutHandler(p: string, p2: number)
	local cellLayoutHandler = self._cellLayoutHandlers[p]

	if cellLayoutHandler ~= nil and cellLayoutHandler.index == p2 then
		return cellLayoutHandler.handler
	end

	local function fn2(p3)
		return self:_onCellLayout(p3, p, p2)
	end

	self._cellLayoutHandlers[p] = { index = p2, handler = fn2 }
	return fn2
end

function extended:_getCellRefHandler(p: string)
	local cellRefHandler = self._cellRefHandlers[p]

	if cellRefHandler == nil then
		cellRefHandler = function(p2)
			self._cellRefs[tostring(p)] = p2
		end
		self._cellRefHandlers[p] = cellRefHandler
	end

	return cellRefHandler
end

function extended:_onCellLayout(instance, p: string, p2: number)
	local v7

	if self:getScrollRef() and self:getScrollRef()._nativeRef.current then
		v7 = self:getScrollRef()._nativeRef.current
	else
		v7 = instance:FindFirstAncestorOfClass("ScrollingFrame")
	end

	if v7 == nil then
		if _G.__DEV__ then
			console.warn("CellLayout failed for index " .. tostring(p2) .. ". this may cause layout issues")
		end
	else
		local absolutePosition = v7.AbsolutePosition
		local canvasPosition = v7.CanvasPosition
		local absoluteCanvasSize = v7.AbsoluteCanvasSize

		local absoluteSize = instance.AbsoluteSize
		local absolutePosition2 = instance.AbsolutePosition
		local v8

		if self.props.inverted and self.props.horizontal then
			v8 = absoluteCanvasSize.X - canvasPosition.X - absolutePosition2.X - absoluteSize.X + absolutePosition.X
		else
			v8 = absolutePosition2.X - absolutePosition.X + canvasPosition.X
		end

		local v9

		if self.props.inverted and not self.props.horizontal then
			v9 = absoluteCanvasSize.Y - canvasPosition.Y - absolutePosition2.Y - absoluteSize.Y + absolutePosition.Y
		else
			v9 = absolutePosition2.Y - absolutePosition.Y + canvasPosition.Y
		end

		local v10 = {
			width = instance.AbsoluteSize.X,
			height = instance.AbsoluteSize.Y,
			x = v8,
			y = v9
		}

		local v11 = {
			offset = self:_selectOffset(v10),
			length = self:_selectLength(v10),
			index = p2,
			inLayout = true
		}

		local frame = self._frames[p]

		if
			frame
			and not (math.abs(v11.offset - frame.offset) > 1)
			and v11.length == frame.length
			and p2 == frame.index
		then
			self._frames[p].inLayout = true
		else
			local item = self.props.getItem(self.props.data, p2)

			if not frame and not self.props.getItemLayout and typeof(item) == "table" and item.shouldResizeOnMount then
				self:recalculateFrames(self:_selectLength(v10), p, p2)
			end

			if frame and not self.props.getItemLayout and math.abs(v11.length - frame.length) >= 1 then
				if self.props.UNSTABLE_forceSiblingLayoutUpdate then
					local frame2 = instance:FindFirstAncestorOfClass("Frame")
					local v12 = not frame2 and {} or frame2:GetChildren()
					local itemCount = self.props.getItemCount(self.props.data)
					Array.forEach(v12, function(guiObject)
						if not guiObject:IsA("GuiObject") then
							return
						end

						local layoutOrder = math.abs(guiObject.LayoutOrder)

						if layoutOrder <= p2 or itemCount < layoutOrder then
							return
						end

						local item2 = self.props.getItem(self.props.data, layoutOrder)

						if item2 == nil then
							return
						end

						self:_onCellLayout(guiObject, self:_keyExtractor(item2, layoutOrder), layoutOrder)
					end)
				else
					Array.forEach(Object.keys(self._frames), function(p3)
						if self._frames[p3].index <= p2 then
							return
						end

						local v12

						if self._cellRefs[p3] then
							v12 = self._cellRefs[p3]:getRef()
						end

						if v12 and v12.current then
							self:_onCellLayout(v12.current, p3, self._frames[p3].index)
						end
					end)
				end
			end

			self._totalCellLength += v11.length - (not Boolean.toJSBoolean(frame) and 0 or frame.length)
			self._totalCellsMeasured += Boolean.toJSBoolean(frame) and 0 or 1
			self._averageCellLength = self._totalCellLength / self._totalCellsMeasured
			self._frames[p] = v11
			self._highestMeasuredFrameIndex = math.max(self._highestMeasuredFrameIndex, p2)
			self:_scheduleCellsToRenderUpdate()

			if
				self.props.inverted
				and not self.props.getItemLayout
				and self.state.last == self.props.getItemCount(self.props.data)
				and self._highestMeasuredFrameIndex == self.state.last
			then
				self:forceUpdate()
			end
		end

		self:_triggerRemeasureForChildListsInCell(p)

		self:_computeBlankness()
		self:_updateViewableItems(self.props.data)
	end
end

function extended:_triggerRemeasureForChildListsInCell(p: string)
	local v7 = self._cellKeysToChildListKeys:get(p)

	if v7 then
		v7:forEach(function(p2)
			local v8 = self._nestedChildLists:get(p2)

			if v8 and v8.ref then
				v8.ref:measureLayoutRelativeToContainingList()
			end
		end)
	end
end

function extended:recalculateFrames(p: number, p2: string, p3: number)
	Array.forEach(Object.keys(self._frames), function(p4)
		if p4 == p2 and p3 <= self._frames[p4].index then
			return
		end

		self._frames[p4].index += 1
		self._frames[p4].offset += p
	end)
	self._highestMeasuredFrameIndex += 1
end

function extended:measureLayoutRelativeToContainingList()
	local success, result = pcall(function(): nil
		if not Boolean.toJSBoolean(self._scrollRef) then
			return nil
		end

		self._scrollRef:measureLayout(
			self.context.getOutermostParentListRef():getScrollRef(),
			function(p, p2, width, height)
				self._offsetFromParentVirtualizedList = self:_selectOffset({ x = p, y = p2 })
				self._scrollMetrics.contentLength = self:_selectLength({
					width = width,
					height = height
				})
				local convertParentScrollMetrics = self._convertParentScrollMetrics(self.context.getScrollMetrics())

				if
					self._scrollMetrics.visibleLength ~= convertParentScrollMetrics.visibleLength
					or self._scrollMetrics.offset ~= convertParentScrollMetrics.offset
				then
					self._scrollMetrics.visibleLength = convertParentScrollMetrics.visibleLength
					self._scrollMetrics.offset = convertParentScrollMetrics.offset

					self._cellKeysToChildListKeys:forEach(function(object)
						if object then
							object:forEach(function(p3)
								local v7 = self._nestedChildLists:get(p3)

								if v7 and v7.ref then
									v7.ref:measureLayoutRelativeToContainingList()
								end
							end)
						end
					end)
				end
			end,
			function(_)
				console.warn("VirtualizedList: Encountered an error while measuring a list's offset from its containing VirtualizedList.")
			end
		)

		return nil
	end)

	if not success then
		console.warn("measureLayoutRelativeToContainingList threw an error", result.stack)
	end
end

function extended:_getFooterCellKey()
	return self:_getCellKey() .. "-footer"
end

function extended:_renderDebugOverlay()
	local v7 = self._scrollMetrics.visibleLength / (not Boolean.toJSBoolean(self._scrollMetrics.contentLength) and 1 or self._scrollMetrics.contentLength)

	local itemCount = self.props.getItemCount(self.props.data)
	local v8 = 1
	local frameMetricsApproxes = {}

	while v8 <= itemCount do
		local frameMetricsApprox = self._getFrameMetricsApprox(v8)

		if Boolean.toJSBoolean(frameMetricsApprox.inLayout) then
			table.insert(frameMetricsApproxes, frameMetricsApprox)
		end

		v8 += 1
	end

	local offset = self._getFrameMetricsApprox(self.state.first).offset
	local frameMetricsApprox = self._getFrameMetricsApprox(self.state.last)
	local v9 = frameMetricsApprox.offset + frameMetricsApprox.length - offset
	local offset2 = self._scrollMetrics.offset
	local visibleLength = self._scrollMetrics.visibleLength

	return React.createElement(View, {
		style = { v3.debugOverlayBase, v3.debugOverlay }
	}, Array.map(frameMetricsApproxes, function(p, p2: number)
		return React.createElement(View, {
			key = "f" .. tostring(p2),
			Name = "f" .. tostring(p2),
			style = {
				v3.debugOverlayBase,
				v3.debugOverlayFrame,
				{
					top = p.offset * v7,
					height = p.length * v7
				}
			}
		})
	end), React.createElement(View, {
		Name = "DebugOverlayLast",
		style = {
			v3.debugOverlayBase,
			v3.debugOverlayFrameLast,
			{
				top = offset * v7,
				height = v9 * v7
			}
		}
	}), React.createElement(View, {
		Name = "DebugOverlayVis",
		style = {
			v3.debugOverlayBase,
			v3.debugOverlayFrameVis,
			{
				top = offset2 * v7,
				height = visibleLength * v7
			}
		}
	}))
end

function extended:_selectLength(p)
	if horizontalOrDefault(self.props.horizontal) then -- inferred equivalent call
		return p.width
	end

	return p.height
end

function extended:_selectOffset(p)
	if horizontalOrDefault(self.props.horizontal) then -- inferred equivalent call
		return p.x
	end

	return p.y
end

function extended:_maybeCallOnEndReached()
	local data = self.props.data
	local getItemCount = self.props.getItemCount
	local onEndReached = self.props.onEndReached
	local onEndReachedThreshold = self.props.onEndReachedThreshold

	local contentLength = self._scrollMetrics.contentLength
	local visibleLength = self._scrollMetrics.visibleLength
	local offset = self._scrollMetrics.offset

	local distanceFromEnd = contentLength - visibleLength - offset
	local v7 = onEndReachedThreshold == nil and 2 or onEndReachedThreshold * visibleLength

	if
		onEndReached
		and self.state.last == getItemCount(data)
		and distanceFromEnd < v7
		and self._scrollMetrics.contentLength ~= self._sentEndForContentLength
	then
		self._sentEndForContentLength = self._scrollMetrics.contentLength
		onEndReached({ distanceFromEnd = distanceFromEnd })
	elseif v7 < distanceFromEnd then
		self._sentEndForContentLength = 0
	end
end

function extended:_scheduleCellsToRenderUpdate()
	local first = self.state.first
	local last = self.state.last

	if self.state.scrollPositionDelta > 0 then
		return
	end

	local offset = self._scrollMetrics.offset
	local visibleLength = self._scrollMetrics.visibleLength
	local velocity = self._scrollMetrics.velocity
	local itemCount = self.props.getItemCount(self.props.data)
	local v7 = false
	local v8 = onEndReachedThresholdOrDefault(self.props.onEndReachedThreshold) * visibleLength / 2 -- inferred equivalent call

	if first > 1 then
		local v9 = offset - self._getFrameMetricsApprox(first).offset

		if v9 < 0 then
			v7 = true
		elseif velocity < -2 then
			v7 = v9 < v8
		else
			v7 = false
		end
	end

	if last < itemCount then
		local v9 = self._getFrameMetricsApprox(last).offset - (offset + visibleLength)
		v7 = v7 or v9 < 0 or velocity > 2
	end

	if
		not (v7 and (Boolean.toJSBoolean(self._averageCellLength) or self.props.getItemLayout))
		or self._hiPriInProgress
	then
		self._updateCellsToRenderBatcher:schedule()

		return
	end

	self._hiPriInProgress = true

	self._updateCellsToRenderBatcher:dispose({ abort = true })
	self._updateCellsToRender()
end

function extended:_updateViewableItems(p)
	local getItemCount = self.props.getItemCount
	Array.forEach(self._viewabilityTuples, function(p2)
		p2.viewabilityHelper:onUpdate(
			getItemCount(p),
			self._scrollMetrics.offset,
			self._scrollMetrics.visibleLength,
			self._getFrameMetrics,
			self._createViewToken,
			p2.onViewableItemsChanged,
			self.state
		)
	end)
end

v4 = React.Component:extend("CellRenderer")

function v4:init(props)
	self.props = props

	self.state = {
		separatorProps = { highlighted = false, leadingItem = self.props.item }
	}

	self._separators = {
		highlight = function()
			local v7 = { self.props.cellKey, self.props.prevCellKey }
			self.props.onUpdateSeparators(v7, { highlighted = true })
		end,
		unhighlight = function()
			local v7 = { self.props.cellKey, self.props.prevCellKey }
			self.props.onUpdateSeparators(v7, { highlighted = false })
		end,
		updateProps = function(p: string, p2)
			local cellKey = self.props.cellKey
			local v7 = self.props.prevCellKey
			local onUpdateSeparators = self.props.onUpdateSeparators

			if p ~= "leading" then
				v7 = cellKey
			end

			onUpdateSeparators({ v7 }, p2)
		end
	}

	self._nativeRef = React.createRef()
end

function v4.getDerivedStateFromProps(p, p2)
	return {
		separatorProps = Object.assign({}, p2.separatorProps, { leadingItem = p.item })
	}
end

function v4:updateSeparatorProps(p)
	self:setState(function(p2)
		return {
			separatorProps = Object.assign({}, p2.separatorProps, p)
		}
	end)
end

local function shallowEqual(items, items2): boolean
	for k, item in items do
		if items2[k] ~= item then
			return false
		end
	end

	for k in items2 do
		if items[k] == nil then
			return false
		end
	end

	return true
end

function v4.shouldComponentUpdate(p, items, p2)
	if not v then
		return true
	end

	local props = p.props
	local flag = true
	local v7

	for k, v8 in props do
		if items[k] ~= v8 then
			v7 = false
			flag = false
			break
		end
	end

	if flag then
		local flag2 = true

		for k in items do
			if props[k] == nil then
				v7 = false
				flag2 = false
				break
			end
		end

		if flag2 then
			v7 = true
		end
	end

	local v8 = not v7

	if v8 then
		return v8
	end

	local separatorProps = p.state.separatorProps
	local separatorProps2 = p2.separatorProps
	local flag2 = true
	local v9

	for k, separatorProp in separatorProps do
		if separatorProps2[k] ~= separatorProp then
			v9 = false
			flag2 = false
			break
		end
	end

	if not flag2 then
		return not v9
	end

	local flag3 = true

	for k in separatorProps2 do
		if separatorProps[k] == nil then
			v9 = false
			flag3 = false
			break
		end
	end

	if flag3 then
		v9 = true
	end

	return not v9
end

function v4.componentWillUnmount(p)
	p.props.onUnmount(p.props.cellKey)
end

function v4:_renderElement(callback, p, p2, p3)
	if Boolean.toJSBoolean(callback) and Boolean.toJSBoolean(p) then
		console.warn("VirtualizedList: Both ListItemComponent and renderItem props are present. ListItemComponent will take precedence over renderItem.")
	end

	if Boolean.toJSBoolean(p) then
		return React.createElement(p, { item = p2, index = p3, separators = self._separators })
	end

	if Boolean.toJSBoolean(callback) then
		return callback({ item = p2, index = p3, separators = self._separators })
	end

	invariant(false, "VirtualizedList: Either ListItemComponent or renderItem props are required but none were found.")
	return nil
end

function v4:getRef()
	return self._nativeRef
end

function v4:render()
	local cellRendererComponent = self.props.CellRendererComponent
	local itemSeparatorComponent = self.props.ItemSeparatorComponent
	local fillRateHelper = self.props.fillRateHelper
	local horizontal = self.props.horizontal
	local item = self.props.item
	local index = self.props.index
	local inversionStyle = self.props.inversionStyle
	local parentProps = self.props.parentProps

	local renderItem = parentProps.renderItem
	local getItemLayout = parentProps.getItemLayout
	local element = self:_renderElement(renderItem, parentProps.ListItemComponent, item, index)
	local onLayout

	if not (getItemLayout and not (parentProps.debug or fillRateHelper:enabled())) then
		onLayout = self.props.onLayout
	end

	local v7 = itemSeparatorComponent
		and React.createElement(itemSeparatorComponent, Object.assign(self.state.separatorProps, {
			LayoutOrder = inversionStyle and -1 or 1
		}))
	local style

	if Boolean.toJSBoolean(inversionStyle) then
		if horizontal then
			style = { v3.rowReverse, inversionStyle }
		else
			style = { v3.columnReverse, inversionStyle }
		end
	else
		style = horizontal and { v3.row, inversionStyle } or inversionStyle
	end

	local v8

	if Boolean.toJSBoolean(cellRendererComponent) then
		local createElement = React.createElement

		local v9 = Object.assign(table.clone(self.props), {
			style = style,
			onLayout = onLayout,
			nativeRef = self._nativeRef
		})
		local v10

		if v7 then
			local createElement2 = React.createElement
			local v11 = { SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = 0 }
			local fillDirection

			if horizontal then
				fillDirection = Enum.FillDirection.Horizontal
			else
				fillDirection = Enum.FillDirection.Vertical
			end

			v11.FillDirection = fillDirection
			v10 = createElement2("UIListLayout", v11)
		end

		v8 = createElement(cellRendererComponent, v9, v10, element, v7)
	else
		local createElement = React.createElement

		if inversionStyle then
			index = -index
		end

		local automaticSize

		if horizontal then
			automaticSize = Enum.AutomaticSize.X
		else
			automaticSize = Enum.AutomaticSize.Y
		end

		local cellRendererView = {
			Name = "CellRendererView",
			style = style,
			onLayout = onLayout,
			LayoutOrder = index,
			AutomaticSize = automaticSize,
			nativeRef = self._nativeRef,
			SelectionGroup = self.props.isSequentiallySelectable and true or nil,
			SelectionBehaviorLeft = 0,
			SelectionBehaviorRight = 0,
			SelectionBehaviorUp = 0,
			SelectionBehaviorDown = 0
		}
		local selectionBehaviorLeft

		if self.props.isSequentiallySelectable then
			if self.props.horizontal then
				selectionBehaviorLeft = Enum.SelectionBehavior.Escape
			else
				selectionBehaviorLeft = Enum.SelectionBehavior.Stop
			end
		end

		cellRendererView.SelectionBehaviorLeft = selectionBehaviorLeft
		local selectionBehaviorRight

		if self.props.isSequentiallySelectable then
			if self.props.horizontal then
				selectionBehaviorRight = Enum.SelectionBehavior.Escape
			else
				selectionBehaviorRight = Enum.SelectionBehavior.Stop
			end
		end

		cellRendererView.SelectionBehaviorRight = selectionBehaviorRight
		local selectionBehaviorUp

		if self.props.isSequentiallySelectable then
			if self.props.horizontal then
				selectionBehaviorUp = Enum.SelectionBehavior.Stop
			else
				selectionBehaviorUp = Enum.SelectionBehavior.Escape
			end
		end

		cellRendererView.SelectionBehaviorUp = selectionBehaviorUp
		local selectionBehaviorDown

		if self.props.isSequentiallySelectable then
			if self.props.horizontal then
				selectionBehaviorDown = Enum.SelectionBehavior.Stop
			else
				selectionBehaviorDown = Enum.SelectionBehavior.Escape
			end
		end

		cellRendererView.SelectionBehaviorDown = selectionBehaviorDown
		local v9

		if v7 then
			local createElement2 = React.createElement
			local v10 = { SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = 0 }
			local fillDirection

			if horizontal then
				fillDirection = Enum.FillDirection.Horizontal
			else
				fillDirection = Enum.FillDirection.Vertical
			end

			v10.FillDirection = fillDirection
			v9 = createElement2("UIListLayout", v10)
		end

		v8 = createElement(View, cellRendererView, v9, element, v7)
	end

	return React.createElement(VirtualizedListCellContextProvider, { cellKey = self.props.cellKey }, v8)
end

describeNestedLists = function(data)
	local v7 = "VirtualizedList trace:\n" .. ("  Child (%s):\n"):format(Boolean.toJSBoolean(data.horizontal) and "horizontal" or "vertical") .. ("    listKey: %s\n"):format(data.key) .. ("    cellKey: %s"):format(data.cellKey)
	local v8 = data.parentDebugInfo

	while v8 do
		v7 ..= ("\n  Parent (%s):\n"):format(v8.horizontal and "horizontal" or "vertical") .. ("    listKey: %s\n"):format(v8.listKey) .. ("    cellKey: %s"):format(v8.cellKey)
		v8 = v8.parent
	end

	return v7
end

v3 = StyleSheet.create({
	verticallyInverted = {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Bottom
	},
	horizontallyInverted = {
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center
	},
	row = { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0) },
	column = { AutomaticSize = Enum.AutomaticSize.Y },
	rowReverse = {
		flexDirection = "row-reverse",
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0)
	},
	columnReverse = { flexDirection = "column-reverse", AutomaticSize = Enum.AutomaticSize.Y },
	debug = { flex = 1 },
	debugOverlayBase = { position = "absolute", top = 0, right = 0 },
	debugOverlay = { bottom = 0, width = 20, borderColor = "blue", borderWidth = 1 },
	debugOverlayFrame = { left = 0, backgroundColor = "orange" },
	debugOverlayFrameLast = { left = 0, borderColor = "green", borderWidth = 2 },
	debugOverlayFrameVis = { left = 0, borderColor = "red", borderWidth = 2 }
})

return extended
