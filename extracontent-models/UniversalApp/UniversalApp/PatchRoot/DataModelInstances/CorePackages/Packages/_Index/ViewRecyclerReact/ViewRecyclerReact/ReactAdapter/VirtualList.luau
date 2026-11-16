local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)

require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)

local Axis = ViewRecycler.Axis
local Layout = ViewRecycler.Layout
local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewRegistry = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewRegistry)

local RecyclingScopeContext = require(ViewRecyclerReact.ReactAdapter.Private.RecyclingScopeContext)
local RecyclingScope = require(ViewRecyclerReact.ReactAdapter.RecyclingScope)
require(ViewRecyclerReact.ReactAdapter.createPinnedItem)
local ScrollAlignment = ViewRecycler.ScrollAlignment
require(ViewRecyclerReact.Parent.Signals)
local DataSource = ViewRecycler.DataSource
local VirtualListShell = require(ViewRecyclerReact.ReactAdapter.Private.VirtualListShell)
local useReconciledDataSource = require(ViewRecyclerReact.ReactAdapter.Private.useReconciledDataSource)
local useVirtualList = require(ViewRecyclerReact.ReactAdapter.Private.useVirtualList)

local createElement = React.createElement

local function createVirtualList(p)
	local v = RecyclingScope.create(p)

	local function VirtualListRenderer(p2)
		local v2 = useVirtualList(p2)

		if p2.scrollingFrame == nil then
			return createElement(VirtualListShell, v2)
		end

		return nil
	end

	local function DeclarativeVirtualList(p2)
		local dataSource = useReconciledDataSource(p2.data.items, p2.data.getItemKey)
		local clone = table.clone(p2)
		clone.data = nil
		clone.dataSource = dataSource
		return createElement(VirtualListRenderer, clone)
	end

	local function DataSourceVirtualList(p2)
		local clone = table.clone(p2)
		clone.dataSource = p2.data
		clone.data = nil
		return createElement(VirtualListRenderer, clone)
	end

	local function VirtualList(props)
		local v2

		if not FFlagViewRecyclerReact08 then
			v2 = React.useContext(RecyclingScopeContext)
		end

		local data = props.data
		assert(data ~= nil, "VirtualList: `data` is required")
		assert(props.itemType ~= nil, "VirtualList: `itemType` is required")

		if not RecyclableViewRegistry.isRegistered(props.itemType) then
			assert(
				type(props.itemType) == "function",
				"VirtualList: `itemType` must be a Recyclable view type or selector"
			)
			local v3

			if type(data.getItemCount) == "function" and data.getItemCount() > 0 then
				v3 = data.getItem(1)
			elseif type(data.items) == "table" then
				v3 = data.items[1]
			end

			if v3 ~= nil then
				assert(
					RecyclableViewRegistry.isRegistered(props.itemType(v3, 1)),
					"VirtualList: `itemType` selector must return a Recyclable view type"
				)
			end
		end

		local list

		if
			type(data) == "table"
			and type(data.getItemCount) == "function"
			and type(data.getItem) == "function"
			and type(data.getItemKey) == "function"
			and type(data.subscribe) == "function"
		then
			list = createElement(DataSourceVirtualList, props)
		else
			local v3 = type(data) == "table" and type(data.items) == "table" and type(data.getItemKey) == "function"
			assert(v3, "VirtualList: `data` must be a DataSource or { items, getItemKey }")

			list = createElement(DeclarativeVirtualList, props)
		end

		if FFlagViewRecyclerReact08 or v2 == nil then
			return createElement(v, {
				maxPoolSize = props.maxPoolSize,
				diagnostics = props.diagnostics
			}, {
				List = list
			})
		end

		assert(props.maxPoolSize == nil, "VirtualList: configure maxPoolSize on RecyclingScope")
		return list
	end

	return VirtualList
end

return { create = createVirtualList }
