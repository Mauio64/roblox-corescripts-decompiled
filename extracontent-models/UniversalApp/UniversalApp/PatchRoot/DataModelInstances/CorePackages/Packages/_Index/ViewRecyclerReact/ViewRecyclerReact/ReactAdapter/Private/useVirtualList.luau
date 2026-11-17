local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local ViewRecyclerRoblox = require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)

local Destination = require(script.Parent.Destination)

local PlacementKind = require(script.Parent.PlacementKind)
local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewRegistry = require(script.Parent.RecyclableViewRegistry)

local RecyclingScopeContext = require(script.Parent.RecyclingScopeContext)
local RecyclingViewportContext = require(script.Parent.RecyclingViewportContext)
local Signals = require(ViewRecyclerReact.Parent.Signals)
require(script.Parent.VirtualListShell)

local useCompositionPlacement = require(script.Parent.useCompositionPlacement)
local useRecyclingScope = require(script.Parent.useRecyclingScope)
local virtualizerConfiguration = require(script.Parent.virtualizerConfiguration)
local v

if FFlagViewRecyclerReact084 then
	v = React.useLayoutEffect
else
	v = React.useEffect
end

local function assignRef(callback, current) -- 4 equivalent calls inferred from this helper
	if callback == nil then
		return
	end

	if type(callback) == "function" then
		callback(current)
	else
		callback.current = current
	end
end

local toCorePinnedItem = nil
local configuration

if FFlagViewRecyclerReact084 then
	configuration = nil
else
	toCorePinnedItem = nil

	if FFlagViewRecyclerReact08 then
		configuration = nil
	else
		toCorePinnedItem = function(data)
			if data == nil then
				return nil
			end

			return { key = data.key, value = data.value, itemViewType = data.itemType }
		end

		configuration = function(data, p)
			return {
				scrollingFrame = p.scrollingFrame,
				viewportOverlay = p.viewportOverlay,
				axis = data.axis,
				dataSource = data.dataSource,
				layout = data.layout,
				onStartReached = data.onStartReached,
				onEndReached = data.onEndReached,
				onViewportChanged = data.onViewportChanged,
				onScrollOffsetChanged = data.onScrollOffsetChanged,
				onContentLengthChanged = data.onContentLengthChanged,
				onVisibleRangeChanged = data.onVisibleRangeChanged,
				onMountedRangeChanged = data.onMountedRangeChanged,
				onVisibleItemsPresented = data.onVisibleItemsPresented,
				onDataPrefetchRequested = data.onDataPrefetchRequested,
				overscan = data.overscan,
				dataPrefetch = data.dataPrefetch,
				contentAlignment = data.contentAlignment,
				endReachedThreshold = data.endReachedThreshold,
				initialScrollAlignment = data.initialScrollAlignment,
				autoScrollOnChange = data.autoScrollOnChange,
				autoScrollThreshold = data.autoScrollThreshold,
				startReachedThreshold = data.startReachedThreshold,
				isItemStickyHeader = data.isItemStickyHeader,
				pinnedStartItem = toCorePinnedItem(data.pinnedStartItem),
				pinnedEndItem = toCorePinnedItem(data.pinnedEndItem),
				preserveScrollPositionOnChange = data.preserveScrollPositionOnChange
			}
		end
	end
end

local function hostTarget(ref, ref2) -- 3 equivalent calls inferred from this helper
	return { scrollingFrame = ref.current, viewportOverlay = ref2.current }
end

local function assertAttachable(current) -- 1 equivalent call inferred from this helper
	assert(
		current.scrollingFrameProps == nil,
		"VirtualList: `scrollingFrameProps` cannot style an attached `scrollingFrame`"
	)

	assert(current.tag == nil, "VirtualList: `tag` cannot style an attached `scrollingFrame`")
end

local function useVirtualList(current)
	local ref = React.useRef(nil)
	local v2 = React.useState(current.scrollingFrame ~= nil)
	assert(
		(current.scrollingFrame ~= nil) == v2,
		"VirtualList: `scrollingFrame` cannot be added or removed during the list's lifetime"
	)

	if v2 then
		assertAttachable(current) -- inferred equivalent call
	end

	local v3 = nil
	local recyclingScope

	if FFlagViewRecyclerReact084 then
		recyclingScope = useRecyclingScope("VirtualList")
	else
		recyclingScope = nil
		v3 = nil

		if FFlagViewRecyclerReact08 then
			recyclingScope = useRecyclingScope("VirtualList")
		else
			v3 = React.useContext(RecyclingScopeContext)
			assert(v3 ~= nil, "VirtualListRenderer requires a RecyclingScope")
		end
	end

	local v4 = React.useContext(RecyclingViewportContext)
	local v5 = React.useState(function()
		local signal, setActive = Signals.createSignal(false)
		return { active = signal, setActive = setActive }
	end)

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local v6

	if FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08 then
		v6 = nil
	else
		recyclingScope = React.useState(function()
			return v3.root.getScope(v3.listOptions)
		end)

		React.useEffect(function()
			recyclingScope.bind({
				releases = {},
				requests = {},
				capacity = v3.listOptions.maxPoolSize,
				updateCapacity = true
			})
		end, { recyclingScope, v3.listOptions.maxPoolSize })

		v6 = useCompositionPlacement(v3.root, v3.listOptions.maxPoolSize, v3.listOptions.diagnostics)
	end

	local ref5 = React.useRef(nil)
	local v7 = React.useState(function()
		local v7 = current
		return {
			synchronize = function(current2)
				v7 = current2
				ref.current = current2
				local current3 = ref5.current

				if current3 ~= nil then
					local update = current3.update
					local v8

					if FFlagViewRecyclerReact084 then
						v8 = virtualizerConfiguration
					elseif FFlagViewRecyclerReact08 then
						v8 = virtualizerConfiguration
					else
						v8 = configuration
					end

					update(v8(current2, hostTarget(ref3, ref4))) -- inferred equivalent call
				end
			end,
			refreshHost = function()
				local current2 = ref5.current

				if current2 ~= nil then
					local update = current2.update
					local v8

					if FFlagViewRecyclerReact084 then
						v8 = virtualizerConfiguration
					elseif FFlagViewRecyclerReact08 then
						v8 = virtualizerConfiguration
					else
						v8 = configuration
					end

					update(v8(v7, hostTarget(ref3, ref4))) -- inferred equivalent call
				end
			end
		}
	end)

	local onScrollingFrameChanged = React.useCallback(function(p)
		local current2 = ref2.current

		if current2 ~= nil then
			ref2.current = nil
			current2()
		end

		if p ~= nil and v4 ~= nil then
			ref2.current = v4.register(p, v5.setActive)
		end

		v7.refreshHost()
	end, { v5, v7.refreshHost, v4 })
	local ref6, v8

	if FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08 then
		ref6 = nil
		v8 = nil
	else
		v8 = current.isItemStickyHeader ~= nil or current.pinnedStartItem ~= nil or current.pinnedEndItem ~= nil
		ref6 = React.useRef(nil)
	end

	local useLayoutEffect = React.useLayoutEffect
	local function fn()
		if not v2 then
			return
		end

		local attachedViewportOverlay, current2

		if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
			current2 = ref6.current

			if v8 then
				attachedViewportOverlay = ViewRecyclerRoblox.Internal.AttachedViewportOverlay.new(
					current.scrollingFrame,
					current.axis
				)
			end

			ref6.current = attachedViewportOverlay
		end

		ref3.current = current.scrollingFrame

		if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
			local current3

			if attachedViewportOverlay ~= nil then
				current3 = attachedViewportOverlay.overlay
			end

			ref4.current = current3
		end

		onScrollingFrameChanged(current.scrollingFrame)

		if not FFlagViewRecyclerReact084 and not FFlagViewRecyclerReact08 and current2 ~= nil then
			current2.destroy()
		end
	end

	local v9

	if FFlagViewRecyclerReact084 then
		v9 = { v2, current.scrollingFrame, onScrollingFrameChanged }
	elseif FFlagViewRecyclerReact08 then
		v9 = { v2, current.scrollingFrame, onScrollingFrameChanged }
	else
		v9 = { v2, current.scrollingFrame, current.axis, v8, onScrollingFrameChanged }
	end

	useLayoutEffect(fn, v9)

	React.useLayoutEffect(function()
		ref.current = current
		local function instrumentation() -- 2 equivalent calls inferred from this helper
			local current2 = ref.current

			if current2 == nil then
				return nil
			end

			return current2._instrumentation
		end

		local v10 = nil
		local listSink

		if FFlagViewRecyclerReact084 then
			listSink = nil
		else
			v10 = nil

			if FFlagViewRecyclerReact08 then
				listSink = nil
			else
				v10 = setmetatable({}, { __mode = "k" })
				listSink = function(p, p2)
					local v11 = v10[p]

					if v11 == nil then
						v11 = table.freeze({
							apply = function(p3)
								p2.apply(p, p3)
							end
						})

						v10[p] = v11
					end

					return v11
				end
			end
		end

		local v11

		if FFlagViewRecyclerReact084 then
			v11 = virtualizerConfiguration
		elseif FFlagViewRecyclerReact08 then
			v11 = virtualizerConfiguration
		else
			v11 = configuration
		end

		local v12 = v11(current, hostTarget(ref3, ref4)) -- inferred equivalent call

		v12.recyclingScope = recyclingScope
		function v12.getItemViewType(p, p2)
			local selected = ref.current.itemType
			assert(
				RecyclableViewRegistry.isRegistered(selected) or type(selected) == "function",
				"VirtualList: `itemType` must be a Recyclable view type or selector"
			)

			if not RecyclableViewRegistry.isRegistered(selected) then
				selected = selected(p, p2)
			end

			assert(
				RecyclableViewRegistry.isRegistered(selected),
				"VirtualList: `itemType` selector must return a Recyclable view type"
			)

			return selected
		end

		v12.diagnostics = current.diagnostics
		local active2

		if v4 ~= nil then
			active2 = v5.active(false)
		end

		v12.active = active2

		if FFlagViewRecyclerReact084 then
			function v12.isReadyOnAssignment(p)
				return p.isReadyOnAssignment()
			end
		end

		function v12.presentItemView(p, state, p2, sink)
			local transition = p.transition
			local frozen

			if state ~= nil then
				local v13 = { assignment = state.assignment, index = state.index, destination = 0 }
				local v14

				if FFlagViewRecyclerReact084 then
					v14 = Destination.Kind
				elseif FFlagViewRecyclerReact08 then
					v14 = Destination.Kind
				else
					v14 = PlacementKind
				end

				local v15 = { kind = v14.List, state = state, sink = 0, compositionPlacement = 0 }

				if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
					sink = listSink(p, sink)
				end

				v15.sink = sink
				local compositionPlacement

				if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
					compositionPlacement = v6
				end

				v15.compositionPlacement = compositionPlacement
				v13.destination = table.freeze(v15)
				frozen = table.freeze(v13)
			end

			transition(frozen)
			local v13 = instrumentation() -- inferred equivalent call

			if p2 and v13 ~= nil and v13.assignmentChanged ~= nil then
				local assignmentChanged = v13.assignmentChanged
				local v14

				if state ~= nil then
					v14 = state.assignment
				end

				assignmentChanged(p, v14)
			end
		end
		function v12.onItemViewPresentationChanged(p, p2)
			local v13 = instrumentation() -- inferred equivalent call

			if v13 ~= nil and v13.presentationChanged ~= nil then
				v13.presentationChanged(p, p2)
			end
		end
		local virtualizer = ViewRecyclerRoblox.createVirtualizer(v12)
		ref5.current = virtualizer
		local v13

		if v4 == nil then
			v13 = nil
		else
			local v14 = v12.active
			v13 = Signals.createEffect(function(p)
				local active = v5.active(p)

				if active ~= v14 then
					v14 = active
					virtualizer.setActive(active)
				end
			end)
		end

		return function()
			if v13 ~= nil then
				v13()
			end

			ref5.current = nil
			virtualizer.destroy()
		end
	end, { v7 })

	if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
		React.useLayoutEffect(function()
			return function()
				local current2 = ref6.current

				if current2 ~= nil then
					ref6.current = nil
					current2.destroy()
				end
			end
		end, {})

		React.useEffect(function()
			return v3.registerConsumer()
		end, { v3 })
	end

	React.useEffect(function()
		return function()
			local current2 = ref2.current

			if current2 ~= nil then
				ref2.current = nil
				current2()
			end
		end
	end, {})

	React.useLayoutEffect(function()
		v7.synchronize(current)
	end)

	React.useEffect(function()
		local current2 = ref5.current

		if current2 ~= nil then
			current2.refreshItemViews()
		end
	end, { current.itemType })

	v(function()
		local function runtime() -- 11 equivalent calls inferred from this helper
			return assert(ref5.current, "VirtualList: list handle used after unmount")
		end

		local current2 = {
			scrollToIndex = function(p, p2)
				runtime().scrollToIndex(p, p2) -- inferred equivalent call
			end,
			scrollToOffset = 0,
			scrollToStart = 0,
			scrollToEnd = 0,
			scrollBy = 0,
			getScrollState = 0,
			captureScrollAnchorSnapshot = 0,
			restoreScrollAnchorSnapshot = 0
		}
		local scrollToOffset

		if FFlagViewRecyclerReact084 then
			scrollToOffset = function(p, p2)
				return runtime().scrollToOffset(p, p2) -- inferred equivalent call
			end
		else
			scrollToOffset = function(p)
				return runtime().scrollToOffset(p) -- inferred equivalent call
			end
		end

		current2.scrollToOffset = scrollToOffset
		local scrollToStart

		if FFlagViewRecyclerReact084 then
			scrollToStart = function(p)
				runtime().scrollToStart(p) -- inferred equivalent call
			end
		else
			scrollToStart = function()
				runtime().scrollToStart() -- inferred equivalent call
			end
		end

		current2.scrollToStart = scrollToStart
		local scrollToEnd

		if FFlagViewRecyclerReact084 then
			scrollToEnd = function(p)
				runtime().scrollToEnd(p) -- inferred equivalent call
			end
		else
			scrollToEnd = function()
				runtime().scrollToEnd() -- inferred equivalent call
			end
		end

		current2.scrollToEnd = scrollToEnd

		function current2.scrollBy(p)
			return runtime().scrollBy(p) -- inferred equivalent call
		end

		function current2.getScrollState()
			return runtime().getScrollState() -- inferred equivalent call
		end

		function current2.captureScrollAnchorSnapshot()
			return runtime().captureScrollAnchorSnapshot() -- inferred equivalent call
		end

		function current2.restoreScrollAnchorSnapshot(p)
			return runtime().restoreScrollAnchorSnapshot(p) -- inferred equivalent call
		end

		assignRef(current.listRef, current2) -- inferred equivalent call
		return function()
			assignRef(current.listRef) -- inferred equivalent call
		end
	end, { current.listRef })

	v(function()
		assignRef(current.scrollingFrameRef, ref3.current) -- inferred equivalent call
		return function()
			assignRef(current.scrollingFrameRef) -- inferred equivalent call
		end
	end, { current.scrollingFrameRef, ref3, current.scrollingFrame })

	local onViewportOverlayChanged = React.useCallback(function(_)
		v7.refreshHost()
	end, { v7.refreshHost })

	return {
		axis = current.axis,
		onScrollingFrameChanged = onScrollingFrameChanged,
		onViewportOverlayChanged = onViewportOverlayChanged,
		internalRef = ref3,
		viewportOverlayRef = ref4,
		scrollingFrameProps = current.scrollingFrameProps,
		tag = current.tag
	}
end

return useVirtualList
