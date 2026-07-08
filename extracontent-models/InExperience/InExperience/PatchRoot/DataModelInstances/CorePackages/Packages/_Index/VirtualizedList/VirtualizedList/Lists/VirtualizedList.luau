local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local console = LuauPolyfill.console

local function isIndexTruthy(n1: number?) -- line: 33
	return n1 ~= nil and n1 ~= 1
end

local Batchinator = require(ParentParent.Interaction.Batchinator)
local FillRateHelper = require(script.Parent.FillRateHelper)
local t1 = {
	findNodeHandle = function(_) -- line: 44
		warn("ReactNative.findNodeHandle is not implemented")
	end
}
local ScrollView = require(ParentParent.Components.ScrollView.ScrollView)
local StyleSheet = require(ParentParent.StyleSheet.StyleSheet)
local View = require(ParentParent.Components.View.View)
local ViewabilityHelper = require(script.Parent.ViewabilityHelper)

local function v18(...) -- line: 62
	return {}
end

local infoLog = require(ParentParent.Utilities.infoLog)
local invariant = require(ParentParent.jsUtils.invariant)
local VirtualizeUtils = require(script.Parent.VirtualizeUtils)
local keyExtractor = VirtualizeUtils.keyExtractor
local computeWindowedRenderLimits = VirtualizeUtils.computeWindowedRenderLimits
local React = require(ParentParentParent.React)

require(ParentParent.Components.ScrollView.ScrollView)

local VirtualizedListContext = require(script.Parent.VirtualizedListContext)
local VirtualizedListCellContextProvider = VirtualizedListContext.VirtualizedListCellContextProvider
local VirtualizedListContext2 = VirtualizedListContext.VirtualizedListContext
local VirtualizedListContextProvider = VirtualizedListContext.VirtualizedListContextProvider
local describeNestedLists = nil
local u30 = nil
local u31 = nil

local function RefreshControl(p2) -- line: 102
	-- upvalues: React (copy)
	return React.createElement("Frame", {
		Name = "RCTRefreshControl"
	}, p2.children)
end

local u33 = false
local s1 = ""

local function horizontalOrDefault(b1: boolean?) -- line: 408
	if b1 == nil then
		return false
	end

	return b1
end
local function initialNumToRenderOrDefault(n2: number?) -- line: 413
	if n2 == nil then
		return 10
	end

	return n2
end
local function maxToRenderPerBatchOrDefault(n3: number?) -- line: 418
	if n3 == nil then
		return 10
	end

	return n3
end
local function onEndReachedThresholdOrDefault(n4: number?) -- line: 423
	if n4 == nil then
		return 2
	end

	return n4
end
local function scrollEventThrottleOrDefault(n5: number?) -- line: 428
	if n5 == nil then
		return 50
	end

	return n5
end
local function windowSizeOrDefault(n6: number?) -- line: 433
	if n6 == nil then
		return 21
	end

	return n6
end
local function compareItemDataOrDefault(p3: ((...any) -> ...any)?) -- line: 444
	if p3 == nil then
		return function(p4, p5) -- line: 446
			return p4 == p5
		end
	end

	return p3
end

local v42 = React.PureComponent:extend("VirtualizedList")

v42.contextType = VirtualizedListContext2

function v42.init(p6, p7) -- line: 669
	-- upvalues: Map (copy), invariant (copy), FillRateHelper (copy), Boolean (copy), computeWindowedRenderLimits (copy), Batchinator (copy), Array (copy), ViewabilityHelper (copy), Object (copy), Set (copy), console (copy), describeNestedLists (ref), React (copy), View (copy), ScrollView (copy), RefreshControl (ref), infoLog (copy)
	p6.props = p7
	p6._viewabilityTuples = {}
	p6._averageCellLength = 0
	p6._cellKeysToChildListKeys = Map.new()
	p6._cellRefs = {}
	p6._frames = {}
	p6._footerLength = 0
	p6._hasDoneInitialScroll = false
	p6._hasInteracted = false
	p6._hasMore = false
	p6._hasWarned = {}
	p6._headerLength = 0
	p6._hiPriInProgress = false
	p6._highestMeasuredFrameIndex = 1
	p6._indicesToKeys = Map.new()
	p6._nestedChildLists = Map.new()
	p6._offsetFromParentVirtualizedList = 0
	p6._prevParentOffset = 0
	p6._scrollMetrics = {
		contentLength = 0,
		dOffset = 0,
		dt = 10,
		offset = 0,
		timestamp = 0,
		velocity = 0,
		visibleLength = 0
	}
	p6._scrollRef = nil
	p6._sentEndForContentLength = 0
	p6._totalCellLength = 0
	p6._totalCellsMeasured = 0
	p6._canvasPosition = Vector2.new(0, 0)
	p6._canvasSize = UDim2.new(0, 0, 0, 0)
	p6._invertedCanvasLength = if not p6.props.getItemLayout then p6.props.invertedCanvasLength or 1000 else 0

	function p6._getFrameMetrics(n7: number) -- line: 711
		-- upvalues: p6 (copy), invariant (copy)
		local data = p6.props.data
		local getItem = p6.props.getItem
		local getItemCount = p6.props.getItemCount
		local getItemLayout = p6.props.getItemLayout

		invariant(n7 <= getItemCount(data), "Tried to get frame for out of range index " .. tostring(n7))

		local v356 = getItem(data, n7)
		local v357 = if v356 == nil then v356 else p6._frames[p6:_keyExtractor(v356, n7)]

		if (not v357 or n7 ~= v357.index) and getItemLayout then
			v357 = getItemLayout(data, n7)
		end

		return v357
	end

	local v55 = invariant
	local windowSize = p7.windowSize

	v55(((if windowSize ~= nil then windowSize else 21)) > 0, "VirtualizedList: The windowSize prop must be present and set to a value greater than 0.")
	p6._fillRateHelper = FillRateHelper.new(p6._getFrameMetrics)

	function p6._updateCellsToRender() -- line: 749
		-- upvalues: p6 (copy), Boolean (copy), computeWindowedRenderLimits (copy)
		local data = p6.props.data
		local getItemCount = p6.props.getItemCount
		local onEndReachedThreshold = p6.props.onEndReachedThreshold
		local v361 = if onEndReachedThreshold ~= nil then onEndReachedThreshold else 2
		local v362 = p6:_isVirtualizationDisabled()

		p6:_updateViewableItems(data)

		if not Boolean.toJSBoolean(data) then
			return
		end

		p6:setState(function(p8) -- line: 758
			-- upvalues: p6 (copy), v362 (copy), Boolean (copy), computeWindowedRenderLimits (copy), v361 (copy), getItemCount (copy), data (copy)
			local v451 = nil
			local contentLength = p6._scrollMetrics.contentLength
			local offset = p6._scrollMetrics.offset
			local visibleLength = p6._scrollMetrics.visibleLength

			if not v362 then
				if visibleLength > 0 and contentLength > 0 then
					local initialScrollIndex = p6.props.initialScrollIndex

					if initialScrollIndex == nil or initialScrollIndex == 1 or Boolean.toJSBoolean(p6._scrollMetrics.offset) then
						local v456 = computeWindowedRenderLimits
						local data2 = p6.props.data
						local getItemCount2 = p6.props.getItemCount
						local maxToRenderPerBatch = p6.props.maxToRenderPerBatch
						local v460 = if maxToRenderPerBatch ~= nil then maxToRenderPerBatch else 10
						local windowSize2 = p6.props.windowSize

						v451 = v456(data2, getItemCount2, v460, if windowSize2 ~= nil then windowSize2 else 21, p8, p6._getFrameMetricsApprox, p6._scrollMetrics)
					end
				end
			else
				local v463

				if contentLength - visibleLength - offset < v361 * visibleLength then
					local maxToRenderPerBatch = p6.props.maxToRenderPerBatch

					v463 = if maxToRenderPerBatch ~= nil then maxToRenderPerBatch else 10
				else
					v463 = 0
				end

				v451 = {
					first = 1,
					last = math.min(p8.last + v463, getItemCount(data))
				}
			end

			if v451 ~= nil and p6._nestedChildLists.size > 0 then
				local first = v451.first
				local last = v451.last

				while first <= last do
					local v466 = p6._indicesToKeys:get(first)
					local v467 = if not Boolean.toJSBoolean(v466) then v466 else p6._cellKeysToChildListKeys:get(v466)

					if not Boolean.toJSBoolean(v467) then
						continue
					end

					local v468 = false

					for _, v in ipairs(v467) do
						local v471 = p6._nestedChildLists:get(v)

						if v471 and v471.ref and v471.ref:hasMore() then
							v468 = true

							break
						end
					end

					if v468 then
						v451.last = first

						break
					end

					first += 1
				end
			end

			if v451 ~= nil and v451.first == p8.first and v451.last == p8.last then
				v451 = nil
			end

			return v451
		end)
	end

	p6._updateCellsToRenderBatcher = Batchinator.new(p6._updateCellsToRender, if p6.props.updateCellsBatchingPeriod ~= nil then p6.props.updateCellsBatchingPeriod else 50)

	if p6.props.viewabilityConfigCallbackPairs then
		p6._viewabilityTuples = Array.map(p6.props.viewabilityConfigCallbackPairs, function(p9) -- line: 841
			-- upvalues: ViewabilityHelper (copy)
			return {
				viewabilityHelper = ViewabilityHelper.new(p9.viewabilityConfig),
				onViewableItemsChanged = p9.onViewableItemsChanged
			}
		end)
	else
		local onViewableItemsChanged = p6.props.onViewableItemsChanged
		local viewabilityConfig = p6.props.viewabilityConfig

		if onViewableItemsChanged then
			table.insert(p6._viewabilityTuples, {
				viewabilityHelper = ViewabilityHelper.new(viewabilityConfig),
				onViewableItemsChanged = onViewableItemsChanged
			})
		end
	end

	local t2 = {
		scrollPositionDelta = 0
	}
	local initialScrollIndex = p6.props.initialScrollIndex

	t2.first = not (initialScrollIndex ~= nil and initialScrollIndex ~= 1) and 1 or p6.props.initialScrollIndex

	local v61 = p6.props.getItemCount(p6.props.data) + 1
	local initialScrollIndex2 = p6.props.initialScrollIndex
	local v63 = not (initialScrollIndex2 ~= nil and initialScrollIndex2 ~= 1) and 1 or p6.props.initialScrollIndex
	local initialNumToRender = p6.props.initialNumToRender

	t2.last = math.min(v61, v63 + (if initialNumToRender ~= nil then initialNumToRender else 10)) - 1
	t2.firstItemTracked = if not p6.props.data or not (p6.props.getItemCount(p6.props.data) > 0) then Object.None else p6.props.getItem(p6.props.data, 1)

	if p6:_isNestedWithSameOrientation() then
		local v65 = p6.context.getNestedChildState(p6:_getListKey())

		if Boolean.toJSBoolean(v65) then
			t2 = v65
			p6.state = v65
			p6._frames = v65.frames
		end
	end

	p6.state = t2

	function p6._getScrollMetrics() -- line: 882
		-- upvalues: p6 (copy)
		return p6._scrollMetrics
	end
	function p6._getOutermostParentListRef() -- line: 886
		-- upvalues: p6 (copy)
		if p6:_isNestedWithSameOrientation() then
			return p6.context.getOutermostParentListRef()
		end

		return p6
	end
	function p6._getNestedChildState(s2: string) -- line: 894
		-- upvalues: p6 (copy)
		local v365 = p6._nestedChildLists:get(s2)

		if v365 then
			return v365.state
		end

		return v365
	end
	function p6._registerAsNestedChild(t3: {[any]: any}) -- line: 899
		-- upvalues: p6 (copy), Set (copy), console (copy), describeNestedLists (ref), Object (copy), Boolean (copy)
		local v367 = p6._cellKeysToChildListKeys:get(t3.cellKey) or Set.new()

		v367:add(t3.key)
		p6._cellKeysToChildListKeys:set(t3.cellKey, v367)

		local v368 = p6._nestedChildLists:get(t3.key)

		if v368 and v368.ref ~= nil then
			console.error("A VirtualizedList contains a cell which itself contains " .. "more than one VirtualizedList of the same orientation as the parent " .. "list. You must pass a unique listKey prop to each sibling list.\n\n" .. describeNestedLists(Object.assign({}, t3, {
				horizontal = Boolean.toJSBoolean(t3.ref.props.horizontal)
			})))
		end

		p6._nestedChildLists:set(t3.key, {
			state = nil,
			ref = t3.ref
		})

		if p6._hasInteracted then
			t3.ref:recordInteraction()
		end

		return nil
	end
	function p6._unregisterAsNestedChild(t4: {[any]: any}) -- line: 931
		-- upvalues: p6 (copy)
		p6._nestedChildLists:set(t4.key, {
			ref = nil,
			state = t4.state
		})
	end
	function p6._onUpdateSeparators(p10, p11) -- line: 938
		-- upvalues: Array (copy), p6 (copy), Boolean (copy)
		Array.forEach(p10, function(p12) -- line: 939
			-- upvalues: p6 (copy), Boolean (copy), p11 (copy)
			local v473 = p12 ~= nil and p6._cellRefs[tostring(p12)]

			if Boolean.toJSBoolean(v473) then
				return v473:updateSeparatorProps(p11)
			end
		end)
	end
	function p6._getSpacerKey(b2: boolean) -- line: 947
		if b2 then
			return "height"
		end

		return "width"
	end
	function p6._captureScrollRef(p13) -- line: 951
		-- upvalues: p6 (copy)
		p6._scrollRef = p13
	end
	function p6._defaultRenderScrollComponent(p14) -- line: 955
		-- upvalues: p6 (copy), React (copy), View (copy), invariant (copy), ScrollView (copy), Object (copy), RefreshControl (ref)
		local onRefresh = p14.onRefresh

		if p6:_isNestedWithSameOrientation() then
			return React.createElement(View, p14)
		end

		if onRefresh then
			invariant(typeof(p14.refreshing) == "boolean", "`refreshing` prop must be set as a boolean in order to use `onRefresh`, but got `" .. if p14.refreshing ~= nil then tostring(p14.refreshing) .. "`" else "undefined")

			return React.createElement(ScrollView, Object.assign(table.clone(p14), {
				refreshControl = if p14.refreshControl ~= nil then p14.refreshControl else React.createElement(RefreshControl, {
					refreshing = p14.refreshing,
					onRefresh = onRefresh,
					progressViewOffset = p14.progressViewOffset
				})
			}))
		end

		return React.createElement(ScrollView, p14)
	end
	function p6._onCellUnmount(s3: string) -- line: 985
		-- upvalues: p6 (copy), Object (copy)
		local v377 = p6._frames[s3]

		if v377 ~= nil then
			p6._frames[s3] = Object.assign({}, v377, {
				inLayout = false
			})
		end
	end
	function p6._onLayout(p15) -- line: 992
		-- upvalues: p6 (copy)
		if p6:_isNestedWithSameOrientation() then
			p6:measureLayoutRelativeToContainingList()
		else
			p6._scrollMetrics.visibleLength = p6:_selectLength({
				width = p15.AbsoluteSize.X,
				height = p15.AbsoluteSize.Y
			})
		end

		if p6.props.onLayout then
			p6.props.onLayout(p15)
		end

		p6:_scheduleCellsToRenderUpdate()
		p6:_maybeCallOnEndReached()
	end
	function p6._onLayoutEmpty(p16) -- line: 1010
		-- upvalues: p6 (copy)
		if p6.props.onLayout then
			p6.props.onLayout(p16)
		end
	end
	function p6._onLayoutFooter(p17) -- line: 1016
		-- upvalues: p6 (copy)
		p6:_triggerRemeasureForChildListsInCell(p6:_getFooterCellKey())
		p6._footerLength = p6:_selectLength({
			height = p17.AbsoluteSize.Y,
			width = p17.AbsoluteSize.X
		})
	end
	function p6._onLayoutHeader(p18) -- line: 1024
		-- upvalues: p6 (copy)
		p6._headerLength = p6:_selectLength({
			height = p18.AbsoluteSize.Y,
			width = p18.AbsoluteSize.X
		})
	end
	function p6._onContentSizeChange(n8: number, n9: number) -- line: 1031
		-- upvalues: p6 (copy)
		if n8 > 0 and (n9 > 0 and p6.props.initialScrollIndex ~= nil and p6.props.initialScrollIndex > 1 and not p6._hasDoneInitialScroll) then
			if p6.props.contentOffset == nil then
				p6:scrollToIndex({
					animated = false,
					index = p6.props.initialScrollIndex
				})
			end

			p6._hasDoneInitialScroll = true
		elseif p6.props.inverted and n8 > 0 and n9 > 0 and not p6._hasDoneInitialScroll then
			p6._hasDoneInitialScroll = true
			task.defer(function() -- line: 1046
				-- upvalues: p6 (copy)
				while p6:getScrollRef() == nil do
					task.wait()
				end

				if p6.props.contentOffset == nil then
					local current = p6:getScrollRef()._nativeRef.current

					if p6.props.horizontal then
						current.CanvasPosition = Vector2.new(current.AbsoluteCanvasSize.X, current.CanvasPosition.Y)

						return
					end

					current.CanvasPosition = Vector2.new(current.CanvasPosition.X, current.AbsoluteCanvasSize.Y)
				end
			end)
		end

		if p6.props.onContentSizeChange then
			p6.props.onContentSizeChange(n8, n9)
		end

		p6._scrollMetrics.contentLength = p6:_selectLength({
			height = n9,
			width = n8
		})
		p6:_scheduleCellsToRenderUpdate()
		p6:_maybeCallOnEndReached()
	end
	function p6._convertParentScrollMetrics(t5: {[any]: any}) -- line: 1078
		-- upvalues: p6 (copy)
		local v385 = t5.offset - p6._offsetFromParentVirtualizedList
		local visibleLength = t5.visibleLength
		local v387 = v385 - p6._scrollMetrics.offset
		local contentLength = p6._scrollMetrics.contentLength

		return {
			visibleLength = visibleLength,
			contentLength = contentLength,
			offset = v385,
			dOffset = v387
		}
	end
	function p6._onScroll(p19) -- line: 1099
		-- upvalues: p6 (copy), Boolean (copy), infoLog (copy)
		p6._nestedChildLists:forEach(function(p20) -- line: 1100
			-- upvalues: p19 (copy)
			if p20.ref then
				p20.ref._onScroll(p19)
			end
		end)

		if p6.props.onScroll then
			p6.props.onScroll(p19)
		end

		local elapsed = os.clock()
		local v391 = p19:GetChildren()[1]
		local v392 = p6:_selectLength({
			height = p19.AbsoluteSize.Y,
			width = p19.AbsoluteSize.X
		})
		local v393 = p6:_selectLength({
			height = v391.AbsoluteSize.Y,
			width = v391.AbsoluteSize.X
		})
		local v394 = if not p6.props.inverted then p6:_selectOffset({
			x = p19.CanvasPosition.X,
			y = p19.CanvasPosition.Y
		}) else p6:_selectOffset({
			x = p19.AbsoluteCanvasSize.X - p19.CanvasPosition.X - v392,
			y = p19.AbsoluteCanvasSize.Y - p19.CanvasPosition.Y - v392
		})
		local v395 = v394 - p6._scrollMetrics.offset

		if p6:_isNestedWithSameOrientation() then
			if p6._scrollMetrics.contentLength == 0 then
				return
			end

			local v396 = p6._convertParentScrollMetrics({
				v392,
				v394
			})

			v392 = v396.visibleLength
			v393 = v396.contentLength
			v394 = v396.offset
			v395 = v396.dOffset
		end

		local v397 = not Boolean.toJSBoolean(p6._scrollMetrics.timestamp) and 1 or math.max(1, (elapsed - p6._scrollMetrics.timestamp) * 1000)
		local v398 = v395 / v397

		if v397 > 500 and p6._scrollMetrics.dt > 500 and v393 > 5 * v392 and not p6._hasWarned.perf then
			infoLog("VirtualizedList: You have a large list that is slow to update - make sure your renderItem function renders components that follow React performance best practices like PureComponent, shouldComponentUpdate, etc.", {
				dt = v397,
				prevDt = p6._scrollMetrics.dt,
				contentLength = v393
			})
			p6._hasWarned.perf = true
		end

		p6._scrollMetrics = {
			contentLength = v393,
			dt = v397,
			dOffset = v395,
			offset = v394,
			timestamp = elapsed,
			velocity = v398,
			visibleLength = v392
		}

		local scrollPositionDelta = p6.state.scrollPositionDelta

		if scrollPositionDelta > 0 then
			p6:setState(function(t6: {[any]: any}) -- line: 1168
				-- upvalues: scrollPositionDelta (copy)
				return {
					scrollPositionDelta = 0,
					first = t6.first + scrollPositionDelta,
					last = t6.last + scrollPositionDelta
				}
			end)
		end

		p6:_updateViewableItems(p6.props.data)

		if not p6.props then
			return
		end

		p6:_maybeCallOnEndReached()

		if v398 ~= 0 then
			p6._fillRateHelper:activate()
		end

		p6:_computeBlankness()
		p6:_scheduleCellsToRenderUpdate()
	end
	function p6._onScrollBeginDrag(p21) -- line: 1188
		-- upvalues: p6 (copy), Array (copy)
		p6._nestedChildLists:forEach(function(p22) -- line: 1189
			-- upvalues: p21 (copy)
			if p22.ref then
				p22.ref._onScrollBeginDrag(p21)
			end
		end)
		Array.forEach(p6._viewabilityTuples, function(p23) -- line: 1194
			p23.viewabilityHelper:recordInteraction()
		end)
		p6._hasInteracted = true

		if p6.props.onScrollBeginDrag then
			p6.props.onScrollBeginDrag(p21)
		end
	end
	function p6._onScrollEndDrag(p24) -- line: 1203
		-- upvalues: p6 (copy), Boolean (copy)
		p6._nestedChildLists:forEach(function(p25) -- line: 1204
			-- upvalues: p24 (copy)
			if p25.ref then
				p25.ref._onScrollEndDrag(p24)
			end
		end)

		if Boolean.toJSBoolean(nil) then
			p6._scrollMetrics.velocity = p6:_selectOffset(nil)
		end

		p6:_computeBlankness()

		if p6.props.onScrollEndDrag then
			p6.props.onScrollEndDrag(p24)
		end
	end
	function p6._onMomentumScrollBegin(p26) -- line: 1222
		-- upvalues: p6 (copy)
		p6._nestedChildLists:forEach(function(p27) -- line: 1223
			-- upvalues: p26 (copy)
			if p27.ref then
				p27.ref._onMomentumScrollBegin(p26)
			end
		end)

		if p6.props.onMomentumScrollBegin then
			p6.props.onMomentumScrollBegin(p26)
		end
	end
	function p6._onMomentumScrollEnd(p28) -- line: 1233
		-- upvalues: p6 (copy)
		p6._nestedChildLists:forEach(function(p29) -- line: 1234
			-- upvalues: p28 (copy)
			if p29.ref then
				p29.ref._onMomentumScrollEnd(p28)
			end
		end)
		p6._scrollMetrics.velocity = 0
		p6:_computeBlankness()

		if p6.props.onMomentumScrollEnd then
			p6.props.onMomentumScrollEnd(p28)
		end
	end
	function p6._createViewToken(n10: number, b3: boolean) -- line: 1246
		-- upvalues: p6 (copy)
		local data = p6.props.data
		local v407 = p6.props.getItem(data, n10)

		return {
			index = n10,
			item = v407,
			key = p6:_keyExtractor(v407, n10),
			isViewable = b3
		}
	end
	function p6._getFrameMetricsApprox(n11: number) -- line: 1261
		-- upvalues: p6 (copy), invariant (copy)
		local v409 = p6._getFrameMetrics(n11)

		if v409 ~= nil and n11 == v409.index then
			return v409
		end

		local getItemLayout = p6.props.getItemLayout

		invariant(not getItemLayout, "Should not have to estimate frames when a measurement metrics function is provided")

		return {
			length = p6._averageCellLength,
			offset = p6._averageCellLength * (n11 - 1)
		}
	end
end
function v42.scrollToEnd(t7: {[any]: any}, t8: {[any]: any}?) -- line: 1282
	-- upvalues: console (copy)
	local v68 = t8 == nil or t8.animated
	local v69 = t7.props.getItemCount(t7.props.data)
	local v70 = t7._getFrameMetricsApprox(v69)
	local v71 = if not t7.props.inverted then math.max(0, v70.offset + v70.length + t7._footerLength - t7._scrollMetrics.visibleLength) else 0

	if t7._scrollRef == nil then
		return
	end

	if t7._scrollRef.scrollTo == nil then
		console.warn("No scrollTo method provided. This may be because you have two nested VirtualizedLists with the same orientation, or because you are using a custom component that does not implement scrollTo.")

		return
	end

	local scrollTo = t7._scrollRef.scrollTo
	local horizontal = t7.props.horizontal

	scrollTo(if not (horizontal ~= nil and horizontal) then {
		y = v71,
		animated = v68
	} else {
		x = v71,
		animated = v68
	})
end
function v42.scrollToIndex(t9: {[any]: any}, t10: {[any]: any}) -- line: 1312
	-- upvalues: invariant (copy), Boolean (copy), console (copy)
	local data = t9.props.data
	local horizontal = t9.props.horizontal
	local getItemCount = t9.props.getItemCount
	local getItemLayout = t9.props.getItemLayout
	local onScrollToIndexFailed = t9.props.onScrollToIndexFailed
	local animated = t10.animated
	local index = t10.index
	local viewOffset = t10.viewOffset
	local viewPosition = t10.viewPosition

	invariant(index >= 1, ("scrollToIndex out of range: requested index %d but minimum is 1"):format(index))
	invariant(getItemCount(data) >= 1, ("scrollToIndex out of range: item length %d but minimum is 1"):format(getItemCount(data)))
	invariant(index <= getItemCount(data), ("scrollToIndex out of range: requested index %d is out of 1 to %d"):format(index, getItemCount(data)))

	if not getItemLayout and index > t9._highestMeasuredFrameIndex then
		invariant(Boolean.toJSBoolean(onScrollToIndexFailed), "scrollToIndex should be used in conjunction with getItemLayout or onScrollToIndexFailed, otherwise there is no way to know the location of offscreen indices or handle failures.")
		onScrollToIndexFailed({
			averageItemLength = t9._averageCellLength,
			highestMeasuredFrameIndex = t9._highestMeasuredFrameIndex,
			index = index
		})

		return
	end

	local v85 = if not t9:getScrollRef() then nil else t9:getScrollRef()._nativeRef.current

	if v85 == nil then
		return
	end

	local AbsoluteCanvasSize = v85.AbsoluteCanvasSize
	local AbsoluteSize = v85.AbsoluteSize
	local v88 = t9._getFrameMetricsApprox(index)
	local v89 = math.max(0, (if not t9.props.inverted then v88.offset - (Boolean.toJSBoolean(viewPosition) and viewPosition or 0) * (t9._scrollMetrics.visibleLength - v88.length) else ((if not horizontal then AbsoluteCanvasSize.Y else AbsoluteCanvasSize.X)) - (if not horizontal then AbsoluteSize.Y else AbsoluteSize.X) - v88.offset - (Boolean.toJSBoolean(viewPosition) and viewPosition or 0) * (t9._scrollMetrics.visibleLength - v88.length))) - (Boolean.toJSBoolean(viewOffset) and viewOffset or 0)

	if t9._scrollRef == nil then
		return
	end

	if t9._scrollRef.scrollTo == nil then
		console.warn("No scrollTo method provided. This may be because you have two nested VirtualizedLists with the same orientation, or because you are using a custom component that does not implement scrollTo.")

		return
	end

	t9._scrollRef.scrollTo(if not horizontal then {
		y = v89,
		animated = animated
	} else {
		x = v89,
		animated = animated
	})
end
function v42.scrollToItem(t11: {[any]: any}, t12: {[any]: any}) -- line: 1403
	-- upvalues: Object (copy)
	local item = t12.item
	local data = t11.props.data
	local getItem = t11.props.getItem
	local v95 = t11.props.getItemCount(data)
	local n12 = 1

	while n12 <= v95 do
		if item == getItem(data, n12) then
			t11:scrollToIndex(Object.assign({}, t12, {
				index = n12
			}))

			return
		end

		n12 += 1
	end
end
function v42.scrollToOffset(t13: {[any]: any}, t14: {[any]: any}) -- line: 1432
	-- upvalues: console (copy)
	local v99 = if not t13:getScrollRef() then nil else t13:getScrollRef()._nativeRef.current

	if v99 == nil then
		return
	end

	local animated = t14.animated
	local offset = t14.offset

	if t13._scrollRef == nil then
		return
	end

	if t13.props.inverted then
		local AbsoluteCanvasSize = v99.AbsoluteCanvasSize
		local AbsoluteSize = v99.AbsoluteSize

		offset = ((if not t13.props.horizontal then AbsoluteCanvasSize.Y else AbsoluteCanvasSize.X)) - offset - if not t13.props.horizontal then AbsoluteSize.Y else AbsoluteSize.X
	end

	if t13._scrollRef.scrollTo == nil then
		console.warn("No scrollTo method provided. This may be because you have two nested VirtualizedLists with the same orientation, or because you are using a custom component that does not implement scrollTo.")

		return
	end

	local scrollTo = t13._scrollRef.scrollTo
	local horizontal = t13.props.horizontal

	scrollTo(if not (horizontal ~= nil and horizontal) then {
		y = offset,
		animated = animated
	} else {
		x = offset,
		animated = animated
	})
end
function v42.recordInteraction(p30) -- line: 1478
	-- upvalues: Array (copy)
	p30._nestedChildLists:forEach(function(p31) -- line: 1479
		if p31.ref then
			p31.ref:recordInteraction()
		end
	end)
	Array.forEach(p30._viewabilityTuples, function(p32) -- line: 1484
		p32.viewabilityHelper:recordInteraction()
	end)
	p30:_updateViewableItems(p30.props.data)
end
function v42.flashScrollIndicators(p33) -- line: 1490
	if p33._scrollRef == nil then
		return
	end

	p33._scrollRef:flashScrollIndicators()
end
function v42.getScrollResponder(p34) -- line: 1503
	if p34._scrollRef and p34._scrollRef.getScrollResponder then
		return p34._scrollRef:getScrollResponder()
	end

	return nil
end
function v42.getScrollableNode(p35) -- line: 1511
	-- upvalues: t1 (copy)
	if p35._scrollRef and p35._scrollRef.getScrollableNode then
		return p35._scrollRef:getScrollableNode()
	end

	return t1.findNodeHandle(p35._scrollRef)
end
function v42.getScrollRef(p36) -- line: 1519
	if p36._scrollRef and p36._scrollRef.getScrollRef then
		return p36._scrollRef:getScrollRef()
	end

	return p36._scrollRef
end
function v42.setNativeProps(p37, p38) -- line: 1527
	if p37._scrollRef then
		p37._scrollRef:setNativeProps(p38)
	end
end
function v42._getCellKey(p39) -- line: 1533
	if p39.context and p39.context.cellKey then
		return p39.context.cellKey
	end

	return "rootList"
end
function v42._getListKey(p40) -- line: 1537
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(p40.props.listKey) then
		return p40.props.listKey
	end

	return (p40:_getCellKey())
end
function v42._getDebugInfo(p41) -- line: 1541
	local t15 = {
		listKey = p41:_getListKey(),
		cellKey = p41:_getCellKey()
	}
	local horizontal = p41.props.horizontal

	t15.horizontal = horizontal ~= nil and horizontal
	t15.parent = if not p41.context then nil else p41.context.debugInfo

	return t15
end
function v42.hasMore(p42) -- line: 1550
	return p42._hasMore
end
function v42.componentDidMount(p43) -- line: 1554
	if p43:_isNestedWithSameOrientation() then
		p43.context.registerAsNestedChild({
			cellKey = p43:_getCellKey(),
			key = p43:_getListKey(),
			ref = p43,
			parentDebugInfo = p43.context.debugInfo
		})
	end
end
function v42.componentWillUnmount(p44) -- line: 1569
	-- upvalues: Array (copy)
	if p44:_isNestedWithSameOrientation() then
		p44.context.unregisterAsNestedChild({
			key = p44:_getListKey(),
			state = {
				first = p44.state.first,
				last = p44.state.last,
				frames = p44._frames
			}
		})
	end

	p44:_updateViewableItems(nil)
	p44._updateCellsToRenderBatcher:dispose({
		abort = true
	})
	Array.forEach(p44._viewabilityTuples, function(p45) -- line: 1578
		p45.viewabilityHelper:dispose()
	end)
	p44._fillRateHelper:deactivateAndFlush()
end
function v42.getDerivedStateFromProps(p46, t16: {[any]: any}) -- line: 1584
	-- upvalues: console (copy), Object (copy)
	local data = p46.data
	local getItemCount = p46.getItemCount
	local maintainVisibleContentPosition = p46.maintainVisibleContentPosition
	local firstItemTracked = t16.firstItemTracked
	local scrollPositionDelta = t16.scrollPositionDelta
	local compareItemData = p46.compareItemData
	local v129 = if compareItemData ~= nil then compareItemData else function(p47, p48) -- line: 446
		return p47 == p48
	end
	local v130 = if not data or not (getItemCount(data) > 0) then nil else p46.getItem(data, 1)

	local function findItem(p49, p50) -- line: 1591
		-- upvalues: v129 (copy)
		local v418 = nil

		for i = 1, #p49 do
			if v129(p49[i], p50) then
				v418 = i

				break
			end
		end

		if v418 == nil then
			return 1
		end

		return v418
	end

	if maintainVisibleContentPosition and (scrollPositionDelta == 0 and firstItemTracked ~= nil and v130 ~= nil) then
		scrollPositionDelta = if not v129(firstItemTracked, v130) then findItem(data, firstItemTracked) - 1 else 0
	end

	local v132 = getItemCount(data)
	local maxToRenderPerBatch = p46.maxToRenderPerBatch
	local v134 = if maxToRenderPerBatch ~= nil then maxToRenderPerBatch else 10
	local v135 = math.max(1, (math.min(t16.first, v132 - v134)))

	if v132 > 0 and v132 < v135 + scrollPositionDelta then
		scrollPositionDelta = 0
		console.warn("WARNING: maintainVisibleContentPosition failed because scrollPositionDelta was out of bounds. This could indicate that items in `data` are getting removed, items are getting added to the middle of `data`, or a different `data` array is getting passed in. Consider changing the `key` prop of the List if the `data` prop is significantly altered.")
	end

	if scrollPositionDelta > 0 then
		for i = 1, math.min(scrollPositionDelta, v132) do
			p46.getItem(data, i).shouldResizeOnMount = true
		end
	end

	return {
		first = v135,
		last = math.max(1, (math.min(t16.last, v132))),
		firstItemTracked = v130 or Object.None,
		scrollPositionDelta = scrollPositionDelta
	}
end
function v42._pushCells(t17: {[any]: any}, p51, p52, p53, n13: number, n14: number, p54) -- line: 1647
	-- upvalues: React (copy), u31 (ref)
	local CellRendererComponent = t17.props.CellRendererComponent
	local ItemSeparatorComponent = t17.props.ItemSeparatorComponent
	local data = t17.props.data
	local getItem = t17.props.getItem
	local getItemCount = t17.props.getItemCount
	local horizontal = t17.props.horizontal
	local v150 = not t17.props.ListHeaderComponent and 0 or 1
	local v151 = getItemCount(data)
	local v152 = nil
	local v153 = math.min(v151, n14)

	while n13 <= v153 do
		local v154 = getItem(data, n13)
		local v155 = t17:_keyExtractor(v154, n13)

		t17._indicesToKeys:set(n13, v155)

		if p53:has(n13 + v150) then
			table.insert(p52, #p51)
		end

		local v156 = n13

		table.insert(p51, React.createElement(u31, {
			CellRendererComponent = CellRendererComponent,
			ItemSeparatorComponent = if not (n13 < v151) then nil else ItemSeparatorComponent,
			cellKey = v155,
			fillRateHelper = t17._fillRateHelper,
			horizontal = horizontal,
			index = n13,
			inversionStyle = p54,
			item = v154,
			key = v155,
			prevCellKey = v152,
			onUpdateSeparators = t17._onUpdateSeparators,
			onLayout = function(p55) -- line: 1695
				-- upvalues: t17 (copy), v155 (copy), v156 (copy)
				return t17:_onCellLayout(p55, v155, v156)
			end,
			onUnmount = t17._onCellUnmount,
			parentProps = t17.props,
			ref = function(p56) -- line: 1700
				-- upvalues: t17 (copy), v155 (copy)
				t17._cellRefs[tostring(v155)] = p56
			end,
			isSequentiallySelectable = t17.props.isSequentiallySelectable
		}))
		v152 = v155
		n13 += 1
	end
end
function v42._isVirtualizationDisabled(p57) -- line: 1711
	if p57.props.disableVirtualization ~= nil then
		return p57.props.disableVirtualization
	end

	return false
end
function v42._isNestedWithSameOrientation(p58) -- line: 1715
	-- upvalues: Boolean (copy)
	local context = p58.context
	local v160 = false

	if context ~= nil then
		local v161 = Boolean.toJSBoolean(context.horizontal)
		local horizontal = p58.props.horizontal

		v160 = v161 == (horizontal ~= nil and horizontal)
	end

	return v160
end
function v42._keyExtractor(t18: {[any]: any}, p59, n15: number) -- line: 1721
	-- upvalues: keyExtractor (copy), u33 (ref), Boolean (copy), s1 (ref)
	if t18.props.keyExtractor ~= nil then
		return t18.props.keyExtractor(p59, n15)
	end

	local v166 = keyExtractor(p59, n15)

	if v166 == tostring(n15) then
		u33 = true

		if p59.type ~= nil and Boolean.toJSBoolean(p59.type.displayName) then
			s1 = p59.type.displayName
		end
	end

	return v166
end
function v42.render(p60) -- line: 1736
	-- upvalues: v18 (copy), console (copy), u30 (ref), Set (copy), React (copy), VirtualizedListCellContextProvider (copy), View (copy), StyleSheet (copy), u33 (ref), s1 (ref), Object (copy), VirtualizedListContextProvider (copy), ScrollView (copy)
	if _G.__DEV__ then
		local v168 = v18(p60.props.contentContainerStyle)

		if v168 ~= nil and v168.flexWrap == "wrap" then
			console.warn("`flexWrap: `wrap`` is not supported with the `VirtualizedList` components.Consider using `numColumns` with `FlatList` instead.")
		end
	end

	local ListEmptyComponent = p60.props.ListEmptyComponent
	local ListFooterComponent = p60.props.ListFooterComponent
	local ListHeaderComponent = p60.props.ListHeaderComponent
	local data = p60.props.data
	local horizontal = p60.props.horizontal
	local v174 = p60:_isVirtualizationDisabled()
	local v176

	if p60.props.inverted then
		local horizontal2 = p60.props.horizontal

		v176 = if not (horizontal2 ~= nil and horizontal2) then u30.verticallyInverted else u30.horizontallyInverted
	else
		v176 = nil
	end

	local t19 = {}
	local v178 = Set.new(p60.props.stickyHeaderIndices)
	local t20 = {}

	if ListHeaderComponent then
		if v178:has(0) then
			table.insert(t20, 0)
		end

		local v180 = if not React.isValidElement(ListHeaderComponent) then React.createElement(ListHeaderComponent, nil) else ListHeaderComponent

		table.insert(t19, React.createElement(VirtualizedListCellContextProvider, {
			key = "$header",
			Name = "$header",
			cellKey = p60:_getCellKey() .. "-header"
		}, React.createElement(View, {
			Name = "ListHeaderComponent",
			onLayout = p60._onLayoutHeader,
			style = StyleSheet.compose(v176, p60.props.ListHeaderComponentStyle),
			LayoutOrder = not p60.props.inverted and -999999998 or 999999998,
			AutomaticSize = if not horizontal then Enum.AutomaticSize.Y else Enum.AutomaticSize.X,
			Size = if not horizontal then UDim2.new(1, 0, 0, 0) else UDim2.new(0, 0, 1, 0)
		}, v180)))
	end

	local v181 = p60.props.getItemCount(data)

	if v181 > 0 then
		u33 = false
		s1 = ""

		local v182 = p60._getSpacerKey(not horizontal)
		local initialScrollIndex = p60.props.initialScrollIndex
		local n16

		if initialScrollIndex ~= nil and initialScrollIndex ~= 1 then
			n16 = -1
		else
			local initialNumToRender = p60.props.initialNumToRender

			n16 = ((if initialNumToRender ~= nil then initialNumToRender else 10)) - 1
		end

		local v186 = n16 + 1
		local first = p60.state.first
		local last = p60.state.last
		local scrollPositionDelta = p60.state.scrollPositionDelta

		if scrollPositionDelta > 0 then
			first += scrollPositionDelta
			last += scrollPositionDelta
		end

		p60:_pushCells(t19, t20, v178, 1, v186, v176)

		local v190 = math.max(v186 + 1, first)

		if not v174 and first > v186 + 1 then
			local v191 = false

			if v178.size > 0 then
				local v192 = not ListHeaderComponent and 0 or 1
				local v193 = v190 - 1

				while v186 < v193 do
					if v178:has(v193 + v192) then
						local v194 = p60._getFrameMetricsApprox(v186)
						local v195 = p60._getFrameMetricsApprox(v193)
						local v196 = v195.offset - v194.offset
						local initialScrollIndex3 = p60.props.initialScrollIndex
						local v198 = v196 - if not (initialScrollIndex3 ~= nil and initialScrollIndex3 ~= 1) then v194.length else 0

						table.insert(t19, React.createElement(View, {
							key = "$sticky_lead",
							Name = "$sticky_lead",
							style = {
								Size = if v182 ~= "height" then UDim2.new(0, v198, 1, 0) else UDim2.new(1, 0, 0, v198)
							}
						}))
						p60:_pushCells(t19, t20, v178, v193, v193, v176)

						local v199 = p60._getFrameMetricsApprox(first).offset - v195.offset + v195.length

						table.insert(t19, React.createElement(View, {
							key = "$sticky_trail",
							Name = "$sticky_trail",
							style = {
								Size = if v182 ~= "height" then UDim2.new(0, v199, 1, 0) else UDim2.new(1, 0, 0, v199)
							}
						}))
						v191 = true

						break
					end

					v193 -= 1
				end
			end

			if not v191 then
				local v200 = p60._getFrameMetricsApprox(v186)
				local v201 = p60._getFrameMetricsApprox(first).offset - (v200.offset + v200.length)

				table.insert(t19, React.createElement(View, {
					key = "$lead_spacer",
					Name = "$lead_spacer",
					style = {
						Size = if v182 ~= "height" then UDim2.new(0, v201, 1, 0) else UDim2.new(1, 0, 0, v201)
					},
					LayoutOrder = not p60.props.inverted and -999999999 or 999999999
				}))
			end
		end

		p60:_pushCells(t19, t20, v178, v190, last, v176)

		if not p60._hasWarned.keys and u33 then
			console.warn("VirtualizedList: missing keys for items, make sure to specify a key or id property on each item or provide a custom keyExtractor.", s1)
			p60._hasWarned.keys = true
		end

		if not v174 and last < v181 then
			local v202 = p60._getFrameMetricsApprox(last)
			local v203 = if not p60.props.getItemLayout then math.min(v181, p60._highestMeasuredFrameIndex) else v181
			local v204 = p60._getFrameMetricsApprox(v203)
			local v205 = v204.offset + v204.length - (v202.offset + v202.length)

			table.insert(t19, React.createElement(View, {
				key = "$tail_spacer",
				Name = "$tail_spacer",
				style = {
					Size = if v182 ~= "height" then UDim2.new(0, v205, 1, 0) else UDim2.new(1, 0, 0, v205)
				},
				LayoutOrder = not p60.props.inverted and 999999999 or -999999999
			}))
		end
	elseif ListEmptyComponent then
		local v206 = if not React.isValidElement(ListEmptyComponent) then React.createElement(ListEmptyComponent, nil) else ListEmptyComponent

		table.insert(t19, React.cloneElement(v206, {
			key = "$empty",
			Name = "$empty",
			onLayout = function(p61) -- line: 1923
				-- upvalues: p60 (copy), v206 (copy)
				p60._onLayoutEmpty(p61)

				if v206.props.onLayout then
					v206.props.onLayout(p61)
				end
			end,
			style = StyleSheet.compose(v176, v206.props.style)
		}))
	end

	if ListFooterComponent then
		local v207 = if not React.isValidElement(ListFooterComponent) then React.createElement(ListFooterComponent, nil) else ListFooterComponent

		table.insert(t19, React.createElement(VirtualizedListCellContextProvider, {
			key = "$footer",
			Name = "$footer",
			cellKey = p60:_getFooterCellKey()
		}, React.createElement(View, {
			Name = "ListFooterComponent",
			onLayout = p60._onLayoutFooter,
			style = StyleSheet.compose(v176, p60.props.ListFooterComponentStyle),
			LayoutOrder = not p60.props.inverted and 999999998 or -999999998,
			AutomaticSize = if not horizontal then Enum.AutomaticSize.Y else Enum.AutomaticSize.X,
			Size = if not horizontal then UDim2.new(1, 0, 0, 0) else UDim2.new(0, 0, 1, 0)
		}, v207)))
	end

	if p60.props.inverted and not p60.props.getItemLayout then
		if p60:getScrollRef() ~= nil and p60:getScrollRef()._nativeRef.current ~= nil then
			local current = p60:getScrollRef()._nativeRef.current
			local CanvasPosition = current.CanvasPosition
			local v210 = p60._getFrameMetricsApprox((math.min(p60._highestMeasuredFrameIndex, v181)))
			local v211 = v210.offset + v210.length
			local v212 = if not p60.props.optimizeInvertedCanvasResize then v211 ~= p60._invertedCanvasLength - p60._footerLength else v211 > p60._invertedCanvasLength - p60._footerLength

			if v181 <= p60._highestMeasuredFrameIndex and v211 ~= p60._invertedCanvasLength - p60._footerLength then
				local v213 = v211 + p60._footerLength - p60._invertedCanvasLength

				p60._invertedCanvasLength = v211 + p60._footerLength

				local v214 = if not p60.props.horizontal then UDim2.new(1, 0, 0, p60._invertedCanvasLength) else UDim2.new(0, p60._invertedCanvasLength, 1, 0)

				current.CanvasSize = v214
				p60._canvasPosition = if not p60.props.horizontal then Vector2.new(CanvasPosition.X, CanvasPosition.Y + v213) else Vector2.new(CanvasPosition.X + v213, CanvasPosition.Y)
				p60._canvasSize = v214
			elseif v212 and p60.state.scrollPositionDelta == 0 then
				local _invertedCanvasLength = p60._invertedCanvasLength
				local visibleLength = p60._scrollMetrics.visibleLength
				local windowSize = p60.props.windowSize
				local v218 = visibleLength * (if windowSize ~= nil then windowSize else 21) * 0.5
				local v219 = v210.offset + p60._scrollMetrics.visibleLength + v218
				local v220 = v219 - _invertedCanvasLength

				p60._invertedCanvasLength = v219

				local v221 = if not p60.props.horizontal then UDim2.new(1, 0, 0, p60._invertedCanvasLength) else UDim2.new(0, p60._invertedCanvasLength, 1, 0)

				current.CanvasSize = v221
				current.CanvasPosition = if not p60.props.horizontal then Vector2.new(CanvasPosition.X, CanvasPosition.Y + v220) else Vector2.new(CanvasPosition.X + v220, CanvasPosition.Y)
				p60._canvasPosition = current.CanvasPosition
				p60._canvasSize = v221
			end
		else
			p60._canvasPosition = if not p60.props.horizontal then Vector2.new(0, p60._invertedCanvasLength) else Vector2.new(p60._invertedCanvasLength, 0)
			p60._canvasSize = if not p60.props.horizontal then UDim2.new(1, 0, 0, p60._invertedCanvasLength) else UDim2.new(0, p60._invertedCanvasLength, 1, 0)
		end
	elseif p60.props.inverted and p60.props.getItemLayout then
		local v222 = p60._getFrameMetricsApprox(v181)

		if p60:getScrollRef() ~= nil and p60:getScrollRef()._nativeRef.current ~= nil then
			local current = p60:getScrollRef()._nativeRef.current
			local CanvasPosition = current.CanvasPosition
			local _invertedCanvasLength = p60._invertedCanvasLength

			p60._invertedCanvasLength = v222.offset + v222.length

			if _invertedCanvasLength ~= p60._invertedCanvasLength then
				local v226 = p60._invertedCanvasLength - _invertedCanvasLength

				current.CanvasPosition = if not p60.props.horizontal then CanvasPosition + Vector2.new(0, v226) else CanvasPosition + Vector2.new(v226, 0)
			end
		else
			p60._invertedCanvasLength = v222.offset + v222.length
		end
	end

	local assign = Object.assign
	local v228 = table.clone(p60.props)
	local t21 = {
		onContentSizeChange = p60._onContentSizeChange,
		onLayout = p60._onLayout,
		onScroll = p60._onScroll,
		onScrollBeginDrag = p60._onScrollBeginDrag,
		onScrollEndDrag = p60._onScrollEndDrag,
		onMomentumScrollBegin = p60._onMomentumScrollBegin,
		onMomentumScrollEnd = p60._onMomentumScrollEnd
	}
	local scrollEventThrottle = p60.props.scrollEventThrottle

	t21.scrollEventThrottle = if scrollEventThrottle ~= nil then scrollEventThrottle else 50
	t21.invertStickyHeaders = if p60.props.invertStickyHeaders == nil then p60.props.inverted else p60.props.invertStickyHeaders
	t21.stickyHeaderIndices = t20
	t21.style = p60.props.style
	t21.layoutStyle = v176 or nil
	t21.AutomaticCanvasSize = if not p60.props.inverted or p60.props.getItemLayout then nil else Enum.AutomaticSize.None
	t21.CanvasSize = if not p60.props.inverted then nil else p60._canvasSize
	t21.CanvasPosition = if not p60.props.inverted then nil else p60._canvasPosition

	local v231 = assign(v228, t21)

	p60._hasMore = p60.state.last < p60.props.getItemCount(p60.props.data)

	local createElement = React.createElement
	local v233 = VirtualizedListContextProvider
	local t22 = {}
	local t23 = {
		cellKey = nil,
		getScrollMetrics = p60._getScrollMetrics
	}
	local horizontal3 = p60.props.horizontal

	t23.horizontal = horizontal3 ~= nil and horizontal3
	t23.getOutermostParentListRef = p60._getOutermostParentListRef
	t23.getNestedChildState = p60._getNestedChildState
	t23.registerAsNestedChild = p60._registerAsNestedChild
	t23.unregisterAsNestedChild = p60._unregisterAsNestedChild
	t23.debugInfo = p60:_getDebugInfo()
	t22.value = t23

	local v237 = createElement(v233, t22, React.cloneElement(((if not p60.props.renderScrollComponent then p60._defaultRenderScrollComponent else p60.props.renderScrollComponent))(v231), {
		ref = p60._captureScrollRef
	}, t19))
	local v238 = v237

	if _G.__DEV__ then
		v238 = React.createElement(ScrollView.Context.Consumer, nil, function(p62) -- line: 2103
			-- upvalues: p60 (copy), console (copy), v237 (copy)
			if p62 ~= nil then
				local horizontal4 = p62.horizontal
				local horizontal5 = p60.props.horizontal

				if not (horizontal5 ~= nil and horizontal5) == not horizontal4 and not p60._hasWarned.nesting and p60.context == nil then
					console.error("VirtualizedLists should never be nested inside plain ScrollViews with the same orientation because it can break windowing and other functionality - use another VirtualizedList-backed container instead.")
					p60._hasWarned.nesting = true
				end
			end

			return v237
		end)
	end

	if p60.props.debug then
		return React.createElement(View, {
			Name = "debug",
			style = u30.debug
		}, v238, p60:_renderDebugOverlay())
	end

	return v238
end
function v42.componentDidUpdate(p63, p64) -- line: 2129
	-- upvalues: Array (copy)
	local data = p63.props.data
	local extraData = p63.props.extraData

	if data ~= p64.data or extraData ~= p64.extraData then
		Array.forEach(p63._viewabilityTuples, function(p65) -- line: 2134
			p65.viewabilityHelper:resetViewableIndices()
		end)
	end

	local _hiPriInProgress = p63._hiPriInProgress

	p63:_scheduleCellsToRenderUpdate()

	if _hiPriInProgress then
		p63._hiPriInProgress = false
	end
end
function v42._computeBlankness(p66) -- line: 2153
	p66._fillRateHelper:computeBlankness(p66.props, p66.state, p66._scrollMetrics)
end
function v42._onCellLayout(t24: {[any]: any}, p67, s4: string, n17: number) -- line: 2157
	-- upvalues: console (copy), Array (copy), Object (copy), Boolean (copy)
	local v249 = if not t24:getScrollRef() or not t24:getScrollRef()._nativeRef.current then p67:FindFirstAncestorOfClass("ScrollingFrame") else t24:getScrollRef()._nativeRef.current

	if v249 == nil then
		if _G.__DEV__ then
			console.warn("CellLayout failed for index " .. tostring(n17) .. ". this may cause layout issues")
		end

		return
	end

	local AbsolutePosition = v249.AbsolutePosition
	local CanvasPosition = v249.CanvasPosition
	local AbsoluteCanvasSize = v249.AbsoluteCanvasSize
	local AbsoluteSize = p67.AbsoluteSize
	local AbsolutePosition2 = p67.AbsolutePosition
	local v255 = if not t24.props.inverted or not t24.props.horizontal then AbsolutePosition2.X - AbsolutePosition.X + CanvasPosition.X else AbsoluteCanvasSize.X - CanvasPosition.X - AbsolutePosition2.X - AbsoluteSize.X + AbsolutePosition.X
	local v256 = if not t24.props.inverted or t24.props.horizontal then AbsolutePosition2.Y - AbsolutePosition.Y + CanvasPosition.Y else AbsoluteCanvasSize.Y - CanvasPosition.Y - AbsolutePosition2.Y - AbsoluteSize.Y + AbsolutePosition.Y
	local t25 = {
		width = p67.AbsoluteSize.X,
		height = p67.AbsoluteSize.Y,
		x = v255,
		y = v256
	}
	local t26 = {
		inLayout = true,
		offset = t24:_selectOffset(t25),
		length = t24:_selectLength(t25),
		index = n17
	}
	local v259 = t24._frames[s4]

	if not v259 or math.abs(t26.offset - v259.offset) > 1 or t26.length ~= v259.length or n17 ~= v259.index then
		local v260 = t24.props.getItem(t24.props.data, n17)

		if not v259 and not t24.props.getItemLayout and typeof(v260) == "table" and v260.shouldResizeOnMount then
			t24:recalculateFrames(t24:_selectLength(t25), s4, n17)
		end

		if v259 and not t24.props.getItemLayout and math.abs(t26.length - v259.length) >= 1 then
			if t24.props.UNSTABLE_forceSiblingLayoutUpdate then
				local Frame = p67:FindFirstAncestorOfClass("Frame")
				local v262 = if not Frame then {} else Frame:GetChildren()
				local v263 = t24.props.getItemCount(t24.props.data)

				Array.forEach(v262, function(p68) -- line: 2224
					-- upvalues: n17 (copy), v263 (copy), t24 (copy)
					if not p68:IsA("GuiObject") then
						return
					end

					local v428 = math.abs(p68.LayoutOrder)

					if v428 <= n17 or v428 > v263 then
						return
					end

					local v429 = t24.props.getItem(t24.props.data, v428)

					if v429 == nil then
						return
					end

					local v430 = t24:_keyExtractor(v429, v428)

					t24:_onCellLayout(p68, v430, v428)
				end)
			else
				Array.forEach(Object.keys(t24._frames), function(p69) -- line: 2244
					-- upvalues: t24 (copy), n17 (copy)
					if t24._frames[p69].index <= n17 then
						return
					end

					local v432 = if not t24._cellRefs[p69] then nil else t24._cellRefs[p69]:getRef()

					if v432 and v432.current then
						t24:_onCellLayout(v432.current, p69, t24._frames[p69].index)
					end
				end)
			end
		end

		t24._totalCellLength = t24._totalCellLength + (t26.length - (not Boolean.toJSBoolean(v259) and 0 or v259.length))
		t24._totalCellsMeasured = t24._totalCellsMeasured + (not Boolean.toJSBoolean(v259) and 1 or 0)
		t24._averageCellLength = t24._totalCellLength / t24._totalCellsMeasured
		t24._frames[s4] = t26
		t24._highestMeasuredFrameIndex = math.max(t24._highestMeasuredFrameIndex, n17)
		t24:_scheduleCellsToRenderUpdate()

		if t24.props.inverted and not t24.props.getItemLayout and t24.state.last == t24.props.getItemCount(t24.props.data) and t24._highestMeasuredFrameIndex == t24.state.last then
			t24:forceUpdate()
		end
	else
		t24._frames[s4].inLayout = true
	end

	t24:_triggerRemeasureForChildListsInCell(s4)
	t24:_computeBlankness()
	t24:_updateViewableItems(t24.props.data)
end
function v42._triggerRemeasureForChildListsInCell(t27: {[any]: any}, s5: string) -- line: 2290
	local v266 = t27._cellKeysToChildListKeys:get(s5)

	if v266 then
		v266:forEach(function(p70) -- line: 2293
			-- upvalues: t27 (copy)
			local v434 = t27._nestedChildLists:get(p70)

			if v434 and v434.ref then
				v434.ref:measureLayoutRelativeToContainingList()
			end
		end)
	end
end
function v42.recalculateFrames(t28: {[any]: any}, n18: number, s6: string, n19: number) -- line: 2304
	-- upvalues: Array (copy), Object (copy)
	Array.forEach(Object.keys(t28._frames), function(p71) -- line: 2305
		-- upvalues: s6 (copy), t28 (copy), n19 (copy), n18 (copy)
		if p71 == s6 and t28._frames[p71].index >= n19 then
			return
		end

		local v436 = t28._frames[p71]

		v436.index = v436.index + 1

		local v437 = t28._frames[p71]

		v437.offset = v437.offset + n18
	end)
	t28._highestMeasuredFrameIndex = t28._highestMeasuredFrameIndex + 1
end
function v42.measureLayoutRelativeToContainingList(p72) -- line: 2316
	-- upvalues: Boolean (copy), console (copy)
	local ok, result = pcall(function() -- line: 2320
		-- upvalues: Boolean (copy), p72 (copy), console (copy)
		if not Boolean.toJSBoolean(p72._scrollRef) then
			return nil
		end

		p72._scrollRef:measureLayout(p72.context.getOutermostParentListRef():getScrollRef(), function(p73, p74, p75, p76) -- line: 2328
			-- upvalues: p72 (copy)
			p72._offsetFromParentVirtualizedList = p72:_selectOffset({
				x = p73,
				y = p74
			})
			p72._scrollMetrics.contentLength = p72:_selectLength({
				width = p75,
				height = p76
			})

			local v486 = p72._convertParentScrollMetrics(p72.context.getScrollMetrics())

			if p72._scrollMetrics.visibleLength ~= v486.visibleLength or p72._scrollMetrics.offset ~= v486.offset then
				p72._scrollMetrics.visibleLength = v486.visibleLength
				p72._scrollMetrics.offset = v486.offset
				p72._cellKeysToChildListKeys:forEach(function(p77) -- line: 2342
					-- upvalues: p72 (copy)
					if p77 then
						p77:forEach(function(p78) -- line: 2344
							-- upvalues: p72 (copy)
							local v490 = p72._nestedChildLists:get(p78)

							if v490 and v490.ref then
								v490.ref:measureLayoutRelativeToContainingList()
							end
						end)
					end
				end)
			end
		end, function(_) -- line: 2354
			-- upvalues: console (copy)
			console.warn("VirtualizedList: Encountered an error while measuring a list's offset from its containing VirtualizedList.")
		end)

		return nil
	end)

	if not ok then
		console.warn("measureLayoutRelativeToContainingList threw an error", result.stack)
	end
end
function v42._getFooterCellKey(p80) -- line: 2368
	return p80:_getCellKey() .. "-footer"
end
function v42._renderDebugOverlay(p81) -- line: 2372
	-- upvalues: Boolean (copy), React (copy), View (copy), u30 (ref), Array (copy)
	local v276 = p81._scrollMetrics.visibleLength / (not Boolean.toJSBoolean(p81._scrollMetrics.contentLength) and 1 or p81._scrollMetrics.contentLength)
	local t29 = {}
	local v278 = p81.props.getItemCount(p81.props.data)
	local n20 = 1

	while n20 <= v278 do
		local v280 = p81._getFrameMetricsApprox(n20)

		if Boolean.toJSBoolean(v280.inLayout) then
			table.insert(t29, v280)
		end

		n20 += 1
	end

	local offset = p81._getFrameMetricsApprox(p81.state.first).offset
	local v282 = p81._getFrameMetricsApprox(p81.state.last)
	local v283 = v282.offset + v282.length - offset
	local offset2 = p81._scrollMetrics.offset
	local visibleLength = p81._scrollMetrics.visibleLength

	return React.createElement(View, {
		style = {
			u30.debugOverlayBase,
			u30.debugOverlay
		}
	}, Array.map(t29, function(p82, n21: number) -- line: 2397
		-- upvalues: React (copy), View (copy), u30 (ref), v276 (copy)
		return React.createElement(View, {
			key = "f" .. tostring(n21),
			Name = "f" .. tostring(n21),
			style = {
				u30.debugOverlayBase,
				u30.debugOverlayFrame,
				{
					top = p82.offset * v276,
					height = p82.length * v276
				}
			}
		})
	end), React.createElement(View, {
		Name = "DebugOverlayLast",
		style = {
			u30.debugOverlayBase,
			u30.debugOverlayFrameLast,
			{
				top = offset * v276,
				height = v283 * v276
			}
		}
	}), React.createElement(View, {
		Name = "DebugOverlayVis",
		style = {
			u30.debugOverlayBase,
			u30.debugOverlayFrameVis,
			{
				top = offset2 * v276,
				height = visibleLength * v276
			}
		}
	}))
end
function v42._selectLength(p83, p84) -- line: 2427
	local horizontal = p83.props.horizontal

	if horizontal == nil or not horizontal then
		return p84.height
	end

	return p84.width
end
function v42._selectOffset(p85, p86) -- line: 2434
	local horizontal = p85.props.horizontal

	if horizontal == nil or not horizontal then
		return p86.y
	end

	return p86.x
end
function v42._maybeCallOnEndReached(p87) -- line: 2441
	local data = p87.props.data
	local getItemCount = p87.props.getItemCount
	local onEndReached = p87.props.onEndReached
	local onEndReachedThreshold = p87.props.onEndReachedThreshold
	local contentLength = p87._scrollMetrics.contentLength
	local visibleLength = p87._scrollMetrics.visibleLength
	local offset = p87._scrollMetrics.offset
	local v300 = contentLength - visibleLength - offset
	local v301 = onEndReachedThreshold == nil and 2 or onEndReachedThreshold * visibleLength

	if onEndReached and (p87.state.last == getItemCount(data) and v300 < v301 and p87._scrollMetrics.contentLength ~= p87._sentEndForContentLength) then
		p87._sentEndForContentLength = p87._scrollMetrics.contentLength
		onEndReached({
			distanceFromEnd = v300
		})

		return
	end

	if v301 < v300 then
		p87._sentEndForContentLength = 0
	end
end
function v42._scheduleCellsToRenderUpdate(p88) -- line: 2466
	-- upvalues: Boolean (copy)
	local first = p88.state.first
	local last = p88.state.last

	if p88.state.scrollPositionDelta > 0 then
		return
	end

	local offset = p88._scrollMetrics.offset
	local visibleLength = p88._scrollMetrics.visibleLength
	local velocity = p88._scrollMetrics.velocity
	local v308 = p88.props.getItemCount(p88.props.data)
	local v309 = false
	local onEndReachedThreshold = p88.props.onEndReachedThreshold
	local v311 = ((if onEndReachedThreshold ~= nil then onEndReachedThreshold else 2)) * visibleLength / 2

	if first > 1 then
		local v312 = offset - p88._getFrameMetricsApprox(first).offset

		v309 = v309 or (v312 < 0 or velocity < -2 and v312 < v311)
	end

	if last < v308 then
		local v313 = p88._getFrameMetricsApprox(last).offset - (offset + visibleLength)

		v309 = v309 or (v313 < 0 or velocity > 2)
	end

	if v309 and ((Boolean.toJSBoolean(p88._averageCellLength) or p88.props.getItemLayout) and not p88._hiPriInProgress) then
		p88._hiPriInProgress = true
		p88._updateCellsToRenderBatcher:dispose({
			abort = true
		})
		p88._updateCellsToRender()

		return
	end

	p88._updateCellsToRenderBatcher:schedule()
end
function v42._updateViewableItems(p89, p90) -- line: 2513
	-- upvalues: Array (copy)
	local getItemCount = p89.props.getItemCount

	Array.forEach(p89._viewabilityTuples, function(p91) -- line: 2515
		-- upvalues: getItemCount (copy), p90 (copy), p89 (copy)
		p91.viewabilityHelper:onUpdate(getItemCount(p90), p89._scrollMetrics.offset, p89._scrollMetrics.visibleLength, p89._getFrameMetrics, p89._createViewToken, p91.onViewableItemsChanged, p89.state)
	end)
end

u31 = React.Component:extend("CellRenderer")

function u31.init(p92, p93) -- line: 2576
	-- upvalues: React (copy)
	p92.props = p93
	p92.state = {
		separatorProps = {
			highlighted = false,
			leadingItem = p92.props.item
		}
	}
	p92._separators = {
		highlight = function() -- line: 2588
			-- upvalues: p92 (copy)
			local cellKey = p92.props.cellKey
			local prevCellKey = p92.props.prevCellKey

			p92.props.onUpdateSeparators({
				cellKey,
				prevCellKey
			}, {
				highlighted = true
			})
		end,
		unhighlight = function() -- line: 2592
			-- upvalues: p92 (copy)
			local cellKey = p92.props.cellKey
			local prevCellKey = p92.props.prevCellKey

			p92.props.onUpdateSeparators({
				cellKey,
				prevCellKey
			}, {
				highlighted = false
			})
		end,
		updateProps = function(s7: string, p94) -- line: 2596
			-- upvalues: p92 (copy)
			local cellKey = p92.props.cellKey
			local prevCellKey = p92.props.prevCellKey

			p92.props.onUpdateSeparators({ if s7 ~= "leading" then cellKey else prevCellKey }, p94)
		end
	}
	p92._nativeRef = React.createRef()
end
function u31.getDerivedStateFromProps(t30: {[any]: any}, t31: {[any]: any}) -- line: 2608
	-- upvalues: Object (copy)
	return {
		separatorProps = Object.assign({}, t31.separatorProps, {
			leadingItem = t30.item
		})
	}
end
function u31.updateSeparatorProps(p95, p96) -- line: 2612
	-- upvalues: Object (copy)
	p95:setState(function(p97) -- line: 2613
		-- upvalues: Object (copy), p96 (copy)
		return {
			separatorProps = Object.assign({}, p97.separatorProps, p96)
		}
	end)
end
function u31.componentWillUnmount(p98) -- line: 2618
	p98.props.onUnmount(p98.props.cellKey)
end
function u31._renderElement(p99, p100, p101, p102, p103) -- line: 2622
	-- upvalues: Boolean (copy), console (copy), React (copy), invariant (copy)
	if Boolean.toJSBoolean(p100) and Boolean.toJSBoolean(p101) then
		console.warn("VirtualizedList: Both ListItemComponent and renderItem props are present. ListItemComponent will take precedence over renderItem.")
	end

	if Boolean.toJSBoolean(p101) then
		return React.createElement(p101, {
			item = p102,
			index = p103,
			separators = p99._separators
		})
	end

	if Boolean.toJSBoolean(p100) then
		return p100({
			item = p102,
			index = p103,
			separators = p99._separators
		})
	end

	invariant(false, "VirtualizedList: Either ListItemComponent or renderItem props are required but none were found.")

	return nil
end
function u31.getRef(p104) -- line: 2653
	return p104._nativeRef
end
function u31.render(p105) -- line: 2658
	-- upvalues: React (copy), Object (copy), Boolean (copy), u30 (ref), View (copy), VirtualizedListCellContextProvider (copy)
	local CellRendererComponent = p105.props.CellRendererComponent
	local ItemSeparatorComponent = p105.props.ItemSeparatorComponent
	local fillRateHelper = p105.props.fillRateHelper
	local horizontal = p105.props.horizontal
	local item = p105.props.item
	local index = p105.props.index
	local inversionStyle = p105.props.inversionStyle
	local parentProps = p105.props.parentProps
	local renderItem = parentProps.renderItem
	local getItemLayout = parentProps.getItemLayout
	local v341 = p105:_renderElement(renderItem, parentProps.ListItemComponent, item, index)
	local v342 = if not getItemLayout or (parentProps.debug or fillRateHelper:enabled()) then p105.props.onLayout else nil
	local v343 = ItemSeparatorComponent and React.createElement(ItemSeparatorComponent, Object.assign(p105.state.separatorProps, {
		LayoutOrder = not inversionStyle and 1 or -1
	}))
	local v344 = if not Boolean.toJSBoolean(inversionStyle) then if not horizontal then inversionStyle else {
		u30.row,
		inversionStyle
	} else if not horizontal then {
		u30.columnReverse,
		inversionStyle
	} else {
		u30.rowReverse,
		inversionStyle
	}
	local v345 = if Boolean.toJSBoolean(CellRendererComponent) then React.createElement(CellRendererComponent, Object.assign(table.clone(p105.props), {
		style = v344,
		onLayout = v342,
		nativeRef = p105._nativeRef
	}), if not v343 then nil else React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = if not horizontal then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal
	}), v341, v343) else React.createElement(View, {
		Name = "CellRendererView",
		style = v344,
		onLayout = v342,
		LayoutOrder = if not inversionStyle then index else -index,
		AutomaticSize = if not horizontal then Enum.AutomaticSize.Y else Enum.AutomaticSize.X,
		nativeRef = p105._nativeRef,
		SelectionGroup = not not p105.props.isSequentiallySelectable or nil,
		SelectionBehaviorLeft = if not p105.props.isSequentiallySelectable then nil else if not p105.props.horizontal then Enum.SelectionBehavior.Stop else Enum.SelectionBehavior.Escape,
		SelectionBehaviorRight = if not p105.props.isSequentiallySelectable then nil else if not p105.props.horizontal then Enum.SelectionBehavior.Stop else Enum.SelectionBehavior.Escape,
		SelectionBehaviorUp = if not p105.props.isSequentiallySelectable then nil else if not p105.props.horizontal then Enum.SelectionBehavior.Escape else Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = if not p105.props.isSequentiallySelectable then nil else if not p105.props.horizontal then Enum.SelectionBehavior.Escape else Enum.SelectionBehavior.Stop
	}, if not v343 then nil else React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = if not horizontal then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal
	}), v341, v343)

	return React.createElement(VirtualizedListCellContextProvider, {
		cellKey = p105.props.cellKey
	}, v345)
end
function describeNestedLists(t32: {[any]: any}) -- line: 2747
	-- upvalues: Boolean (copy)
	local v347 = "VirtualizedList trace:\n" .. ("  Child (%s):\n"):format(not Boolean.toJSBoolean(t32.horizontal) and "vertical" or "horizontal") .. ("    listKey: %s\n"):format(t32.key) .. ("    cellKey: %s"):format(t32.cellKey)
	local parentDebugInfo = t32.parentDebugInfo

	while parentDebugInfo do
		v347 ..= ("\n  Parent (%s):\n"):format(not parentDebugInfo.horizontal and "vertical" or "horizontal") .. ("    listKey: %s\n"):format(parentDebugInfo.listKey) .. ("    cellKey: %s"):format(parentDebugInfo.cellKey)
		parentDebugInfo = parentDebugInfo.parent
	end

	return v347
end

u30 = StyleSheet.create({
	verticallyInverted = {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Bottom
	},
	horizontallyInverted = {
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center
	},
	row = {
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0)
	},
	column = {
		AutomaticSize = Enum.AutomaticSize.Y
	},
	rowReverse = {
		flexDirection = "row-reverse",
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0)
	},
	columnReverse = {
		flexDirection = "column-reverse",
		AutomaticSize = Enum.AutomaticSize.Y
	},
	debug = {
		flex = 1
	},
	debugOverlayBase = {
		position = "absolute",
		top = 0,
		right = 0
	},
	debugOverlay = {
		bottom = 0,
		width = 20,
		borderColor = "blue",
		borderWidth = 1
	},
	debugOverlayFrame = {
		left = 0,
		backgroundColor = "orange"
	},
	debugOverlayFrameLast = {
		left = 0,
		borderColor = "green",
		borderWidth = 2
	},
	debugOverlayFrameVis = {
		left = 0,
		borderColor = "red",
		borderWidth = 2
	}
})

return v42
