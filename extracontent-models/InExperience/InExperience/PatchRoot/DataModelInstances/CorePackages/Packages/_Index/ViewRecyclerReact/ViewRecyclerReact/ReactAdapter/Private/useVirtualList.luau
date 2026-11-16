local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
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

local toCorePinnedItem
local configuration

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
	local v = React.useState(current.scrollingFrame ~= nil)
	assert(
		(current.scrollingFrame ~= nil) == v,
		"VirtualList: `scrollingFrame` cannot be added or removed during the list's lifetime"
	)

	if v then
		assertAttachable(current) -- inferred equivalent call
	end

	local recyclingScope = nil
	local v2 = nil

	if FFlagViewRecyclerReact08 then
		recyclingScope = useRecyclingScope("VirtualList")
	else
		v2 = React.useContext(RecyclingScopeContext)
		assert(v2 ~= nil, "VirtualListRenderer requires a RecyclingScope")
	end

	local v3 = React.useContext(RecyclingViewportContext)
	local v4 = React.useState(function()
		local signal, setActive = Signals.createSignal(false)
		return { active = signal, setActive = setActive }
	end)

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local v5

	if FFlagViewRecyclerReact08 then
		v5 = nil
	else
		recyclingScope = React.useState(function()
			return v2.root.getScope(v2.listOptions)
		end)

		React.useEffect(function()
			recyclingScope.bind({
				releases = {},
				requests = {},
				capacity = v2.listOptions.maxPoolSize,
				updateCapacity = true
			})
		end, { recyclingScope, v2.listOptions.maxPoolSize })

		v5 = useCompositionPlacement(v2.root, v2.listOptions.maxPoolSize, v2.listOptions.diagnostics)
	end

	local ref5 = React.useRef(nil)
	local v6 = React.useState(function()
		local v6 = current
		return {
			synchronize = function(current2)
				v6 = current2
				ref.current = current2
				local current3 = ref5.current

				if current3 ~= nil then
					local update = current3.update
					local v7

					if FFlagViewRecyclerReact08 then
						v7 = virtualizerConfiguration
					else
						v7 = configuration
					end

					update(v7(current2, hostTarget(ref3, ref4))) -- inferred equivalent call
				end
			end,
			refreshHost = function()
				local current2 = ref5.current

				if current2 ~= nil then
					local update = current2.update
					local v7

					if FFlagViewRecyclerReact08 then
						v7 = virtualizerConfiguration
					else
						v7 = configuration
					end

					update(v7(v6, hostTarget(ref3, ref4))) -- inferred equivalent call
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

		if p ~= nil and v3 ~= nil then
			ref2.current = v3.register(p, v4.setActive)
		end

		v6.refreshHost()
	end, { v4, v6.refreshHost, v3 })
	local ref6, v7

	if FFlagViewRecyclerReact08 then
		ref6 = nil
		v7 = nil
	else
		v7 = current.isItemStickyHeader ~= nil or current.pinnedStartItem ~= nil or current.pinnedEndItem ~= nil
		ref6 = React.useRef(nil)
	end

	local useLayoutEffect = React.useLayoutEffect
	local function fn()
		if not v then
			return
		end

		local attachedViewportOverlay, current2

		if not FFlagViewRecyclerReact08 then
			current2 = ref6.current

			if v7 then
				attachedViewportOverlay = ViewRecyclerRoblox.Internal.AttachedViewportOverlay.new(
					current.scrollingFrame,
					current.axis
				)
			end

			ref6.current = attachedViewportOverlay
		end

		ref3.current = current.scrollingFrame

		if not FFlagViewRecyclerReact08 then
			local current3

			if attachedViewportOverlay ~= nil then
				current3 = attachedViewportOverlay.overlay
			end

			ref4.current = current3
		end

		onScrollingFrameChanged(current.scrollingFrame)

		if not FFlagViewRecyclerReact08 and current2 ~= nil then
			current2.destroy()
		end
	end

	local v8

	if FFlagViewRecyclerReact08 then
		v8 = { v, current.scrollingFrame, onScrollingFrameChanged }
	else
		v8 = { v, current.scrollingFrame, current.axis, v7, onScrollingFrameChanged }
	end

	useLayoutEffect(fn, v8)

	React.useLayoutEffect(function()
		ref.current = current
		local function instrumentation() -- 2 equivalent calls inferred from this helper
			local current2 = ref.current

			if current2 == nil then
				return nil
			end

			return current2._instrumentation
		end

		local v9 = nil
		local listSink

		if FFlagViewRecyclerReact08 then
			listSink = nil
		else
			v9 = setmetatable({}, { __mode = "k" })
			listSink = function(p, p2)
				local v10 = v9[p]

				if v10 == nil then
					v10 = table.freeze({
						apply = function(p3)
							p2.apply(p, p3)
						end
					})

					v9[p] = v10
				end

				return v10
			end
		end

		local v10

		if FFlagViewRecyclerReact08 then
			v10 = virtualizerConfiguration
		else
			v10 = configuration
		end

		local v11 = v10(current, hostTarget(ref3, ref4)) -- inferred equivalent call

		v11.recyclingScope = recyclingScope
		function v11.getItemViewType(p, p2)
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

		v11.diagnostics = current.diagnostics
		local active2

		if v3 ~= nil then
			active2 = v4.active(false)
		end

		v11.active = active2
		function v11.presentItemView(p, state, p2, sink)
			local transition = p.transition
			local frozen

			if state ~= nil then
				local v12 = { assignment = state.assignment, index = state.index, destination = 0 }
				local v13

				if FFlagViewRecyclerReact08 then
					v13 = Destination.Kind
				else
					v13 = PlacementKind
				end

				local v14 = { kind = v13.List, state = state, sink = 0, compositionPlacement = 0 }

				if not FFlagViewRecyclerReact08 then
					sink = listSink(p, sink)
				end

				v14.sink = sink
				local compositionPlacement

				if not FFlagViewRecyclerReact08 then
					compositionPlacement = v5
				end

				v14.compositionPlacement = compositionPlacement
				v12.destination = table.freeze(v14)
				frozen = table.freeze(v12)
			end

			transition(frozen)
			local v12 = instrumentation() -- inferred equivalent call

			if p2 and v12 ~= nil and v12.assignmentChanged ~= nil then
				local assignmentChanged = v12.assignmentChanged
				local v13

				if state ~= nil then
					v13 = state.assignment
				end

				assignmentChanged(p, v13)
			end
		end
		function v11.onItemViewPresentationChanged(p, p2)
			local v12 = instrumentation() -- inferred equivalent call

			if v12 ~= nil and v12.presentationChanged ~= nil then
				v12.presentationChanged(p, p2)
			end
		end
		local virtualizer = ViewRecyclerRoblox.createVirtualizer(v11)
		ref5.current = virtualizer
		local v12

		if v3 == nil then
			v12 = nil
		else
			local v13 = v11.active
			v12 = Signals.createEffect(function(p)
				local active = v4.active(p)

				if active ~= v13 then
					v13 = active
					virtualizer.setActive(active)
				end
			end)
		end

		return function()
			if v12 ~= nil then
				v12()
			end

			ref5.current = nil
			virtualizer.destroy()
		end
	end, { v6 })

	if not FFlagViewRecyclerReact08 then
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
			return v2.registerConsumer()
		end, { v2 })
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
		v6.synchronize(current)
	end)

	React.useEffect(function()
		local current2 = ref5.current

		if current2 ~= nil then
			current2.refreshItemViews()
		end
	end, { current.itemType })

	React.useEffect(function()
		local function runtime() -- 8 equivalent calls inferred from this helper
			return assert(ref5.current, "VirtualList: list handle used after unmount")
		end

		assignRef(current.listRef, { -- inferred equivalent call
			scrollToIndex = function(p, p2)
				runtime().scrollToIndex(p, p2) -- inferred equivalent call
			end,
			scrollToOffset = function(p)
				return runtime().scrollToOffset(p) -- inferred equivalent call
			end,
			scrollToStart = function()
				runtime().scrollToStart() -- inferred equivalent call
			end,
			scrollToEnd = function()
				runtime().scrollToEnd() -- inferred equivalent call
			end,
			scrollBy = function(p)
				return runtime().scrollBy(p) -- inferred equivalent call
			end,
			getScrollState = function()
				return runtime().getScrollState() -- inferred equivalent call
			end,
			captureScrollAnchorSnapshot = function()
				return runtime().captureScrollAnchorSnapshot() -- inferred equivalent call
			end,
			restoreScrollAnchorSnapshot = function(p)
				return runtime().restoreScrollAnchorSnapshot(p) -- inferred equivalent call
			end
		})
		return function()
			assignRef(current.listRef) -- inferred equivalent call
		end
	end, { current.listRef })

	React.useEffect(function()
		assignRef(current.scrollingFrameRef, ref3.current) -- inferred equivalent call
		return function()
			assignRef(current.scrollingFrameRef) -- inferred equivalent call
		end
	end, { current.scrollingFrameRef, ref3, current.scrollingFrame })

	local onViewportOverlayChanged = React.useCallback(function(_)
		v6.refreshHost()
	end, { v6.refreshHost })

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
