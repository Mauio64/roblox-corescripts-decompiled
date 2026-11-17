local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
local ViewRecycler = require(ViewRecyclerRoblox.Parent.ViewRecycler)

local AttachedViewportOverlay = require(ViewRecyclerRoblox.RobloxAdapter.AttachedViewportOverlay)
local HostPlacement = require(ViewRecyclerRoblox.RobloxAdapter.HostPlacement)
local HostPresentationPhase = require(ViewRecyclerRoblox.RobloxAdapter.HostPresentationPhase)

local ReducedMotion = require(ViewRecyclerRoblox.RobloxAdapter.ReducedMotion)
local ScrollHost = require(ViewRecyclerRoblox.RobloxAdapter.ScrollHost)

local VacantHosts = require(ViewRecyclerRoblox.RobloxAdapter.VacantHosts)
local VirtualizerConfigurationKeys = require(ViewRecyclerRoblox.RobloxAdapter.VirtualizerConfigurationKeys)
local VisibleItemsPresentation = require(ViewRecyclerRoblox.RobloxAdapter.VisibleItemsPresentation)
require(ViewRecyclerRoblox.RobloxAdapter.createRecyclingScope)

local Axis = ViewRecycler.Axis

local reachedThreshold = ViewRecycler.Adapter._Private.ReachedThreshold
local scrollMotion = ViewRecycler.Adapter._Private.ScrollMotion
local shallowTable = ViewRecycler.Adapter._Private.ShallowTable
local frozen

if FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08 then
	frozen = nil
else
	frozen = table.freeze({
		"scrollingFrame",
		"viewportOverlay",
		"axis",
		"dataSource",
		"layout",
		"overscan",
		"dataPrefetch",
		"contentAlignment",
		"isItemStickyHeader",
		"pinnedStartItem",
		"pinnedEndItem",
		"preserveScrollPositionOnChange",
		"initialScrollAlignment",
		"autoScrollOnChange",
		"autoScrollThreshold",
		"onStartReached",
		"onEndReached",
		"startReachedThreshold",
		"endReachedThreshold",
		"onViewportChanged",
		"onScrollOffsetChanged",
		"onContentLengthChanged",
		"onVisibleRangeChanged",
		"onMountedRangeChanged",
		"onVisibleItemsPresented",
		"onDataPrefetchRequested"
	})
end

local frozen2 = table.freeze({
	"axis",
	"onStartReached",
	"onEndReached",
	"onViewportChanged",
	"onScrollOffsetChanged",
	"onContentLengthChanged"
})

local frozen3 = table.freeze(FFlagViewRecyclerReact084 and {
	"overscan",
	"contentAlignment",
	"initialScrollAlignment",
	"autoScrollOnChange",
	"preserveScrollPositionOnChange",
	"isItemStickyHeader"
} or {
	"overscan",
	"dataPrefetch",
	"contentAlignment",
	"endReachedThreshold",
	"initialScrollAlignment",
	"autoScrollOnChange",
	"autoScrollThreshold",
	"startReachedThreshold",
	"preserveScrollPositionOnChange",
	"isItemStickyHeader"
})
local frozen4, frozen5, coreScrollOptions

if FFlagViewRecyclerReact084 then
	frozen4 = table.freeze({ "endReachedThreshold", "autoScrollThreshold", "startReachedThreshold" })

	frozen5 = table.freeze({ "startItems", "endItems" })

	coreScrollOptions = function(data, options)
		if data == nil or data.animated ~= true or ReducedMotion.isEnabled() then
			return nil
		end

		local v = options or {}
		return {
			animated = true,
			jumpDistance = data.jumpDistance or v.jumpDistance,
			frequency = data.frequency or v.frequency,
			cruiseSpeed = data.cruiseSpeed or v.cruiseSpeed,
			approachDistance = data.approachDistance or v.approachDistance,
			landingDistance = data.landingDistance or v.landingDistance
		}
	end
else
	frozen4 = nil
	frozen5 = nil
	coreScrollOptions = nil
end

local function pick(p) -- 2 equivalent calls inferred from this helper
	local result = {}
	local v

	if FFlagViewRecyclerReact084 then
		v = VirtualizerConfigurationKeys
	elseif FFlagViewRecyclerReact08 then
		v = VirtualizerConfigurationKeys
	else
		v = frozen
	end

	for _, v2 in v do
		result[v2] = p[v2]
	end

	return result
end

local function samePinnedItem(options, options2) -- 2 equivalent calls inferred from this helper
	return shallowTable.equal(options or {}, options2 or {})
end

local sameThresholds = FFlagViewRecyclerReact084 and function(p, p2): boolean
	for _, v in frozen4 do
		if not reachedThreshold.equal(p[v], p2[v]) then
			return false
		end
	end

	return true
end or nil

local function samePolicy(data, data2)
	local v

	if FFlagViewRecyclerReact084 then
		v = shallowTable.containsEqual(data, data2, frozen3)
			and sameThresholds(data, data2)
			and shallowTable.optionalContainsEqual(data.dataPrefetch, data2.dataPrefetch, frozen5)
	else
		v = shallowTable.containsEqual(data, data2, frozen3)
	end

	if not v then
		return v
	end

	if
		(data.onStartReached == nil) == (data2.onStartReached == nil)
		and (data.onEndReached == nil) == (data2.onEndReached == nil)
	then
		return samePinnedItem(data.pinnedStartItem, data2.pinnedStartItem) -- inferred equivalent call
			and samePinnedItem(data.pinnedEndItem, data2.pinnedEndItem) -- inferred equivalent call
	end

	return false
end

local function stackedSpacing(p) -- 2 equivalent calls inferred from this helper
	local stackedSpacing2 = p.layout.stackedSpacing

	if stackedSpacing2 == nil then
		return nil
	end

	return (stackedSpacing2())
end

local function assertPlaceable(layout) -- 2 equivalent calls inferred from this helper
	assert(
		not layout.requiresItemMeasurement() or layout.stackedSpacing ~= nil,
		"createVirtualizer: a Layout that requires Item measurement must be a Stacked layout"
	)
end

local needsOwnedOverlay

if FFlagViewRecyclerReact084 then
	needsOwnedOverlay = FFlagViewRecyclerReact084 and function(data): boolean
		return data.viewportOverlay == nil
			and data.scrollingFrame ~= nil
			and (data.isItemStickyHeader ~= nil or data.pinnedStartItem ~= nil or data.pinnedEndItem ~= nil)
	end or nil
else
	needsOwnedOverlay = FFlagViewRecyclerReact08 and function(data): boolean
		return data.viewportOverlay == nil
			and data.scrollingFrame ~= nil
			and (data.isItemStickyHeader ~= nil or data.pinnedStartItem ~= nil or data.pinnedEndItem ~= nil)
	end or nil
end

local function corePolicy(data)
	return {
		overscan = data.overscan,
		dataPrefetch = data.dataPrefetch,
		contentAlignment = data.contentAlignment,
		endThreshold = data.endReachedThreshold,
		initialScrollAlignment = data.initialScrollAlignment,
		autoScrollOnChange = data.autoScrollOnChange,
		autoScrollThreshold = data.autoScrollThreshold,
		startReachedThreshold = data.startReachedThreshold,
		startReachedEnabled = data.onStartReached ~= nil,
		endReachedEnabled = data.onEndReached ~= nil,
		pinnedItems = {
			isItemStickyHeader = data.isItemStickyHeader,
			pinnedStartItem = data.pinnedStartItem,
			pinnedEndItem = data.pinnedEndItem
		},
		preserveScrollPositionOnChange = data.preserveScrollPositionOnChange ~= false
	}
end

local function createVirtualizer(data)
	assert(data.axis == Axis.X or data.axis == Axis.Y, "createVirtualizer: invalid axis")
	assertPlaceable(data.layout) -- inferred equivalent call
	local vacantHosts

	if FFlagViewRecyclerReact084 then
		scrollMotion.validate(data.animatedScroll, "createVirtualizer: animatedScroll")
		vacantHosts = VacantHosts.forScope(data.recyclingScope)
	end

	local configuration = pick(data) -- inferred equivalent call
	local flag = false
	local v

	if FFlagViewRecyclerReact084 then
		v = data.active ~= false
	elseif FFlagViewRecyclerReact08 then
		v = data.active ~= false
	else
		v = nil
	end

	local v2 = false
	local flag2 = false
	local v3 = false
	local v4 = false
	local v5 = nil
	local v6 = nil

	local v7 = VisibleItemsPresentation.new(function()
		if flag then
			return nil
		end

		return configuration.onVisibleItemsPresented
	end)
	local v8, syncOwnedOverlay, viewportContainer

	if FFlagViewRecyclerReact084 then
		v8 = nil

		syncOwnedOverlay = function(p)
			local v9 = v8

			if not needsOwnedOverlay(p) then
				v8 = nil
				return v9
			end

			local scrollingFrame = p.scrollingFrame

			if v9 ~= nil and v9.scrollingFrame == scrollingFrame and v9.axis == p.axis then
				return nil
			end

			v8 = {
				scrollingFrame = scrollingFrame,
				axis = p.axis,
				handle = AttachedViewportOverlay.new(scrollingFrame, p.axis)
			}

			return v9
		end

		viewportContainer = function(p)
			local viewportOverlay = p.viewportOverlay

			if viewportOverlay ~= nil then
				return viewportOverlay
			end

			local v9 = v8
			return if v9 ~= nil then v9.handle.overlay else nil
		end

		syncOwnedOverlay(configuration)
	elseif FFlagViewRecyclerReact08 then
		v8 = nil

		syncOwnedOverlay = function(p)
			local v9 = v8

			if not needsOwnedOverlay(p) then
				v8 = nil
				return v9
			end

			local scrollingFrame = p.scrollingFrame

			if v9 ~= nil and v9.scrollingFrame == scrollingFrame and v9.axis == p.axis then
				return nil
			end

			v8 = {
				scrollingFrame = scrollingFrame,
				axis = p.axis,
				handle = AttachedViewportOverlay.new(scrollingFrame, p.axis)
			}

			return v9
		end

		viewportContainer = function(p)
			local viewportOverlay = p.viewportOverlay

			if viewportOverlay ~= nil then
				return viewportOverlay
			end

			local v9 = v8
			return if v9 ~= nil then v9.handle.overlay else nil
		end

		syncOwnedOverlay(configuration)
	else
		viewportContainer = nil
		syncOwnedOverlay = nil
		v8 = nil
	end

	local new = HostPlacement.new

	if not FFlagViewRecyclerReact084 then
		vacantHosts = nil
	end

	local v9 = {
		vacantHosts = vacantHosts,
		container = configuration.scrollingFrame,
		viewportContainer = 0,
		axis = 0,
		selfSizing = 0,
		stackedSpacing = 0,
		onItemMeasurements = 0,
		onItemViewPresentationChanged = 0,
		getCanvasOriginOffset = 0
	}
	local viewportContainer2

	if FFlagViewRecyclerReact084 then
		viewportContainer2 = viewportContainer(configuration)
	elseif FFlagViewRecyclerReact08 then
		viewportContainer2 = viewportContainer(configuration)
	else
		viewportContainer2 = configuration.viewportOverlay
	end

	v9.viewportContainer = viewportContainer2

	v9.axis = configuration.axis
	v9.selfSizing = configuration.layout.requiresItemMeasurement()
	v9.stackedSpacing = stackedSpacing(configuration) -- inferred equivalent call

	function v9.onItemMeasurements(p)
		v5.submitMeasurements(p)
	end
	function v9.onItemViewPresentationChanged(p, p2)
		local onItemViewPresentationChanged = data.onItemViewPresentationChanged

		if onItemViewPresentationChanged ~= nil then
			onItemViewPresentationChanged(p, p2)
		end

		v7.presentationChanged(p, p2)
	end
	function v9.getCanvasOriginOffset()
		if v6 == nil then
			return 0
		end

		return (v6.getCanvasOriginOffset())
	end

	local v10 = new(v9)

	local frozen6 = table.freeze({ apply = v10.apply })

	local presentItemView = data.presentItemView or function(p, state, p2, p3)
		local transition = data.transition

		if state == nil then
			p3.apply(p, nil)

			if p2 and transition ~= nil then
				transition(p, nil)
			end
		else
			local guiObject

			if data.getInstance == nil then
				guiObject = p
			else
				guiObject = data.getInstance(p)
			end

			local v11 = typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject")
			assert(v11, "createVirtualizer: ItemView host must be a GuiObject")

			if p2 then
				p3.apply(p, {
					host = guiObject,
					phase = HostPresentationPhase.Hidden,
					state = state
				})

				if transition ~= nil then
					transition(p, state.assignment)
				end
			end

			p3.apply(p, { host = guiObject, phase = HostPresentationPhase.Presented, state = state })
		end
	end

	local object = setmetatable({}, { __mode = "k" })

	local function present(itemView, state) -- 2 equivalent calls inferred from this helper
		local assignment

		if state ~= nil then
			assignment = state.assignment
		end

		local v11 = object[itemView] ~= assignment

		if v11 then
			object[itemView] = assignment
		end

		presentItemView(itemView, state, v11, frozen6)
	end

	local v11 = nil

	local function presentChanges()
		local v12 = v11
		v11 = nil
		v7.present(v12, configuration.dataSource.getItemCount(), function()
			v10.setMountedWindow(v12, function()
				for _, v13 in v12.departed do
					local v14 = object[v13] ~= nil

					if v14 then
						object[v13] = nil
					end

					presentItemView(v13, nil, v14, frozen6)
				end

				for _, v13 in v12.entered do
					present(v13.itemView, v13.state) -- inferred equivalent call
				end

				for _, v13 in v12.updated do
					present(v13.itemView, v13.state) -- inferred equivalent call
				end
			end)
		end)
	end

	local function applyRecord(p, data2)
		v11 = data2
		v6.applyRecord(data2, presentChanges)

		if not v2 then
			return
		end

		if p.visibleRange ~= data2.visibleRange then
			if flag2 then
				v3 = true
			end

			if configuration.onVisibleRangeChanged ~= nil then
				configuration.onVisibleRangeChanged(data2.visibleRange)
			end
		end

		if p.mountedRange ~= data2.mountedRange then
			if flag2 then
				v4 = true
			end

			if configuration.onMountedRangeChanged ~= nil then
				configuration.onMountedRangeChanged(data2.mountedRange)
			end
		end

		if configuration.onDataPrefetchRequested ~= nil then
			for _, dataPrefetchRequest in data2.dataPrefetchRequests do
				configuration.onDataPrefetchRequested(dataPrefetchRequest)
			end
		end
	end

	local v12 = corePolicy(configuration)
	local createVirtualizer2 = ViewRecycler.Adapter.createVirtualizer
	local v13 = {
		dataSource = configuration.dataSource,
		layout = configuration.layout,
		recyclingScope = data.recyclingScope,
		getItemViewType = data.getItemViewType,
		isReadyOnAssignment = 0,
		overscan = 0,
		dataPrefetch = 0,
		contentAlignment = 0,
		endThreshold = 0,
		initialScrollAlignment = 0,
		autoScrollOnChange = 0,
		autoScrollThreshold = 0,
		startReachedThreshold = 0,
		startReachedEnabled = 0,
		endReachedEnabled = 0,
		isItemStickyHeader = 0,
		pinnedStartItem = 0,
		pinnedEndItem = 0,
		preserveScrollPositionOnChange = 0,
		diagnostics = 0,
		onTransaction = 0
	}
	local isReadyOnAssignment

	if FFlagViewRecyclerReact084 then
		isReadyOnAssignment = data.isReadyOnAssignment
	end

	v13.isReadyOnAssignment = isReadyOnAssignment
	v13.overscan = v12.overscan
	v13.dataPrefetch = v12.dataPrefetch
	v13.contentAlignment = v12.contentAlignment
	v13.endThreshold = v12.endThreshold
	v13.initialScrollAlignment = v12.initialScrollAlignment
	v13.autoScrollOnChange = v12.autoScrollOnChange
	v13.autoScrollThreshold = v12.autoScrollThreshold
	v13.startReachedThreshold = v12.startReachedThreshold
	v13.startReachedEnabled = v12.startReachedEnabled
	v13.endReachedEnabled = v12.endReachedEnabled
	v13.isItemStickyHeader = v12.pinnedItems.isItemStickyHeader
	v13.pinnedStartItem = v12.pinnedItems.pinnedStartItem
	v13.pinnedEndItem = v12.pinnedItems.pinnedEndItem
	v13.preserveScrollPositionOnChange = v12.preserveScrollPositionOnChange
	v13.diagnostics = data.diagnostics
	v13.onTransaction = applyRecord
	v5 = createVirtualizer2(v13)

	local new2 = ScrollHost.new
	local v14 = {
		observeScrollOffset = v5.observeScrollOffset,
		setViewportSize = v5.setViewportSize,
		getCurrent = v5.getCurrent,
		stepAnimatedScroll = 0,
		stopAnimatedScroll = 0,
		getInstance = 0,
		getConfiguration = 0,
		onCanvasOriginMoved = 0
	}
	local stepAnimatedScroll

	if FFlagViewRecyclerReact084 then
		stepAnimatedScroll = v5.stepAnimatedScroll
	end

	v14.stepAnimatedScroll = stepAnimatedScroll
	local stopAnimatedScroll

	if FFlagViewRecyclerReact084 then
		stopAnimatedScroll = v5.stopAnimatedScroll
	end

	v14.stopAnimatedScroll = stopAnimatedScroll
	function v14.getInstance()
		return if not flag then configuration.scrollingFrame else nil
	end

	function v14.getConfiguration()
		return configuration
	end

	v14.onCanvasOriginMoved = v10.reposition
	v6 = new2(v14)

	local function update(clone)
		if flag then
			return
		end

		local v15 = configuration
		local result = pick(clone) -- inferred equivalent call
		assert(result.axis == Axis.X or result.axis == Axis.Y, "createVirtualizer: invalid axis")
		assertPlaceable(result.layout) -- inferred equivalent call

		if FFlagViewRecyclerReact084 then
			scrollMotion.validate(result.animatedScroll, "createVirtualizer: animatedScroll")
		end

		local v16 = result.dataSource ~= v15.dataSource
		local v17 = result.layout ~= v15.layout
		local v18 = result.scrollingFrame ~= v15.scrollingFrame
		local v19, v20

		if FFlagViewRecyclerReact084 then
			local v21 = viewportContainer(v15)
			v19 = syncOwnedOverlay(result)
			v20 = viewportContainer(result) ~= v21
		elseif FFlagViewRecyclerReact08 then
			local v21 = viewportContainer(v15)
			v19 = syncOwnedOverlay(result)
			v20 = not (viewportContainer(result) == v21)
		end

		local v21

		if v18 then
			v21 = v18
		else
			local v22

			if FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08 then
				v22 = v20
			else
				v22 = result.viewportOverlay ~= v15.viewportOverlay
			end

			v21 = v22
				or result.axis ~= v15.axis
				or v17
				or (result.isItemStickyHeader == nil) ~= (v15.isItemStickyHeader == nil)
		end

		local v22

		if FFlagViewRecyclerReact084 then
			v22 = v

			if v22 then
				if v18 or v20 then
					v22 = v10.hasDestroyedHost()
				else
					v22 = v20
				end
			end
		end

		local v23

		if FFlagViewRecyclerReact084 then
			v23 = v22
		else
			v23 = FFlagViewRecyclerReact08
		end

		if v23 then
			if FFlagViewRecyclerReact084 then
				v5.setActive(false)
			else
				v22 = v

				if v22 then
					if v18 or v20 then
						v22 = v10.hasDestroyedHost()
					else
						v22 = v20
					end
				end

				if v22 then
					v5.setActive(false)
				end
			end
		end

		configuration = result

		if v16 then
			v7.rearm()
		end

		if v16 or v17 then
			v10.cancelPendingMeasurements()

			if v16 and v17 then
				v5.setDataSourceAndLayout(result.dataSource, result.layout)
			elseif v16 then
				v5.setDataSource(result.dataSource)
			else
				v5.setLayout(result.layout)
			end
		end

		if v21 then
			local setConfiguration = v10.setConfiguration
			local v24 = {
				container = result.scrollingFrame,
				viewportContainer = 0,
				axis = 0,
				selfSizing = 0,
				stackedSpacing = 0
			}
			local viewportContainer3

			if FFlagViewRecyclerReact084 then
				viewportContainer3 = viewportContainer(result)
			elseif FFlagViewRecyclerReact08 then
				viewportContainer3 = viewportContainer(result)
			else
				viewportContainer3 = result.viewportOverlay
			end

			v24.viewportContainer = viewportContainer3

			v24.axis = result.axis
			v24.selfSizing = result.layout.requiresItemMeasurement()
			v24.stackedSpacing = stackedSpacing(result) -- inferred equivalent call
			setConfiguration(v24)
		end

		local v24

		if FFlagViewRecyclerReact084 then
			v24 = v19 ~= nil
		else
			v24 = FFlagViewRecyclerReact08
		end

		if v24 then
			if FFlagViewRecyclerReact084 then
				v19.handle.destroy()
			elseif v19 ~= nil then
				v19.handle.destroy()
			end
		end

		if not samePolicy(v15, result) then
			v5.setPolicy(corePolicy(result))
		end

		if not shallowTable.containsEqual(v15, result, frozen2) then
			v6.configurationChanged()
		end

		if v18 then
			v6.scrollingFrameChanged()
		end

		local v25

		if FFlagViewRecyclerReact084 then
			v25 = v22
		else
			v25 = FFlagViewRecyclerReact08
		end

		if v25 then
			if FFlagViewRecyclerReact084 then
				v5.setActive(true)
			elseif v22 then
				v5.setActive(true)
			end
		end
	end

	local function updateWith(fn) -- 8 equivalent calls inferred from this helper
		local clone = table.clone(configuration)
		fn(clone)
		update(clone)
	end

	local v15 = nil

	local function destroy()
		if flag then
			return
		end

		flag = true

		if v15 ~= nil then
			v15()
			v15 = nil
		end

		v5.destroy()
		v10.destroy()
		local v16

		if FFlagViewRecyclerReact084 then
			v16 = v8
			v8 = nil
		end

		local v17

		if FFlagViewRecyclerReact084 then
			v17 = v16 ~= nil
		else
			v17 = FFlagViewRecyclerReact08
		end

		if v17 then
			if FFlagViewRecyclerReact084 then
				v16.handle.destroy()
				return
			end

			local v18 = v8
			v8 = nil

			if v18 ~= nil then
				v18.handle.destroy()
			end
		end
	end

	if data.active == false then
		v5.setActive(false)
	end

	v15 = v6.connect()
	v2 = true
	flag2 = true
	local success, result = pcall(v5.activate)
	flag2 = false

	if not success then
		destroy()
		error(result, 0)
	end

	local current = v5.getCurrent()

	if not v3 and configuration.onVisibleRangeChanged ~= nil then
		configuration.onVisibleRangeChanged(current.visibleRange)
	end

	if not v4 and configuration.onMountedRangeChanged ~= nil then
		configuration.onMountedRangeChanged(current.mountedRange)
	end

	local virtualizer = {
		update = update,
		setActive = 0,
		scrollToOffset = 0,
		scrollToStart = 0,
		scrollToEnd = 0,
		scrollBy = 0,
		scrollToIndex = 0,
		setDataSource = 0,
		setLayout = 0,
		setDataSourceAndLayout = 0,
		setOverscan = 0,
		setDataPrefetch = 0,
		setContentAlignment = 0,
		setPinnedItems = 0,
		setPreserveScrollPositionOnChange = 0,
		refreshItemViews = 0,
		isReady = 0,
		getVisibleRange = 0,
		getMountedRange = 0,
		getScrollState = 0,
		captureScrollAnchorSnapshot = 0,
		restoreScrollAnchorSnapshot = 0,
		destroy = 0,
		setScrollOffset = 0
	}
	local fn

	if FFlagViewRecyclerReact084 then
		fn = function(p)
			if not flag then
				v = p
				v5.setActive(p)
			end
		end
	elseif FFlagViewRecyclerReact08 then
		fn = function(p)
			if not flag then
				v = p
				v5.setActive(p)
			end
		end
	else
		fn = function(p)
			if not flag then
				v5.setActive(p)
			end
		end
	end

	virtualizer.setActive = fn
	local scrollToOffset2

	if FFlagViewRecyclerReact084 then
		scrollToOffset2 = function(p, p2)
			local scrollToOffset = v5.scrollToOffset(p, coreScrollOptions(p2, configuration.animatedScroll))

			return scrollToOffset.animatedScrollTarget or scrollToOffset.scrollState.scrollOffset
		end
	else
		scrollToOffset2 = function(p)
			return v5.scrollToOffset(p).scrollState.scrollOffset
		end
	end

	virtualizer.scrollToOffset = scrollToOffset2
	local scrollToStart

	if FFlagViewRecyclerReact084 then
		scrollToStart = function(p)
			v5.scrollToStart(coreScrollOptions(p, configuration.animatedScroll))
		end
	else
		scrollToStart = function()
			v5.scrollToStart()
		end
	end

	virtualizer.scrollToStart = scrollToStart
	local scrollToEnd

	if FFlagViewRecyclerReact084 then
		scrollToEnd = function(p)
			v5.scrollToEnd(coreScrollOptions(p, configuration.animatedScroll))
		end
	else
		scrollToEnd = function()
			v5.scrollToEnd()
		end
	end

	virtualizer.scrollToEnd = scrollToEnd

	function virtualizer.scrollBy(p)
		return v5.scrollBy(p).scrollState.scrollOffset
	end

	function virtualizer.scrollToIndex(p, p2)
		if v6.isReady() then
			if FFlagViewRecyclerReact084 then
				v5.scrollToIndex(p, p2 and p2.alignment, coreScrollOptions(p2, configuration.animatedScroll))
			else
				v5.scrollToIndex(p, p2 and p2.alignment)
			end
		end
	end
	function virtualizer.setDataSource(dataSource)
		local function fn2(p)
			p.dataSource = dataSource
		end

		updateWith(fn2) -- inferred equivalent call
	end
	function virtualizer.setLayout(layout)
		local function fn2(p)
			p.layout = layout
		end

		updateWith(fn2) -- inferred equivalent call
	end
	function virtualizer.setDataSourceAndLayout(dataSource, layout)
		local function fn2(p)
			p.dataSource = dataSource
			p.layout = layout
		end

		updateWith(fn2) -- inferred equivalent call
	end
	function virtualizer.setOverscan(overscan)
		local function fn2(p)
			p.overscan = overscan
		end

		updateWith(fn2) -- inferred equivalent call
	end
	function virtualizer.setDataPrefetch(dataPrefetch)
		local function fn2(p)
			p.dataPrefetch = dataPrefetch
		end

		updateWith(fn2) -- inferred equivalent call
	end
	function virtualizer.setContentAlignment(contentAlignment)
		local function fn2(p)
			p.contentAlignment = contentAlignment
		end

		updateWith(fn2) -- inferred equivalent call
	end
	function virtualizer.setPinnedItems(data2)
		local function fn2(p)
			p.isItemStickyHeader = data2.isItemStickyHeader
			p.pinnedStartItem = data2.pinnedStartItem
			p.pinnedEndItem = data2.pinnedEndItem
		end

		updateWith(fn2) -- inferred equivalent call
	end
	function virtualizer.setPreserveScrollPositionOnChange(preserveScrollPositionOnChange)
		local function fn2(p)
			p.preserveScrollPositionOnChange = preserveScrollPositionOnChange
		end

		updateWith(fn2) -- inferred equivalent call
	end
	function virtualizer.refreshItemViews()
		v5.refresh()
	end
	virtualizer.isReady = v6.isReady
	function virtualizer.getVisibleRange()
		return v5.getCurrent().visibleRange
	end

	function virtualizer.getMountedRange()
		return v5.getCurrent().mountedRange
	end

	function virtualizer.getScrollState()
		return v5.getCurrent().scrollState
	end

	function virtualizer.captureScrollAnchorSnapshot()
		return v5.captureScrollAnchorSnapshot()
	end

	function virtualizer.restoreScrollAnchorSnapshot(p)
		return v5.restoreScrollAnchorSnapshot(p).scrollState.scrollOffset
	end

	virtualizer.destroy = destroy
	local setScrollOffset

	if not FFlagViewRecyclerReact084 then
		setScrollOffset = not FFlagViewRecyclerReact08 and function(p)
			v5.setScrollOffset(p)
		end or nil
	end

	virtualizer.setScrollOffset = setScrollOffset
	return virtualizer
end

return createVirtualizer
