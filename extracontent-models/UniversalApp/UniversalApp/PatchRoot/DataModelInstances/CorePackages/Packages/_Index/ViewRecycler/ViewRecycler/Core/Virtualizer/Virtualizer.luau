local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
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

local ScrollMotion = require(ViewRecycler.Core.Virtualizer.ScrollMotion)
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

local plannerItem
local policyConfig = nil
local keyOnly
local anchorConfig, paginationConfig

if FFlagViewRecyclerReact084 then
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

	plannerItem = function(p)
		if p == nil then
			return nil
		end

		return { key = p.key, estimatedLength = p.estimatedLength }
	end
else
	anchorConfig = nil
	paginationConfig = nil
	policyConfig = nil

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

	keyOnly = function(p)
		if p == nil then
			return nil
		end

		return { key = p.key }
	end
end

local function createVirtualizer(data)
	local itemSequence = data.dataSource
	local layout = data.layout
	local isItemStickyHeader = data.isItemStickyHeader
	local pinnedStartItem = data.pinnedStartItem
	local pinnedEndItem = data.pinnedEndItem
	local v

	if FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08 then
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

	if FFlagViewRecyclerReact084 then
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
	elseif FFlagViewRecyclerReact08 then
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
	local v5 = { isItemStickyKey = isItemStickyHeader, pinnedStartItem = 0, pinnedEndItem = 0 }
	local v6

	if FFlagViewRecyclerReact084 then
		v6 = plannerItem
	else
		v6 = keyOnly
	end

	v5.pinnedStartItem = v6(pinnedStartItem)
	local v7

	if FFlagViewRecyclerReact084 then
		v7 = plannerItem
	else
		v7 = keyOnly
	end

	v5.pinnedEndItem = v7(pinnedEndItem)
	local pinnedItemPlanner = createPinnedItemPlanner(v4, v5)

	if FFlagViewRecyclerReact084 then
		local contentInsets = pinnedItemPlanner.getContentInsets()
		viewport.setInsets(contentInsets.start, contentInsets.finish)
	end

	local dataPrefetchController = DataPrefetchController(dataPrefetch)
	local v8 = {
		viewport = viewport,
		getItemSequence = function()
			return itemSequence
		end,
		isLaidOut = 0,
		config = 0,
		shouldPreserveUserPosition = 0
	}
	local isLaidOut2

	if FFlagViewRecyclerReact084 then
		isLaidOut2 = isLaidOut
	elseif FFlagViewRecyclerReact08 then
		isLaidOut2 = isLaidOut
	end

	v8.isLaidOut = isLaidOut2
	local config

	if FFlagViewRecyclerReact084 then
		config = anchorConfig(data)
	elseif FFlagViewRecyclerReact08 then
		config = anchorConfig(data)
	end

	v8.config = config
	local shouldPreserveUserPosition

	if not FFlagViewRecyclerReact084 then
		shouldPreserveUserPosition = not FFlagViewRecyclerReact08 and function()
			return v
		end or nil
	end

	v8.shouldPreserveUserPosition = shouldPreserveUserPosition
	local scrollAnchor = ScrollAnchor(v8)

	local v9 = nil
	local v10, prepareDesiredAssignment

	if FFlagViewRecyclerReact084 then
		v10 = PaginationEdges.create(paginationConfig(data))
		prepareDesiredAssignment = data.prepareDesiredAssignment
	else
		v10 = nil
		prepareDesiredAssignment = nil
		v9 = nil

		if FFlagViewRecyclerReact08 then
			v10 = PaginationEdges.create(paginationConfig(data))
			prepareDesiredAssignment = data.prepareDesiredAssignment
		else
			v9 = ScrollPolicy(policyConfig(data))
		end
	end

	local v11 = {
		recyclingScope = data.recyclingScope,
		name = FFlagViewRecyclerReact084 and "Virtualizer" or FFlagViewRecyclerReact08 and "Virtualizer" or nil,
		prepareDesiredAssignment = 0
	}
	local prepareDesiredAssignment2

	if FFlagViewRecyclerReact084 then
		prepareDesiredAssignment2 = prepareDesiredAssignment ~= nil and function(p)
			return prepareDesiredAssignment({ key = p.key, value = p.value })
		end or nil
	elseif FFlagViewRecyclerReact08 then
		prepareDesiredAssignment2 = prepareDesiredAssignment ~= nil and function(p)
			return prepareDesiredAssignment({ key = p.key, value = p.value })
		end or nil
	else
		prepareDesiredAssignment2 = data.prepareDesiredAssignment
	end

	v11.prepareDesiredAssignment = prepareDesiredAssignment2
	local v12 = {
		slotBinder = SlotBinder(v11),
		getItemViewType = data.getItemViewType,
		isReadyOnAssignment = 0,
		getPinnedItem = 0
	}
	local isReadyOnAssignment

	if FFlagViewRecyclerReact084 then
		isReadyOnAssignment = data.isReadyOnAssignment
	end

	v12.isReadyOnAssignment = isReadyOnAssignment
	function v12.getPinnedItem(p)
		if p == PlacementTypes.PinnedPosition.Start then
			return pinnedStartItem
		end

		return pinnedEndItem
	end

	local listRows = ListRows(v12)

	if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
		v3 = false
	end

	local v13 = true
	local flag = false
	local v14 = false
	local v15 = nil
	local current = nil
	local v16, v17, findMotionIndex, resolveMotionTarget, stopMotion

	if FFlagViewRecyclerReact084 then
		v16 = nil
		v17 = nil

		findMotionIndex = function(state)
			local indexHint = state.indexHint

			if indexHint <= itemSequence.getItemCount() and itemSequence.getItemKey(indexHint) == state.key then
				return indexHint
			end

			for i = 1, itemSequence.getItemCount() do
				if itemSequence.getItemKey(i) == state.key then
					state.indexHint = i
					return i
				end
			end

			return nil
		end

		resolveMotionTarget = function()
			local v18 = v17

			if v18 == nil then
				return nil
			end

			if v18.kind == "index" then
				local motionIndex = findMotionIndex(v18)

				if motionIndex == nil then
					return nil
				end

				return (viewport.offsetForItem(motionIndex, v18.alignment))
			end

			if v18.kind ~= "edge" then
				return viewport.clamp(v18.offset)
			end

			if v18.edge == ScrollAlignment.Start then
				return 0
			end

			return (viewport.clamp(viewport.getContentLength() - viewport.getLength()))
		end

		stopMotion = function()
			if v16 ~= nil then
				v16 = nil
				v17 = nil
				scrollAnchor.endMotion()
			end
		end
	else
		v16 = nil
		resolveMotionTarget = nil
		stopMotion = nil
		v17 = nil
		findMotionIndex = nil
	end

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

	local function moveScrollPosition(p) -- 11 equivalent calls inferred from this helper
		p.scrollPositionChanged = true
		p.scrollPositionFollowsCorrection = false
	end

	local applyPolicyTarget = nil
	local moveTo

	if FFlagViewRecyclerReact084 then
		moveTo = function(p, p2: number)
			local scrollOffset = viewport.getScrollOffset()
			local scrollTo = viewport.scrollTo(p2)
			scrollAnchor.setViewport(scrollTo)

			if scrollTo ~= scrollOffset then
				moveScrollPosition(p) -- inferred equivalent call
			end
		end
	else
		moveTo = nil
		applyPolicyTarget = nil

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
			applyPolicyTarget = function(p, p2: number?)
				if p2 == nil or not scrollAnchor.allowsPolicyOffset() then
					return
				end

				local scrollOffset = viewport.getScrollOffset()

				if viewport.scrollTo(p2) ~= scrollOffset then
					moveScrollPosition(p) -- inferred equivalent call
				end
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

	local resolveItemEstimates = FFlagViewRecyclerReact084 and function()
		local resolveItemEstimates = layout.resolveItemEstimates
		local itemEstimates

		if resolveItemEstimates == nil then
			itemEstimates = false
		else
			itemEstimates = resolveItemEstimates(itemSequence.getItem)
		end

		return itemEstimates
	end or nil

	local function resetLayout(keys) -- 3 equivalent calls inferred from this helper
		layout.applyDataSourceChange({ type = DataSourceChangeType.Reset, keys = keys })

		if FFlagViewRecyclerReact084 then
			resolveItemEstimates()
		end

		viewport.refresh()
	end

	local function unsubscribe() -- 2 equivalent calls inferred from this helper
		if v15 ~= nil then
			v15()
			v15 = nil
		end
	end

	local v18 = {}

	local function beginTransaction()
		local v19 = v18

		if FFlagViewRecyclerReact084 then
			v19.settlesScroll = true
		elseif FFlagViewRecyclerReact08 then
			v19.settlesScroll = true
		else
			v19.policyEligible = true
		end

		v19.dataChange = nil

		if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
			v19.before = nil
		end

		v19.replaced = false
		v19.viewportChanged = false
		v19.scrollMoved = false

		if FFlagViewRecyclerReact084 then
			v19.keptDistanceFromEnd = nil
		elseif FFlagViewRecyclerReact08 then
			v19.keptDistanceFromEnd = nil
		end

		v19.contentLengthBefore = viewport.getContentLength()
		v19.scrollCorrection = 0
		v19.scrollPositionChanged = false
		v19.scrollPositionFollowsCorrection = false

		if FFlagViewRecyclerReact084 then
			v19.animatedScrollTarget = nil
		end

		v19.contentLengthChanged = false
		v19.startReached = false
		v19.endReached = false
		v19.entered = frozen
		v19.updated = frozen
		v19.departed = frozen
		v19.dataPrefetchRequests = frozen
		v19.diagnostics = frozen
		return v19
	end

	local function checkEdges(state, flag2: boolean)
		local v19, v20

		if FFlagViewRecyclerReact084 then
			if v10.isEnabled() and isLaidOut() then
				v19, v20 = v10.check(viewport.scrollState(), flag2)
			else
				return
			end
		elseif FFlagViewRecyclerReact08 then
			if v10.isEnabled() and isLaidOut() then
				v19, v20 = v10.check(viewport.scrollState(), flag2)
			else
				return
			end
		else
			v19, v20 = v9.checkEdges(viewport.scrollState(), itemSequence.getItemCount(), flag2)
		end

		state.startReached = state.startReached or v19
		state.endReached = state.endReached or v20
	end

	local policyContext = nil
	local settlePolicy = nil
	local moveSettled, settleScroll

	if FFlagViewRecyclerReact084 then
		moveSettled = function(p: number)
			moveTo(v18, p)
		end

		settleScroll = function(state)
			state.contentLengthChanged = viewport.getContentLength() ~= state.contentLengthBefore
			scrollAnchor.settle(state, moveSettled)
			local dataChange = state.dataChange
			checkEdges(state, dataChange ~= nil and PaginationEdges.hasStructuralChange(dataChange))
		end
	else
		settleScroll = nil
		policyContext = nil
		settlePolicy = nil

		if FFlagViewRecyclerReact08 then
			moveSettled = function(p: number)
				moveTo(v18, p)
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
					applyPolicyTarget(state, v9.contentLengthChanged(viewport.scrollState()))
				end

				local dataChange = state.dataChange

				if dataChange == nil then
					if state.replaced then
						applyPolicyTarget(state, v9.dataReplaced(policyContext()))
						v9.observe(viewport.scrollState())
					end

					if state.viewportChanged then
						applyPolicyTarget(state, v9.viewportChanged(policyContext()))
						v9.observe(viewport.scrollState())
					elseif state.scrollMoved then
						v9.observe(viewport.scrollState())
					end

					if v9.reachesEdges() then
						checkEdges(state, false)
					end
				else
					applyPolicyTarget(state, v9.dataChanged(policyContext(), state.before))
					checkEdges(state, PaginationEdges.hasStructuralChange(dataChange))
				end
			end
		end
	end

	local v19 = {}
	local v20 = {}

	local function settle(state)
		viewport.refresh()
		local v21

		if FFlagViewRecyclerReact084 then
			v21 = state.settlesScroll
		elseif FFlagViewRecyclerReact08 then
			v21 = state.settlesScroll
		else
			v21 = state.policyEligible
		end

		if v21 then
			if FFlagViewRecyclerReact084 then
				settleScroll(state)
			elseif FFlagViewRecyclerReact08 then
				settleScroll(state)
			else
				settlePolicy(state)
			end
		end

		local v22, v23 = viewport.updateRanges()

		if data.diagnostics ~= nil then
			if v22 then
				local visibleRange = viewport.getVisibleRange()
				addDiagnostic(state, { -- inferred equivalent call
					kind = Diagnostics.EventKind.RangeChanged,
					rangeKind = Diagnostics.RangeKind.Visible,
					firstIndex = visibleRange.firstIndex,
					lastIndex = visibleRange.lastIndex
				})
			end

			if v23 then
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

		if v13 then
			local scrollOffset = viewport.getScrollOffset()
			local contentStartOffset = viewport.getContentStartOffset()
			v19.dataSource = itemSequence
			v19.layout = layout
			v19.mountedRange = viewport.getMountedRange()

			if FFlagViewRecyclerReact084 then
				v19.visibleRange = viewport.getVisibleRange()
			end

			v19.scrollOffset = scrollOffset
			v19.contentStartOffset = contentStartOffset
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

			v19.plan = plan

			local v24, v25 = listRows.apply(v19)

			if v24 ~= nil then
				state.entered = v24.entered
				state.updated = v24.updated
				state.departed = v24.departed
			end

			if v25 ~= nil then
				addDiagnostic(state, v25) -- inferred equivalent call
			end
		elseif listRows.isApplied() then
			state.departed = listRows.release()
		end

		v20.itemSequence = itemSequence
		v20.mountedRange = viewport.getMountedRange()
		v20.options = dataPrefetch
		state.dataPrefetchRequests = dataPrefetchController.reconcile(v20)
	end

	local function frozen2(list) -- 4 equivalent calls inferred from this helper
		if table.isfrozen(list) then
			return list
		end

		return (table.freeze(list))
	end

	local function makeRecord(data2)
		local v21 = current
		local v22 = {
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
			animatedScrollTarget = 0,
			contentLengthChanged = 0,
			startReached = 0,
			endReached = 0,
			dataPrefetchRequests = 0,
			diagnostics = 0
		}
		local scrollState = viewport.scrollState
		local v23

		if v21 ~= nil then
			v23 = v21.scrollState
		end

		v22.scrollState = scrollState(v23)
		v22.contentStartOffset = viewport.getContentStartOffset()
		v22.contentLength = viewport.getContentLength()
		v22.requiresItemMeasurement = layout.requiresItemMeasurement()
		v22.scrollCorrection = data2.scrollCorrection
		v22.scrollPositionChanged = data2.scrollPositionChanged
		v22.scrollPositionFollowsCorrection = data2.scrollPositionFollowsCorrection
		v22.scrollAnchor = scrollAnchor.getAnchoredItem()
		local animatedScrollTarget

		if FFlagViewRecyclerReact084 then
			animatedScrollTarget = data2.animatedScrollTarget
		end

		v22.animatedScrollTarget = animatedScrollTarget
		v22.contentLengthChanged = data2.contentLengthChanged
		v22.startReached = data2.startReached
		v22.endReached = data2.endReached
		v22.dataPrefetchRequests = data2.dataPrefetchRequests
		v22.diagnostics = frozen2(data2.diagnostics) -- inferred equivalent call
		return (table.freeze(v22))
	end

	local mutateAndSettle, transact

	if FFlagViewRecyclerReact084 then
		mutateAndSettle = function(callback, p, p2, p3, p4)
			callback(p, p2, p3, p4)

			if v16 ~= nil and resolveMotionTarget() == nil then
				stopMotion()
			end

			settle(p)

			if v16 ~= nil then
				p.animatedScrollTarget = resolveMotionTarget()
			end
		end

		transact = function(callback, p, p2, p3)
			assert(not v14, "Virtualizer: cannot mutate during a transaction")
			assert(not flag, "Virtualizer: cannot dispatch after destruction")
			v14 = true
			local v21 = beginTransaction()
			local success, result = pcall(mutateAndSettle, callback, v21, p, p2, p3)
			v14 = false

			if not success then
				error(result, 0)
			end

			local v22 = current
			local record = makeRecord(v21)
			current = record

			if data.diagnostics ~= nil then
				for _, diagnostic in record.diagnostics do
					data.diagnostics(diagnostic)
				end
			end

			if data.onTransaction ~= nil then
				data.onTransaction(v22, record)
			end

			return record
		end
	else
		mutateAndSettle = function(callback, p, p2, p3)
			callback(p, p2, p3)
			settle(p)
		end

		transact = function(callback, p, p2)
			assert(not v14, "Virtualizer: cannot mutate during a transaction")
			assert(not flag, "Virtualizer: cannot dispatch after destruction")
			v14 = true
			local v21 = beginTransaction()
			local success, result = pcall(mutateAndSettle, callback, v21, p, p2)
			v14 = false

			if not success then
				error(result, 0)
			end

			local v22 = current
			local record = makeRecord(v21)
			current = record

			if data.diagnostics ~= nil then
				for _, diagnostic in record.diagnostics do
					data.diagnostics(diagnostic)
				end
			end

			if data.onTransaction ~= nil then
				data.onTransaction(v22, record)
			end

			return record
		end
	end

	local function applyDataChange(p, dataChange)
		if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
			p.before = viewport.scrollState()
		end

		p.dataChange = dataChange
		listRows.noteDataChange(dataChange)
		local v21 = false
		applyCorrection(
			p,
			scrollAnchor.preserve(
				{ source = Diagnostics.ScrollCorrectionSource.Data, dataSourceChange = dataChange },
				function()
					for _, change in dataChange.changes do
						v21 = layout.applyDataSourceChange(change) or v21
					end

					v21 = FFlagViewRecyclerReact084 and resolveItemEstimates() or v21

					pinnedItemPlanner.applyDataSourceChange(dataChange)
					viewport.refresh()
				end
			)
		)

		if v21 then
			listRows.invalidateLayout()
		end
	end

	local function fn(p)
		transact(applyDataChange, p)
	end

	local function fn2()
		if v15 == nil and v3 and not flag then
			v15 = itemSequence.subscribe(fn)
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

	local function resetData()
		if FFlagViewRecyclerReact084 then
			scrollAnchor.dataSourceReplaced()
		elseif FFlagViewRecyclerReact08 then
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
		local v21, v22 = listRows.validate(p2)

		if #v21 > 0 and data.diagnostics ~= nil then
			addDiagnostic(p, { -- inferred equivalent call
				kind = Diagnostics.EventKind.MeasurementsProcessingStarted,
				submitted = #v21,
				boundaryDropped = v22
			})
		end

		local count = 0
		local v23 = false
		local v24 = nil
		local v25 = {
			source = Diagnostics.ScrollCorrectionSource.Measurement,
			preserveStartAnchor = true,
			startInsetDelta = 0
		}

		local start = pinnedItemPlanner.getContentInsets().start
		applyCorrection(p, scrollAnchor.preserve(v25, function()
			for _, v26 in v21 do
				local index = v26.index

				if index == nil then
					if v26.pinnedPosition == nil then
						v22 += 1
					else
						local v27 = nil
						local v28

						if FFlagViewRecyclerReact084 then
							v28, v27 = pinnedItemPlanner.updatePinnedMeasurement(
								v26.pinnedPosition,
								v26.key,
								v26.pinnedRevision,
								v26.length
							)
						else
							v28 = pinnedItemPlanner.updatePinnedMeasurement(
								v26.pinnedPosition,
								v26.key,
								v26.pinnedRevision,
								v26.length
							)
						end

						if not FFlagViewRecyclerReact084 then
							v27 = v28 == nil
						end

						if v27 then
							if FFlagViewRecyclerReact084 then
								count += 1
							else
								v22 += 1
							end
						elseif FFlagViewRecyclerReact084 then
							v22 += 1
						else
							count += 1
							v24 = v28
						end

						if FFlagViewRecyclerReact084 and v28 ~= nil then
							v24 = v28
						end
					end
				else
					local v27 = layout.updateItemMeasurement({
						itemIndex = index,
						itemKey = v26.key,
						length = v26.length
					})

					if v27.accepted then
						count += 1
					else
						v22 += 1
					end

					v23 = v23 or v27.geometryChanged
				end
			end

			if v24 ~= nil then
				v25.startInsetDelta = v24.start - start
				viewport.setInsets(v24.start, v24.finish)
				v23 = true
			end

			viewport.refresh()
		end))

		if data.diagnostics ~= nil and #v21 > 0 then
			addDiagnostic(p, { -- inferred equivalent call
				kind = Diagnostics.EventKind.MeasurementsProcessed,
				accepted = count,
				dropped = v22
			})
		end

		if v23 then
			listRows.invalidateLayout()
		end
	end

	local setPolicy

	if FFlagViewRecyclerReact084 then
		setPolicy = function(p, data2)
			DataPrefetch.resolve(data2.dataPrefetch)
			local pinnedItems = data2.pinnedItems
			viewport.setOverscan(data2.overscan)
			viewport.setContentAlignment(data2.contentAlignment)
			viewport.setEndThreshold(data2.endThreshold)
			dataPrefetch = data2.dataPrefetch
			scrollAnchor.configure(anchorConfig(data2))
			v10.configure(paginationConfig(data2))
			local contentInsets = pinnedItemPlanner.getContentInsets()

			pinnedItemPlanner.setOptions({
				isItemStickyKey = pinnedItems.isItemStickyHeader,
				pinnedStartItem = plannerItem(pinnedItems.pinnedStartItem),
				pinnedEndItem = plannerItem(pinnedItems.pinnedEndItem)
			})

			isItemStickyHeader = pinnedItems.isItemStickyHeader
			pinnedStartItem = pinnedItems.pinnedStartItem
			pinnedEndItem = pinnedItems.pinnedEndItem
			v2 = isItemStickyHeader ~= nil or pinnedStartItem ~= nil or pinnedEndItem ~= nil
			local contentInsets2 = pinnedItemPlanner.getContentInsets()

			if contentInsets2.start ~= contentInsets.start or contentInsets2.finish ~= contentInsets.finish then
				applyCorrection(p, scrollAnchor.preserve({
					source = Diagnostics.ScrollCorrectionSource.Policy,
					preserveStartAnchor = true,
					startInsetDelta = contentInsets2.start - contentInsets.start
				}, function()
					viewport.setInsets(contentInsets2.start, contentInsets2.finish)
				end))
			end
		end
	else
		setPolicy = function(data2)
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
				pinnedStartItem = keyOnly(pinnedStartItem),
				pinnedEndItem = keyOnly(pinnedEndItem)
			}) then
				local contentInsets = pinnedItemPlanner.getContentInsets()
				viewport.setInsets(contentInsets.start, contentInsets.finish)
			end

			v2 = isItemStickyHeader ~= nil or pinnedStartItem ~= nil or pinnedEndItem ~= nil

			if not FFlagViewRecyclerReact08 then
				v9.configure(policyConfig(data2))

				return
			end

			scrollAnchor.configure(anchorConfig(data2))
			v10.configure(paginationConfig(data2))
		end
	end

	local function setActiveMutation(p, flag2: boolean)
		if FFlagViewRecyclerReact084 then
			p.settlesScroll = false
		elseif FFlagViewRecyclerReact08 then
			p.settlesScroll = false
		else
			p.policyEligible = false
		end

		if flag2 and not v13 then
			listRows.invalidatePayloads()
		end

		v13 = flag2
	end

	local setScrollOffsetMutation = not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08)
		and function(_, p: number)
			if viewport.setScrollOffset(p) then
				scrollAnchor.setViewport(p)
			end
		end
		or nil

	local function observeScrollOffsetMutation(p, p2)
		if FFlagViewRecyclerReact084 and p2.kind == ScrollObservationKind.User then
			stopMotion()
		end

		local v21 = viewport.setScrollOffset(p2.offset)

		if p2.kind == ScrollObservationKind.Programmatic then
			scrollAnchor.observeHost(p2.offset)
		elseif v21 then
			scrollAnchor.setViewport(p2.offset)
		end

		if p2.kind == ScrollObservationKind.User then
			p.scrollMoved = true
		end
	end

	local animate
	local finishProgrammaticScroll, scrollToIndexMutation, scrollToOffsetMutation

	if FFlagViewRecyclerReact084 then
		finishProgrammaticScroll = function(p, p2)
			scrollAnchor.scrolledProgrammatically(p2)
			moveScrollPosition(p) -- inferred equivalent call

			if p2 == nil then
				p.scrollMoved = true
			end
		end

		animate = function(p, p2): boolean
			if p == nil or p.animated ~= true then
				return false
			end

			ScrollMotion.validate(p, "Virtualizer")
			local v21 = v16 == nil and 0 or v16.velocity
			stopMotion()

			if not isLaidOut() then
				return false
			end

			v17 = p2
			local motionTarget = resolveMotionTarget()
			local scrollOffset = viewport.getScrollOffset()

			if motionTarget == nil or ScrollMotion.isAtRest(scrollOffset, motionTarget, v21) then
				v17 = nil
				return false
			end

			v16 = ScrollMotion.start(scrollOffset, motionTarget, viewport.getLength(), v21, ScrollMotion.resolve(p))

			scrollAnchor.beginMotion()
			return true
		end

		scrollToIndexMutation = function(p, value: number, alignment, p2)
			local itemCount = itemSequence.getItemCount()

			if itemCount > 0 then
				local indexHint = math.clamp(value, 1, itemCount)

				local v21 = {
					kind = "index",
					key = itemSequence.getItemKey(indexHint),
					indexHint = indexHint,
					alignment = alignment
				}

				if animate(p2, v21) then
					return
				end
			end

			stopMotion()
			moveTo(p, viewport.offsetForItem(value, alignment))
			scrollAnchor.setItemTarget(value, alignment)
			finishProgrammaticScroll(p, nil)
		end

		scrollToOffsetMutation = function(p, offset: number, p2)
			if animate(p2, { kind = "offset", offset = offset }) then
				return
			end

			stopMotion()
			moveTo(p, offset)
			finishProgrammaticScroll(p, nil)
		end
	else
		finishProgrammaticScroll = FFlagViewRecyclerReact08 and function(p, p2)
			scrollAnchor.scrolledProgrammatically(p2)
			moveScrollPosition(p) -- inferred equivalent call

			if p2 == nil then
				p.scrollMoved = true
			end
		end or nil

		scrollToIndexMutation = function(p, p2: number, p3)
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

		scrollToOffsetMutation = function(p, p2: number)
			if FFlagViewRecyclerReact08 then
				moveTo(p, p2)
				finishProgrammaticScroll(p, nil)
			else
				scrollAnchor.setViewport(viewport.scrollTo(p2))
				moveScrollPosition(p) -- inferred equivalent call
				p.scrollMoved = true
			end
		end
	end

	local function scrollByMutation(p, p2: number)
		if FFlagViewRecyclerReact084 then
			assert(math.abs(p2) < 1e999, "Virtualizer: scroll delta must be finite")
			stopMotion()
			moveTo(p, viewport.getScrollOffset() + p2)
			finishProgrammaticScroll(p, nil)
		elseif FFlagViewRecyclerReact08 then
			assert(math.abs(p2) < 1e999, "Virtualizer: scroll delta must be finite")
			moveTo(p, viewport.getScrollOffset() + p2)
			finishProgrammaticScroll(p, nil)
		else
			scrollAnchor.setViewport(viewport.scrollBy(p2))
			moveScrollPosition(p) -- inferred equivalent call
			p.scrollMoved = true
		end
	end

	local landMotion
	local stepAnimatedScrollMutation
	local scrollToEdgeMutation

	if FFlagViewRecyclerReact084 then
		scrollToEdgeMutation = function(p, edge, p2)
			if animate(p2, { kind = "edge", edge = edge }) then
				return
			end

			stopMotion()
			moveTo(p, edge == ScrollAlignment.Start and 0 or viewport.getContentLength() - viewport.getLength())

			finishProgrammaticScroll(p, edge)
		end

		landMotion = function(p)
			local v21 = v17
			stopMotion()

			if v21.kind == "index" then
				local motionIndex = findMotionIndex(v21)

				if motionIndex ~= nil then
					scrollToIndexMutation(p, motionIndex, v21.alignment, nil)
				end
			elseif v21.kind == "edge" then
				scrollToEdgeMutation(p, v21.edge, nil)
			else
				scrollToOffsetMutation(p, v21.offset, nil)
			end
		end

		stepAnimatedScrollMutation = function(p, p2: number)
			local v21 = v16
			local motionTarget = resolveMotionTarget()

			if motionTarget == nil then
				stopMotion()
				return
			end

			if not isLaidOut() then
				landMotion(p)
				return
			end

			local v22, v23 = ScrollMotion.step(v21, viewport.getScrollOffset(), motionTarget, viewport.getLength(), p2)

			if v23 then
				landMotion(p)
			else
				moveTo(p, v22)
			end
		end
	else
		scrollToEdgeMutation = function(p, p2)
			if FFlagViewRecyclerReact08 then
				moveTo(p, p2 == ScrollAlignment.Start and 0 or viewport.getContentLength() - viewport.getLength())

				finishProgrammaticScroll(p, p2)
			else
				scrollAnchor.setViewport(viewport.scrollTo(AutoScroll.getTargetOffset(
					p2,
					viewport.getContentLength(),
					viewport.getLength()
				)))

				v9.pin(p2)
				moveScrollPosition(p) -- inferred equivalent call
			end
		end
	end

	local function setViewportSizeMutation(p, p2: number, p3: number)
		local length = viewport.getLength()
		local v21 = viewport.getContentLength() - length - viewport.getScrollOffset()

		if viewport.setSize(p2, p3) then
			if layout.setViewportCrossAxisLength(p3) then
				listRows.invalidateLayout()
			end

			local v22

			if FFlagViewRecyclerReact084 then
				v22 = length > 0
			elseif FFlagViewRecyclerReact08 then
				v22 = length > 0
			elseif length > 0 then
				v22 = p2 ~= length
			else
				v22 = false
			end

			if v22 then
				local v23

				if FFlagViewRecyclerReact084 then
					v23 = p2 ~= length
				elseif FFlagViewRecyclerReact08 then
					v23 = p2 ~= length
				else
					v23 = viewport.getContentAlignment() == ScrollAlignment.End
				end

				if v23 then
					local v24

					if FFlagViewRecyclerReact084 then
						v24 = viewport.getContentAlignment() == ScrollAlignment.End
					elseif FFlagViewRecyclerReact08 then
						v24 = viewport.getContentAlignment() == ScrollAlignment.End
					else
						v24 = scrollAnchor.allowsPolicyOffset()
					end

					if v24 then
						if FFlagViewRecyclerReact084 then
							p.keptDistanceFromEnd = math.max(0, v21)
						elseif FFlagViewRecyclerReact08 then
							p.keptDistanceFromEnd = math.max(0, v21)
						else
							viewport.refresh()
							local scrollOffset = viewport.getScrollOffset()
							local scrollTo = viewport.scrollTo(viewport.getContentLength() - p2 - math.max(0, v21))

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

	local virtualizer = {
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
		scrollToIndex = 0,
		scrollToOffset = 0,
		scrollToStart = 0,
		scrollToEnd = 0,
		scrollBy = 0,
		stepAnimatedScroll = 0,
		stopAnimatedScroll = 0,
		restoreScrollAnchorSnapshot = 0,
		setViewportSize = 0,
		setPolicy = 0,
		setDataSource = 0,
		setLayout = 0,
		setDataSourceAndLayout = 0,
		refresh = 0,
		submitMeasurements = 0,
		getCurrent = 0,
		getItemLayout = 0,
		getScrollOffsetForItem = 0,
		captureScrollAnchorSnapshot = 0,
		destroy = 0,
		setScrollOffset = 0
	}
	local scrollToIndex

	if FFlagViewRecyclerReact084 then
		scrollToIndex = function(p, p2, p3)
			return transact(scrollToIndexMutation, p, p2, p3)
		end
	else
		scrollToIndex = function(p, p2)
			return transact(scrollToIndexMutation, p, p2)
		end
	end

	virtualizer.scrollToIndex = scrollToIndex
	local scrollToOffset

	if FFlagViewRecyclerReact084 then
		scrollToOffset = function(p, p2)
			return transact(scrollToOffsetMutation, p, p2)
		end
	else
		scrollToOffset = function(p)
			return transact(scrollToOffsetMutation, p)
		end
	end

	virtualizer.scrollToOffset = scrollToOffset
	local scrollToStart

	if FFlagViewRecyclerReact084 then
		scrollToStart = function(p)
			return transact(scrollToEdgeMutation, ScrollAlignment.Start, p)
		end
	else
		scrollToStart = function()
			local v21 = scrollToEdgeMutation
			local v22

			if FFlagViewRecyclerReact08 then
				v22 = ScrollAlignment
			else
				v22 = AutoScrollTarget
			end

			return transact(v21, v22.Start)
		end
	end

	virtualizer.scrollToStart = scrollToStart
	local scrollToEnd

	if FFlagViewRecyclerReact084 then
		scrollToEnd = function(p)
			return transact(scrollToEdgeMutation, ScrollAlignment.End, p)
		end
	else
		scrollToEnd = function()
			local v21 = scrollToEdgeMutation
			local v22

			if FFlagViewRecyclerReact08 then
				v22 = ScrollAlignment
			else
				v22 = AutoScrollTarget
			end

			return transact(v21, v22.End)
		end
	end

	virtualizer.scrollToEnd = scrollToEnd

	function virtualizer.scrollBy(p)
		return transact(scrollByMutation, p)
	end

	virtualizer.stepAnimatedScroll = FFlagViewRecyclerReact084 and function(p)
		if v16 == nil then
			return current
		end

		return transact(stepAnimatedScrollMutation, p)
	end or nil

	virtualizer.stopAnimatedScroll = FFlagViewRecyclerReact084 and function()
		if v16 == nil then
			return current
		end

		return transact(function()
			stopMotion()
		end)
	end or nil

	function virtualizer.restoreScrollAnchorSnapshot(p)
		return transact(function(p2)
			if FFlagViewRecyclerReact084 then
				stopMotion()
				moveTo(p2, scrollAnchor.snapshotOffset(p))
				scrollAnchor.restore(p, viewport.getScrollOffset())
				finishProgrammaticScroll(p2, nil)
			elseif FFlagViewRecyclerReact08 then
				moveTo(p2, scrollAnchor.snapshotOffset(p))
				scrollAnchor.restore(p, viewport.getScrollOffset())
				finishProgrammaticScroll(p2, nil)
			else
				scrollAnchor.restore(p, viewport.scrollTo(scrollAnchor.snapshotOffset(p)))
				moveScrollPosition(p2) -- inferred equivalent call
				p2.scrollMoved = true
			end
		end)
	end

	function virtualizer.setViewportSize(p, p2)
		return transact(setViewportSizeMutation, p, p2)
	end

	function virtualizer.setPolicy(p)
		if FFlagViewRecyclerReact084 then
			return transact(setPolicy, p)
		end

		return transact(function()
			setPolicy(p)
		end)
	end

	function virtualizer.setDataSource(p)
		return transact(function(p2)
			if FFlagViewRecyclerReact084 then
				stopMotion()
			end

			replaceDataSource(p) -- inferred equivalent call
			resetData()
			p2.replaced = true
		end)
	end

	function virtualizer.setLayout(p)
		return transact(function()
			if FFlagViewRecyclerReact084 then
				stopMotion()
			end

			replaceLayout(p) -- inferred equivalent call
			scrollAnchor.reset()
			resetLayout(readKeys()) -- inferred equivalent call
		end)
	end

	function virtualizer.setDataSourceAndLayout(p, p2)
		return transact(function(p3)
			if FFlagViewRecyclerReact084 then
				stopMotion()
			end

			replaceDataSource(p) -- inferred equivalent call
			replaceLayout(p2) -- inferred equivalent call
			resetData()
			p3.replaced = true
		end)
	end

	function virtualizer.refresh()
		return transact(function()
			listRows.invalidateKeys()
			listRows.invalidatePayloads()
		end)
	end

	function virtualizer.submitMeasurements(p)
		return transact(submitMeasurements, p)
	end

	function virtualizer.getCurrent()
		return current
	end

	function virtualizer.getItemLayout(p)
		return layout.getItemLayout(p)
	end

	function virtualizer.getScrollOffsetForItem(p, p2)
		return viewport.offsetForItem(p, p2)
	end

	function virtualizer.captureScrollAnchorSnapshot()
		local v21 = current
		local visibleRange = v21.visibleRange
		local scrollOffset = v21.scrollState.scrollOffset

		if visibleRange.firstIndex <= visibleRange.lastIndex then
			local firstIndex = visibleRange.firstIndex
			return {
				anchorKey = itemSequence.getItemKey(firstIndex),
				anchorIndex = firstIndex,
				offsetWithinItem = scrollOffset - v21.contentStartOffset - layout.getItemLayout(firstIndex).startOffset,
				fallbackScrollOffset = scrollOffset
			}
		end

		return {
			anchorKey = nil,
			anchorIndex = nil,
			offsetWithinItem = 0,
			fallbackScrollOffset = scrollOffset
		}
	end

	function virtualizer.destroy()
		if flag then
			return
		end

		transact(function(p)
			if FFlagViewRecyclerReact084 then
				p.settlesScroll = false
				stopMotion()
			elseif FFlagViewRecyclerReact08 then
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
	end

	local setScrollOffset

	if not FFlagViewRecyclerReact084 then
		setScrollOffset = not FFlagViewRecyclerReact08 and function(p)
			return transact(setScrollOffsetMutation, p)
		end or nil
	end

	virtualizer.setScrollOffset = setScrollOffset
	return virtualizer
end

return createVirtualizer
