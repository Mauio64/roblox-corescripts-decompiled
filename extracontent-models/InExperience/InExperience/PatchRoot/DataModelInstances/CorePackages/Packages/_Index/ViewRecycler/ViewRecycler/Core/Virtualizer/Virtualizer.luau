local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local AutoScroll = require(ViewRecycler.Core.ViewportBehavior.AutoScroll)
require(ViewRecycler.Core.Enums.AutoScrollPolicy)
local AutoScrollTarget = require(ViewRecycler.Core.Enums.AutoScrollTarget)
local DataPrefetch = require(ViewRecycler.Core.DataPrefetch)
require(ViewRecycler.Core.DataSource)
local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
local Diagnostics = require(ViewRecycler.Core.Diagnostics)
require(ViewRecycler.Core.Layout)
local PaginationEdges = require(ViewRecycler.Core.ViewportBehavior.PaginationEdges)
require(ViewRecycler.Core.PinnedItems)
local PlacementTypes = require(ViewRecycler.Core.Placement.PlacementTypes)
require(ViewRecycler.Core.ViewportBehavior.ReachedThreshold)
local ScrollAlignment = require(ViewRecycler.Core.Enums.ScrollAlignment)
local ScrollObservationKind = require(ViewRecycler.Core.Enums.ScrollObservationKind)
require(ViewRecycler.Core.Types)
local DataPrefetchController = require(ViewRecycler.Core.Virtualizer.DataPrefetchController)
local ListRows = require(ViewRecycler.Core.Virtualizer.ListRows)
local createPinnedItemPlanner = require(ViewRecycler.Core.PinnedItems.createPinnedItemPlanner)
require(ViewRecycler.Core.Recycling.RecyclingScope)
local ScrollAnchor = require(ViewRecycler.Core.Virtualizer.ScrollAnchor)

local ScrollPolicy = require(ViewRecycler.Core.ViewportBehavior.ScrollPolicy)
local SlotBinder = require(ViewRecycler.Core.Recycling.SlotBinder)
local Viewport = require(ViewRecycler.Core.Virtualizer.Viewport)

local frozen = table.freeze({})

local anchorConfig
local paginationConfig
local policyConfig

if FFlagViewRecyclerReact08 then
	anchorConfig = function(data)
		return {
			preserveScrollPositionOnChange = data.preserveScrollPositionOnChange ~= false,
			initialScrollAlignment = data.initialScrollAlignment,
			autoScrollOnChange = data.autoScrollOnChange,
			autoScrollThreshold = data.autoScrollThreshold
		}
	end

	paginationConfig = function(data)
		return {
			startReachedThreshold = data.startReachedThreshold,
			startReachedEnabled = data.startReachedEnabled == true,
			endReachedEnabled = data.endReachedEnabled == true
		}
	end
else
	policyConfig = function(data)
		return {
			initialScrollAlignment = data.initialScrollAlignment,
			autoScrollOnChange = data.autoScrollOnChange,
			autoScrollThreshold = data.autoScrollThreshold,
			startReachedThreshold = data.startReachedThreshold,
			startReachedEnabled = data.startReachedEnabled == true,
			endReachedEnabled = data.endReachedEnabled == true
		}
	end
end

local function keyOnly(p) -- 4 equivalent calls inferred from this helper
	if p == nil then
		return nil
	end

	return { key = p.key }
end

local function createVirtualizer(data)
	local itemSequence = data.dataSource
	local layout = data.layout
	local isItemStickyHeader = data.isItemStickyHeader
	local pinnedStartItem = data.pinnedStartItem
	local pinnedEndItem = data.pinnedEndItem
	local v

	if FFlagViewRecyclerReact08 then
		v = nil
	else
		v = data.preserveScrollPositionOnChange ~= false
	end

	local dataPrefetch = data.dataPrefetch
	local v2 = isItemStickyHeader ~= nil or pinnedStartItem ~= nil or pinnedEndItem ~= nil
	local viewport = Viewport({
		layout = layout,
		overscan = data.overscan,
		contentAlignment = data.contentAlignment,
		endThreshold = data.endThreshold
	})
	local v3, isLaidOut

	if FFlagViewRecyclerReact08 then
		v3 = false

		isLaidOut = function()
			local v4 = v3

			if v4 then
				if viewport.getLength() > 0 then
					return itemSequence.getItemCount() == 0 or viewport.getContentLength() > 0
				end

				return false
			end

			return v4
		end
	else
		isLaidOut = nil
		v3 = nil
	end

	local v4 = itemSequence
	local pinnedItemPlanner = createPinnedItemPlanner(v4, {
		isItemStickyKey = isItemStickyHeader,
		pinnedStartItem = keyOnly(pinnedStartItem), -- inferred equivalent call
		pinnedEndItem = keyOnly(pinnedEndItem) -- inferred equivalent call
	})

	local dataPrefetchController = DataPrefetchController(dataPrefetch)
	local v5 = {
		viewport = viewport,
		getItemSequence = function()
			return itemSequence
		end,
		isLaidOut = 0,
		config = 0,
		shouldPreserveUserPosition = 0
	}
	local isLaidOut2

	if FFlagViewRecyclerReact08 then
		isLaidOut2 = isLaidOut
	end

	v5.isLaidOut = isLaidOut2
	local config

	if FFlagViewRecyclerReact08 then
		config = anchorConfig(data)
	end

	v5.config = config

	v5.shouldPreserveUserPosition = not FFlagViewRecyclerReact08 and function()
		return v
	end or nil
	local scrollAnchor = ScrollAnchor(v5)

	local v6 = nil
	local prepareDesiredAssignment = nil
	local v7 = nil

	if FFlagViewRecyclerReact08 then
		v6 = PaginationEdges.create(paginationConfig(data))
		prepareDesiredAssignment = data.prepareDesiredAssignment
	else
		v7 = ScrollPolicy(policyConfig(data))
	end

	local v8 = {
		recyclingScope = data.recyclingScope,
		name = FFlagViewRecyclerReact08 and "Virtualizer" or nil,
		prepareDesiredAssignment = 0
	}
	local prepareDesiredAssignment2

	if FFlagViewRecyclerReact08 then
		prepareDesiredAssignment2 = prepareDesiredAssignment ~= nil and function(p)
			return prepareDesiredAssignment({ key = p.key, value = p.value })
		end or nil
	else
		prepareDesiredAssignment2 = data.prepareDesiredAssignment
	end

	v8.prepareDesiredAssignment = prepareDesiredAssignment2
	local listRows = ListRows({
		slotBinder = SlotBinder(v8),
		getItemViewType = data.getItemViewType,
		getPinnedItem = function(p)
			if p == PlacementTypes.PinnedPosition.Start then
				return pinnedStartItem
			end

			return pinnedEndItem
		end
	})

	if not FFlagViewRecyclerReact08 then
		v3 = false
	end

	local v9 = true
	local flag = false
	local v10 = false
	local v11 = nil
	local current = nil

	local function addDiagnostic(p, p2) -- 6 equivalent calls inferred from this helper
		if table.isfrozen(p.diagnostics) then
			p.diagnostics = {}
		end

		table.insert(p.diagnostics, p2)
	end

	local function applyCorrection(p, p2)
		if p2 == nil then
			return
		end

		local scrollOffset = viewport.getScrollOffset()
		viewport.setScrollOffset(scrollOffset + p2.delta)
		local delta = viewport.getScrollOffset() - scrollOffset
		p.scrollCorrection += delta
		p.scrollPositionChanged = true
		p.scrollPositionFollowsCorrection = true

		if data.diagnostics ~= nil then
			addDiagnostic(p, { -- inferred equivalent call
				kind = Diagnostics.EventKind.ScrollCorrection,
				source = p2.source,
				delta = delta
			})
		end
	end

	local function moveScrollPosition(p) -- 9 equivalent calls inferred from this helper
		p.scrollPositionChanged = true
		p.scrollPositionFollowsCorrection = false
	end

	local moveTo
	local applyPolicyTarget

	if FFlagViewRecyclerReact08 then
		moveTo = function(p, p2: number)
			local scrollOffset = viewport.getScrollOffset()
			local scrollTo = viewport.scrollTo(p2)
			scrollAnchor.setViewport(scrollTo)

			if scrollTo ~= scrollOffset then
				moveScrollPosition(p) -- inferred equivalent call
			end
		end
	else
		applyPolicyTarget = function(state, p: number?)
			if p == nil or not scrollAnchor.allowsPolicyOffset() then
				return
			end

			local scrollOffset = viewport.getScrollOffset()

			if viewport.scrollTo(p) ~= scrollOffset then
				moveScrollPosition(state) -- inferred equivalent call
			end
		end
	end

	local function readKeys()
		local itemCount = itemSequence.getItemCount()
		local keys = table.create(itemCount)

		for i = 1, itemCount do
			keys[i] = itemSequence.getItemKey(i)
		end

		return keys
	end

	local function resetLayout(keys) -- 3 equivalent calls inferred from this helper
		layout.applyDataSourceChange({ type = DataSourceChangeType.Reset, keys = keys })
		viewport.refresh()
	end

	local function unsubscribe() -- 2 equivalent calls inferred from this helper
		if v11 ~= nil then
			v11()
			v11 = nil
		end
	end

	local v12 = {}

	local function beginTransaction()
		local v13 = v12

		if FFlagViewRecyclerReact08 then
			v13.settlesScroll = true
		else
			v13.policyEligible = true
		end

		v13.dataChange = nil

		if not FFlagViewRecyclerReact08 then
			v13.before = nil
		end

		v13.replaced = false
		v13.viewportChanged = false
		v13.scrollMoved = false

		if FFlagViewRecyclerReact08 then
			v13.keptDistanceFromEnd = nil
		end

		v13.contentLengthBefore = viewport.getContentLength()
		v13.scrollCorrection = 0
		v13.scrollPositionChanged = false
		v13.scrollPositionFollowsCorrection = false
		v13.contentLengthChanged = false
		v13.startReached = false
		v13.endReached = false
		v13.entered = frozen
		v13.updated = frozen
		v13.departed = frozen
		v13.dataPrefetchRequests = frozen
		v13.diagnostics = frozen
		return v13
	end

	local function checkEdges(state, flag2: boolean)
		local v13, v14

		if FFlagViewRecyclerReact08 then
			if v6.isEnabled() and isLaidOut() then
				v13, v14 = v6.check(viewport.scrollState(), flag2)
			else
				return
			end
		else
			v13, v14 = v7.checkEdges(viewport.scrollState(), itemSequence.getItemCount(), flag2)
		end

		state.startReached = state.startReached or v13
		state.endReached = state.endReached or v14
	end

	local moveSettled
	local settleScroll
	local policyContext
	local settlePolicy

	if FFlagViewRecyclerReact08 then
		moveSettled = function(p: number)
			moveTo(v12, p)
		end

		settleScroll = function(state)
			state.contentLengthChanged = viewport.getContentLength() ~= state.contentLengthBefore
			scrollAnchor.settle(state, moveSettled)
			local dataChange = state.dataChange
			checkEdges(state, dataChange ~= nil and PaginationEdges.hasStructuralChange(dataChange))
		end
	else
		policyContext = function()
			return {
				itemCount = itemSequence.getItemCount(),
				scrollState = viewport.scrollState(),
				getScrollOffsetForItem = viewport.offsetForItem
			}
		end

		settlePolicy = function(state)
			if viewport.getContentLength() ~= state.contentLengthBefore then
				state.contentLengthChanged = true
				applyPolicyTarget(state, v7.contentLengthChanged(viewport.scrollState()))
			end

			local dataChange = state.dataChange

			if dataChange == nil then
				if state.replaced then
					applyPolicyTarget(state, v7.dataReplaced(policyContext()))
					v7.observe(viewport.scrollState())
				end

				if state.viewportChanged then
					applyPolicyTarget(state, v7.viewportChanged(policyContext()))
					v7.observe(viewport.scrollState())
				elseif state.scrollMoved then
					v7.observe(viewport.scrollState())
				end

				if v7.reachesEdges() then
					checkEdges(state, false)
				end
			else
				applyPolicyTarget(state, v7.dataChanged(policyContext(), state.before))
				checkEdges(state, PaginationEdges.hasStructuralChange(dataChange))
			end
		end
	end

	local v13 = {}
	local v14 = {}

	local function settle(state)
		viewport.refresh()
		local v15

		if FFlagViewRecyclerReact08 then
			v15 = state.settlesScroll
		else
			v15 = state.policyEligible
		end

		if v15 then
			if FFlagViewRecyclerReact08 then
				settleScroll(state)
			else
				settlePolicy(state)
			end
		end

		local v16, v17 = viewport.updateRanges()

		if data.diagnostics ~= nil then
			if v16 then
				local visibleRange = viewport.getVisibleRange()
				addDiagnostic(state, { -- inferred equivalent call
					kind = Diagnostics.EventKind.RangeChanged,
					rangeKind = Diagnostics.RangeKind.Visible,
					firstIndex = visibleRange.firstIndex,
					lastIndex = visibleRange.lastIndex
				})
			end

			if v17 then
				local mountedRange = viewport.getMountedRange()
				addDiagnostic(state, { -- inferred equivalent call
					kind = Diagnostics.EventKind.RangeChanged,
					rangeKind = Diagnostics.RangeKind.Rendered,
					firstIndex = mountedRange.firstIndex,
					lastIndex = mountedRange.lastIndex
				})
			end
		end

		if flag then
			return
		end

		if v9 then
			local scrollOffset = viewport.getScrollOffset()
			local contentStartOffset = viewport.getContentStartOffset()
			v13.dataSource = itemSequence
			v13.layout = layout
			v13.mountedRange = viewport.getMountedRange()
			v13.scrollOffset = scrollOffset
			v13.contentStartOffset = contentStartOffset
			local plan

			if v2 then
				plan = pinnedItemPlanner.update({
					itemSequence = itemSequence,
					layout = layout,
					scrollOffset = scrollOffset,
					viewportLength = viewport.getLength(),
					contentStartOffset = contentStartOffset
				})
			end

			v13.plan = plan

			local v18, v19 = listRows.apply(v13)

			if v18 ~= nil then
				state.entered = v18.entered
				state.updated = v18.updated
				state.departed = v18.departed
			end

			if v19 ~= nil then
				addDiagnostic(state, v19) -- inferred equivalent call
			end
		elseif listRows.isApplied() then
			state.departed = listRows.release()
		end

		v14.itemSequence = itemSequence
		v14.mountedRange = viewport.getMountedRange()
		v14.options = dataPrefetch
		state.dataPrefetchRequests = dataPrefetchController.reconcile(v14)
	end

	local function frozen2(list) -- 4 equivalent calls inferred from this helper
		if table.isfrozen(list) then
			return list
		end

		return (table.freeze(list))
	end

	local function makeRecord(data2)
		local v15 = current
		local v16 = {
			mountedViews = listRows.getMountedViews(),
			entered = frozen2(data2.entered), -- inferred equivalent call
			updated = frozen2(data2.updated), -- inferred equivalent call
			departed = frozen2(data2.departed), -- inferred equivalent call
			visibleRange = viewport.getVisibleRange(),
			mountedRange = viewport.getMountedRange(),
			scrollState = 0,
			contentStartOffset = 0,
			contentLength = 0,
			requiresItemMeasurement = 0,
			scrollCorrection = 0,
			scrollPositionChanged = 0,
			scrollPositionFollowsCorrection = 0,
			scrollAnchor = 0,
			contentLengthChanged = 0,
			startReached = 0,
			endReached = 0,
			dataPrefetchRequests = 0,
			diagnostics = 0
		}
		local scrollState = viewport.scrollState
		local v17

		if v15 ~= nil then
			v17 = v15.scrollState
		end

		v16.scrollState = scrollState(v17)
		v16.contentStartOffset = viewport.getContentStartOffset()
		v16.contentLength = viewport.getContentLength()
		v16.requiresItemMeasurement = layout.requiresItemMeasurement()
		v16.scrollCorrection = data2.scrollCorrection
		v16.scrollPositionChanged = data2.scrollPositionChanged
		v16.scrollPositionFollowsCorrection = data2.scrollPositionFollowsCorrection
		v16.scrollAnchor = scrollAnchor.getAnchoredItem()
		v16.contentLengthChanged = data2.contentLengthChanged
		v16.startReached = data2.startReached
		v16.endReached = data2.endReached
		v16.dataPrefetchRequests = data2.dataPrefetchRequests
		v16.diagnostics = frozen2(data2.diagnostics) -- inferred equivalent call
		return (table.freeze(v16))
	end

	local function mutateAndSettle(callback, p, p2, p3)
		callback(p, p2, p3)
		settle(p)
	end

	local function transact(callback, p, p2)
		assert(not v10, "Virtualizer: cannot mutate during a transaction")
		assert(not flag, "Virtualizer: cannot dispatch after destruction")
		v10 = true
		local v15 = beginTransaction()
		local success, result = pcall(mutateAndSettle, callback, v15, p, p2)
		v10 = false

		if not success then
			error(result, 0)
		end

		local v16 = current
		local record = makeRecord(v15)
		current = record

		if data.diagnostics ~= nil then
			for _, diagnostic in record.diagnostics do
				data.diagnostics(diagnostic)
			end
		end

		if data.onTransaction ~= nil then
			data.onTransaction(v16, record)
		end

		return record
	end

	local function applyDataChange(p, dataChange)
		if not FFlagViewRecyclerReact08 then
			p.before = viewport.scrollState()
		end

		p.dataChange = dataChange
		listRows.noteDataChange(dataChange)
		local v15 = false
		applyCorrection(
			p,
			scrollAnchor.preserve(
				{ source = Diagnostics.ScrollCorrectionSource.Data, dataSourceChange = dataChange },
				function()
					for _, change in dataChange.changes do
						v15 = layout.applyDataSourceChange(change) or v15
					end

					pinnedItemPlanner.applyDataSourceChange(dataChange)
					viewport.refresh()
				end
			)
		)

		if v15 then
			listRows.invalidateLayout()
		end
	end

	local function fn(p)
		transact(applyDataChange, p)
	end

	local function fn2()
		if v11 == nil and v3 and not flag then
			v11 = itemSequence.subscribe(fn)
		end
	end

	local function replaceDataSource(p) -- 2 equivalent calls inferred from this helper
		if p ~= itemSequence then
			unsubscribe() -- inferred equivalent call
			itemSequence = p
		end

		pinnedItemPlanner.setItemSequence(itemSequence)
	end

	local function replaceLayout(p) -- 2 equivalent calls inferred from this helper
		layout = p
		viewport.setLayout(p)
		local crossAxisLength = viewport.getCrossAxisLength()

		if crossAxisLength > 0 then
			p.setViewportCrossAxisLength(crossAxisLength)
		end

		listRows.invalidateLayout()
	end

	local function resetData() -- 2 equivalent calls inferred from this helper
		if FFlagViewRecyclerReact08 then
			scrollAnchor.dataSourceReplaced()
		else
			scrollAnchor.reset()
		end

		resetLayout(readKeys()) -- inferred equivalent call
		listRows.invalidateKeys()
		listRows.invalidatePayloads()
		fn2()
	end

	local function submitMeasurements(p, p2)
		local v15, v16 = listRows.validate(p2)

		if #v15 > 0 and data.diagnostics ~= nil then
			addDiagnostic(p, { -- inferred equivalent call
				kind = Diagnostics.EventKind.MeasurementsProcessingStarted,
				submitted = #v15,
				boundaryDropped = v16
			})
		end

		local count = 0
		local v17 = false
		local v18 = nil
		local v19 = {
			source = Diagnostics.ScrollCorrectionSource.Measurement,
			preserveStartAnchor = true,
			startInsetDelta = 0
		}

		local start = pinnedItemPlanner.getContentInsets().start
		applyCorrection(p, scrollAnchor.preserve(v19, function()
			for _, v20 in v15 do
				local index = v20.index

				if index == nil then
					if v20.pinnedPosition == nil then
						v16 += 1
					else
						local v21 = pinnedItemPlanner.updatePinnedMeasurement(
							v20.pinnedPosition,
							v20.key,
							v20.pinnedRevision,
							v20.length
						)

						if v21 == nil then
							v16 += 1
						else
							count += 1
							v18 = v21
						end
					end
				else
					local v21 = layout.updateItemMeasurement({
						itemIndex = index,
						itemKey = v20.key,
						length = v20.length
					})

					if v21.accepted then
						count += 1
					else
						v16 += 1
					end

					v17 = v17 or v21.geometryChanged
				end
			end

			if v18 ~= nil then
				v19.startInsetDelta = v18.start - start
				viewport.setInsets(v18.start, v18.finish)
				v17 = true
			end

			viewport.refresh()
		end))

		if data.diagnostics ~= nil and #v15 > 0 then
			addDiagnostic(p, { -- inferred equivalent call
				kind = Diagnostics.EventKind.MeasurementsProcessed,
				accepted = count,
				dropped = v16
			})
		end

		if v17 then
			listRows.invalidateLayout()
		end
	end

	local function setPolicy(data2)
		DataPrefetch.resolve(data2.dataPrefetch)
		local pinnedItems = data2.pinnedItems
		viewport.setOverscan(data2.overscan)
		viewport.setContentAlignment(data2.contentAlignment)
		viewport.setEndThreshold(data2.endThreshold)

		if not FFlagViewRecyclerReact08 then
			v = data2.preserveScrollPositionOnChange ~= false
		end

		dataPrefetch = data2.dataPrefetch
		isItemStickyHeader = pinnedItems.isItemStickyHeader
		pinnedStartItem = pinnedItems.pinnedStartItem
		pinnedEndItem = pinnedItems.pinnedEndItem

		if pinnedItemPlanner.setOptions({
			isItemStickyKey = isItemStickyHeader,
			pinnedStartItem = keyOnly(pinnedStartItem), -- inferred equivalent call
			pinnedEndItem = keyOnly(pinnedEndItem) -- inferred equivalent call
		}) then
			local contentInsets = pinnedItemPlanner.getContentInsets()
			viewport.setInsets(contentInsets.start, contentInsets.finish)
		end

		v2 = isItemStickyHeader ~= nil or pinnedStartItem ~= nil or pinnedEndItem ~= nil

		if not FFlagViewRecyclerReact08 then
			v7.configure(policyConfig(data2))

			return
		end

		scrollAnchor.configure(anchorConfig(data2))
		v6.configure(paginationConfig(data2))
	end

	local function setActiveMutation(p, flag2: boolean)
		if FFlagViewRecyclerReact08 then
			p.settlesScroll = false
		else
			p.policyEligible = false
		end

		if flag2 and not v9 then
			listRows.invalidatePayloads()
		end

		v9 = flag2
	end

	local setScrollOffsetMutation = not FFlagViewRecyclerReact08 and function(_, p: number)
		if viewport.setScrollOffset(p) then
			scrollAnchor.setViewport(p)
		end
	end or nil

	local function observeScrollOffsetMutation(p, p2)
		local v15 = viewport.setScrollOffset(p2.offset)

		if p2.kind == ScrollObservationKind.Programmatic then
			scrollAnchor.observeHost(p2.offset)
		elseif v15 then
			scrollAnchor.setViewport(p2.offset)
		end

		if p2.kind == ScrollObservationKind.User then
			p.scrollMoved = true
		end
	end

	local finishProgrammaticScroll = FFlagViewRecyclerReact08 and function(p, p2)
		scrollAnchor.scrolledProgrammatically(p2)
		moveScrollPosition(p) -- inferred equivalent call

		if p2 == nil then
			p.scrollMoved = true
		end
	end or nil

	local function scrollToIndexMutation(p, p2: number, p3)
		if FFlagViewRecyclerReact08 then
			moveTo(p, viewport.offsetForItem(p2, p3))
		end

		scrollAnchor.setItemTarget(p2, p3)

		if FFlagViewRecyclerReact08 then
			finishProgrammaticScroll(p, nil)
			return
		end

		viewport.scrollTo(viewport.offsetForItem(p2, p3))
		moveScrollPosition(p) -- inferred equivalent call
		p.scrollMoved = true
	end

	local function scrollToOffsetMutation(p, p2: number)
		if FFlagViewRecyclerReact08 then
			moveTo(p, p2)
			finishProgrammaticScroll(p, nil)
		else
			scrollAnchor.setViewport(viewport.scrollTo(p2))
			moveScrollPosition(p) -- inferred equivalent call
			p.scrollMoved = true
		end
	end

	local function scrollByMutation(p, p2: number)
		if FFlagViewRecyclerReact08 then
			assert(math.abs(p2) < 1e999, "Virtualizer: scroll delta must be finite")
			moveTo(p, viewport.getScrollOffset() + p2)
			finishProgrammaticScroll(p, nil)
		else
			scrollAnchor.setViewport(viewport.scrollBy(p2))
			moveScrollPosition(p) -- inferred equivalent call
			p.scrollMoved = true
		end
	end

	local function scrollToEdgeMutation(p, p2)
		if FFlagViewRecyclerReact08 then
			moveTo(p, p2 == ScrollAlignment.Start and 0 or viewport.getContentLength() - viewport.getLength())

			finishProgrammaticScroll(p, p2)
		else
			scrollAnchor.setViewport(viewport.scrollTo(AutoScroll.getTargetOffset(
				p2,
				viewport.getContentLength(),
				viewport.getLength()
			)))

			v7.pin(p2)
			moveScrollPosition(p) -- inferred equivalent call
		end
	end

	local function setViewportSizeMutation(p, p2: number, p3: number)
		local length = viewport.getLength()
		local v15 = viewport.getContentLength() - length - viewport.getScrollOffset()

		if viewport.setSize(p2, p3) then
			if layout.setViewportCrossAxisLength(p3) then
				listRows.invalidateLayout()
			end

			local v16

			if FFlagViewRecyclerReact08 then
				v16 = length > 0
			elseif length > 0 then
				v16 = p2 ~= length
			else
				v16 = false
			end

			if v16 then
				local v17

				if FFlagViewRecyclerReact08 then
					v17 = p2 ~= length
				else
					v17 = viewport.getContentAlignment() == ScrollAlignment.End
				end

				if v17 then
					local v18

					if FFlagViewRecyclerReact08 then
						v18 = viewport.getContentAlignment() == ScrollAlignment.End
					else
						v18 = scrollAnchor.allowsPolicyOffset()
					end

					if v18 then
						if FFlagViewRecyclerReact08 then
							p.keptDistanceFromEnd = math.max(0, v15)
						else
							viewport.refresh()
							local scrollOffset = viewport.getScrollOffset()

							local scrollTo = viewport.scrollTo(viewport.getContentLength() - p2 - math.max(0, v15))

							if scrollTo ~= scrollOffset then
								scrollAnchor.setViewport(scrollTo)
								moveScrollPosition(p) -- inferred equivalent call
							end
						end
					end
				end
			end
		end

		p.viewportChanged = true
	end

	current = makeRecord(beginTransaction())

	return {
		activate = function()
			return transact(function(p)
				if not v3 then
					v3 = true
					local keys = readKeys()
					resetLayout(keys) -- inferred equivalent call
					pinnedItemPlanner.applyDataSourceChange({
						changes = {
							{ type = DataSourceChangeType.Reset, keys = keys }
						},
						previousItemCount = #keys,
						itemCount = #keys
					})

					listRows.invalidateKeys()
					fn2()
				end

				p.viewportChanged = true
			end)
		end,
		setActive = function(p)
			return transact(setActiveMutation, p)
		end,
		observeScrollOffset = function(p)
			return transact(observeScrollOffsetMutation, p)
		end,
		scrollToIndex = function(p, p2)
			return transact(scrollToIndexMutation, p, p2)
		end,
		scrollToOffset = function(p)
			return transact(scrollToOffsetMutation, p)
		end,
		scrollToStart = function()
			local v15

			if FFlagViewRecyclerReact08 then
				v15 = ScrollAlignment
			else
				v15 = AutoScrollTarget
			end

			return transact(scrollToEdgeMutation, v15.Start)
		end,
		scrollToEnd = function()
			local v15

			if FFlagViewRecyclerReact08 then
				v15 = ScrollAlignment
			else
				v15 = AutoScrollTarget
			end

			return transact(scrollToEdgeMutation, v15.End)
		end,
		scrollBy = function(p)
			return transact(scrollByMutation, p)
		end,
		restoreScrollAnchorSnapshot = function(p)
			return transact(function(p2)
				if FFlagViewRecyclerReact08 then
					moveTo(p2, scrollAnchor.snapshotOffset(p))
					scrollAnchor.restore(p, viewport.getScrollOffset())
					finishProgrammaticScroll(p2, nil)
				else
					scrollAnchor.restore(p, viewport.scrollTo(scrollAnchor.snapshotOffset(p)))
					moveScrollPosition(p2) -- inferred equivalent call
					p2.scrollMoved = true
				end
			end)
		end,
		setViewportSize = function(p, p2)
			return transact(setViewportSizeMutation, p, p2)
		end,
		setPolicy = function(p)
			return transact(function()
				setPolicy(p)
			end)
		end,
		setDataSource = function(p)
			return transact(function(p2)
				replaceDataSource(p) -- inferred equivalent call
				resetData() -- inferred equivalent call
				p2.replaced = true
			end)
		end,
		setLayout = function(p)
			return transact(function()
				replaceLayout(p) -- inferred equivalent call
				scrollAnchor.reset()
				resetLayout(readKeys()) -- inferred equivalent call
			end)
		end,
		setDataSourceAndLayout = function(p, p2)
			return transact(function(p3)
				replaceDataSource(p) -- inferred equivalent call
				replaceLayout(p2) -- inferred equivalent call
				resetData() -- inferred equivalent call
				p3.replaced = true
			end)
		end,
		refresh = function()
			return transact(function()
				listRows.invalidateKeys()
				listRows.invalidatePayloads()
			end)
		end,
		submitMeasurements = function(p)
			return transact(submitMeasurements, p)
		end,
		getCurrent = function()
			return current
		end,
		getItemLayout = function(p)
			return layout.getItemLayout(p)
		end,
		getScrollOffsetForItem = function(p, p2)
			return viewport.offsetForItem(p, p2)
		end,
		captureScrollAnchorSnapshot = function()
			local v15 = current
			local visibleRange = v15.visibleRange
			local scrollOffset = v15.scrollState.scrollOffset

			if visibleRange.firstIndex <= visibleRange.lastIndex then
				local firstIndex = visibleRange.firstIndex
				return {
					anchorKey = itemSequence.getItemKey(firstIndex),
					anchorIndex = firstIndex,
					offsetWithinItem = scrollOffset - v15.contentStartOffset - layout.getItemLayout(firstIndex).startOffset,
					fallbackScrollOffset = scrollOffset
				}
			end

			return {
				anchorKey = nil,
				anchorIndex = nil,
				offsetWithinItem = 0,
				fallbackScrollOffset = scrollOffset
			}
		end,
		destroy = function()
			if flag then
				return
			end

			transact(function(p)
				if FFlagViewRecyclerReact08 then
					p.settlesScroll = false
				else
					p.policyEligible = false
				end

				unsubscribe() -- inferred equivalent call
				p.departed = listRows.release()
				listRows.destroy()
				dataPrefetchController.destroy()
				pinnedItemPlanner.destroy()
				flag = true
			end)
		end,
		setScrollOffset = not FFlagViewRecyclerReact08 and function(p)
			return transact(setScrollOffsetMutation, p)
		end or nil
	}
end

return createVirtualizer
