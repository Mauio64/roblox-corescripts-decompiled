local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)
local ItemHooks = require(ViewRecyclerReact.ReactAdapter.ItemHooks)
local LayoutHooks = require(ViewRecyclerReact.ReactAdapter.LayoutHooks)
local RecyclableViewReadiness = require(ViewRecyclerReact.ReactAdapter.RecyclableViewReadiness)
local RecyclableViewSwitch = require(ViewRecyclerReact.ReactAdapter.RecyclableViewSwitch)
local RecyclingScope = require(ViewRecyclerReact.ReactAdapter.RecyclingScope)
local RecyclingViewport = require(ViewRecyclerReact.ReactAdapter.RecyclingViewport)
local VirtualList = require(ViewRecyclerReact.ReactAdapter.VirtualList)
local createPinnedItem = require(ViewRecyclerReact.ReactAdapter.createPinnedItem)
local createRecyclableComponent = require(ViewRecyclerReact.ReactAdapter.createRecyclableComponent)
local createRecyclableView = require(ViewRecyclerReact.ReactAdapter.createRecyclableView)
local createVirtualList = require(ViewRecyclerReact.ReactAdapter.createVirtualList)

local useRectPlacement = require(ViewRecyclerReact.ReactAdapter.useRectPlacement)

local function createReactAdapter(p)
	local virtualList = VirtualList.create(p)
	local recyclingScope = RecyclingScope.create(p)
	local recyclingViewport = RecyclingViewport.create(p)
	local createVirtualList2 = createVirtualList.create(virtualList)

	local v = {}
	v.VirtualList = virtualList
	v.RecyclingScope = recyclingScope
	v.RecyclingViewport = recyclingViewport
	v.RecyclableViewSwitch = RecyclableViewSwitch
	v.createPinnedItem = createPinnedItem
	v.createRecyclableComponent = createRecyclableComponent
	v.createRecyclableView = createRecyclableView
	v.createVirtualList = createVirtualList2
	v.useRecyclingState = ItemHooks.useRecyclingState
	v.useRecyclingSignal = ItemHooks.useRecyclingSignal
	v.useRecyclingItem = ItemHooks.useRecyclingItem
	v.useRecyclingAssignment = ItemHooks.useRecyclingAssignment
	v.useRecyclingIndex = ItemHooks.useRecyclingIndex
	v.useMeasuredLayout = LayoutHooks.useMeasuredLayout
	v.useUniformLayout = LayoutHooks.useUniformLayout
	local useRectPlacement2

	if FFlagViewRecyclerReact08 then
		useRectPlacement2 = useRectPlacement
	end

	v.useRectPlacement = useRectPlacement2
	v.RecyclableViewReadiness = RecyclableViewReadiness

	v.DataSource = ViewRecycler.DataSource
	v.Diagnostics = ViewRecycler.Diagnostics
	v.Layout = ViewRecycler.Layout
	v.ChatPreset = ViewRecycler.ChatPreset

	v.Axis = ViewRecycler.Axis
	v.AutoScrollPolicy = ViewRecycler.AutoScrollPolicy
	v.ScrollAlignment = ViewRecycler.ScrollAlignment
	v.ScrollObservationKind = ViewRecycler.ScrollObservationKind
	v.PinnedPosition = ViewRecycler.PinnedPosition
	v.IdentityKind = ViewRecycler.IdentityKind
	v.DataPrefetchEdge = ViewRecycler.DataPrefetchEdge
	v.DataSourceChangeType = ViewRecycler.DataSourceChangeType

	v["jest.config"] = ViewRecyclerReact["jest.config"]
	return table.freeze(v)
end

return createReactAdapter
