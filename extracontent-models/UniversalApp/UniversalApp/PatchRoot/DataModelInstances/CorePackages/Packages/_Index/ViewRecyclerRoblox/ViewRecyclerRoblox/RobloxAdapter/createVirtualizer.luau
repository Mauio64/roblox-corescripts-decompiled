local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
local ViewRecycler = require(ViewRecyclerRoblox.Parent.ViewRecycler)

local AttachedViewportOverlay = require(ViewRecyclerRoblox.RobloxAdapter.AttachedViewportOverlay)
local HostPlacement = require(ViewRecyclerRoblox.RobloxAdapter.HostPlacement)
local HostPresentationPhase = require(ViewRecyclerRoblox.RobloxAdapter.HostPresentationPhase)
local ScrollHost = require(ViewRecyclerRoblox.RobloxAdapter.ScrollHost)

local VirtualizerConfigurationKeys = require(ViewRecyclerRoblox.RobloxAdapter.VirtualizerConfigurationKeys)
local VisibleItemsPresentation = require(ViewRecyclerRoblox.RobloxAdapter.VisibleItemsPresentation)
require(ViewRecyclerRoblox.RobloxAdapter.createRecyclingScope)

local Axis = ViewRecycler.Axis
local Layout = ViewRecycler.Layout
local shallowTable = ViewRecycler.Adapter._Private.ShallowTable
local frozen

if FFlagViewRecyclerReact08 then
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

local frozen3 = table.freeze({
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

local function pick(p) -- 2 equivalent calls inferred from this helper
	local result = {}
	local v

	if FFlagViewRecyclerReact08 then
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

local function samePolicy(data, data2)
	local v = shallowTable.containsEqual(data, data2, frozen3)

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

local needsOwnedOverlay = FFlagViewRecyclerReact08 and function(data): boolean
	return data.viewportOverlay == nil
		and data.scrollingFrame ~= nil
		and (data.isItemStickyHeader ~= nil or data.pinnedStartItem ~= nil or data.pinnedEndItem ~= nil)
end or nil

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
	local configuration = pick(data) -- inferred equivalent call
	local flag = false
	local v

	if FFlagViewRecyclerReact08 then
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

	if FFlagViewRecyclerReact08 then
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
	local v9 = {
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

	if FFlagViewRecyclerReact08 then
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

	local frozen4 = table.freeze({ apply = v10.apply })

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

		presentItemView(itemView, state, v11, frozen4)
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

					presentItemView(v13, nil, v14, frozen4)
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
	v5 = ViewRecycler.Adapter.createVirtualizer({
		dataSource = configuration.dataSource,
		layout = configuration.layout,
		recyclingScope = data.recyclingScope,
		getItemViewType = data.getItemViewType,
		overscan = v12.overscan,
		dataPrefetch = v12.dataPrefetch,
		contentAlignment = v12.contentAlignment,
		endThreshold = v12.endThreshold,
		initialScrollAlignment = v12.initialScrollAlignment,
		autoScrollOnChange = v12.autoScrollOnChange,
		autoScrollThreshold = v12.autoScrollThreshold,
		startReachedThreshold = v12.startReachedThreshold,
		startReachedEnabled = v12.startReachedEnabled,
		endReachedEnabled = v12.endReachedEnabled,
		isItemStickyHeader = v12.pinnedItems.isItemStickyHeader,
		pinnedStartItem = v12.pinnedItems.pinnedStartItem,
		pinnedEndItem = v12.pinnedItems.pinnedEndItem,
		preserveScrollPositionOnChange = v12.preserveScrollPositionOnChange,
		diagnostics = data.diagnostics,
		onTransaction = applyRecord
	})

	v6 = ScrollHost.new({
		observeScrollOffset = v5.observeScrollOffset,
		setViewportSize = v5.setViewportSize,
		getCurrent = v5.getCurrent,
		getInstance = function()
			if flag then
				return nil
			end

			return configuration.scrollingFrame
		end,
		getConfiguration = function()
			return configuration
		end,
		onCanvasOriginMoved = v10.reposition
	})

	local function update(clone)
		if flag then
			return
		end

		local v13 = configuration
		local result = pick(clone) -- inferred equivalent call
		assert(result.axis == Axis.X or result.axis == Axis.Y, "createVirtualizer: invalid axis")
		assertPlaceable(result.layout) -- inferred equivalent call
		local v14 = result.dataSource ~= v13.dataSource
		local v15 = result.layout ~= v13.layout
		local v16 = result.scrollingFrame ~= v13.scrollingFrame
		local v17, v18

		if FFlagViewRecyclerReact08 then
			local v19 = viewportContainer(v13)
			v17 = syncOwnedOverlay(result)
			v18 = not (viewportContainer(result) == v19)
		end

		local v19

		if v16 then
			v19 = v16
		else
			local v20

			if FFlagViewRecyclerReact08 then
				v20 = v18
			else
				v20 = result.viewportOverlay ~= v13.viewportOverlay
			end

			v19 = v20
				or result.axis ~= v13.axis
				or v15
				or (result.isItemStickyHeader == nil) ~= (v13.isItemStickyHeader == nil)
		end

		local v20

		if FFlagViewRecyclerReact08 then
			v20 = v

			if v20 then
				if v16 or v18 then
					v20 = v10.hasDestroyedHost()
				else
					v20 = v18
				end
			end

			if v20 then
				v5.setActive(false)
			end
		end

		configuration = result

		if v14 then
			v7.rearm()
		end

		if v14 or v15 then
			v10.cancelPendingMeasurements()

			if v14 and v15 then
				v5.setDataSourceAndLayout(result.dataSource, result.layout)
			elseif v14 then
				v5.setDataSource(result.dataSource)
			else
				v5.setLayout(result.layout)
			end
		end

		if v19 then
			local setConfiguration = v10.setConfiguration
			local v21 = {
				container = result.scrollingFrame,
				viewportContainer = 0,
				axis = 0,
				selfSizing = 0,
				stackedSpacing = 0
			}
			local viewportContainer3

			if FFlagViewRecyclerReact08 then
				viewportContainer3 = viewportContainer(result)
			else
				viewportContainer3 = result.viewportOverlay
			end

			v21.viewportContainer = viewportContainer3

			v21.axis = result.axis
			v21.selfSizing = result.layout.requiresItemMeasurement()
			v21.stackedSpacing = stackedSpacing(result) -- inferred equivalent call
			setConfiguration(v21)
		end

		if FFlagViewRecyclerReact08 and v17 ~= nil then
			v17.handle.destroy()
		end

		if not samePolicy(v13, result) then
			v5.setPolicy(corePolicy(result))
		end

		if not shallowTable.containsEqual(v13, result, frozen2) then
			v6.configurationChanged()
		end

		if v16 then
			v6.scrollingFrameChanged()
		end

		if FFlagViewRecyclerReact08 and v20 then
			v5.setActive(true)
		end
	end

	local function updateWith(fn) -- 8 equivalent calls inferred from this helper
		local clone = table.clone(configuration)
		fn(clone)
		update(clone)
	end

	local v13 = nil

	local function destroy() -- 1 equivalent call inferred from this helper
		if flag then
			return
		end

		flag = true

		if v13 ~= nil then
			v13()
			v13 = nil
		end

		v5.destroy()
		v10.destroy()

		if FFlagViewRecyclerReact08 then
			local v14 = v8
			v8 = nil

			if v14 ~= nil then
				v14.handle.destroy()
			end
		end
	end

	if data.active == false then
		v5.setActive(false)
	end

	v13 = v6.connect()
	v2 = true
	flag2 = true
	local success, result = pcall(v5.activate)
	flag2 = false

	if not success then
		destroy() -- inferred equivalent call
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
	local setActive

	if FFlagViewRecyclerReact08 then
		setActive = function(p)
			if not flag then
				v = p
				v5.setActive(p)
			end
		end
	else
		setActive = function(p)
			if not flag then
				v5.setActive(p)
			end
		end
	end

	virtualizer.setActive = setActive

	function virtualizer.scrollToOffset(p)
		return v5.scrollToOffset(p).scrollState.scrollOffset
	end

	function virtualizer.scrollToStart()
		v5.scrollToStart()
	end
	function virtualizer.scrollToEnd()
		v5.scrollToEnd()
	end
	function virtualizer.scrollBy(p)
		return v5.scrollBy(p).scrollState.scrollOffset
	end

	function virtualizer.scrollToIndex(p, p2)
		if v6.isReady() then
			v5.scrollToIndex(p, p2 and p2.alignment)
		end
	end
	function virtualizer.setDataSource(dataSource)
		local function fn(p)
			p.dataSource = dataSource
		end

		updateWith(fn) -- inferred equivalent call
	end
	function virtualizer.setLayout(layout)
		local function fn(p)
			p.layout = layout
		end

		updateWith(fn) -- inferred equivalent call
	end
	function virtualizer.setDataSourceAndLayout(dataSource, layout)
		local function fn(p)
			p.dataSource = dataSource
			p.layout = layout
		end

		updateWith(fn) -- inferred equivalent call
	end
	function virtualizer.setOverscan(overscan)
		local function fn(p)
			p.overscan = overscan
		end

		updateWith(fn) -- inferred equivalent call
	end
	function virtualizer.setDataPrefetch(dataPrefetch)
		local function fn(p)
			p.dataPrefetch = dataPrefetch
		end

		updateWith(fn) -- inferred equivalent call
	end
	function virtualizer.setContentAlignment(contentAlignment)
		local function fn(p)
			p.contentAlignment = contentAlignment
		end

		updateWith(fn) -- inferred equivalent call
	end
	function virtualizer.setPinnedItems(data2)
		local function fn(p)
			p.isItemStickyHeader = data2.isItemStickyHeader
			p.pinnedStartItem = data2.pinnedStartItem
			p.pinnedEndItem = data2.pinnedEndItem
		end

		updateWith(fn) -- inferred equivalent call
	end
	function virtualizer.setPreserveScrollPositionOnChange(preserveScrollPositionOnChange)
		local function fn(p)
			p.preserveScrollPositionOnChange = preserveScrollPositionOnChange
		end

		updateWith(fn) -- inferred equivalent call
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

	virtualizer.setScrollOffset = not FFlagViewRecyclerReact08 and function(p)
		v5.setScrollOffset(p)
	end or nil
	return virtualizer
end

return createVirtualizer
