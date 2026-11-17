local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
require(ViewRecyclerReact.Parent.ViewRecycler)
require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)

local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewRegistry = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewRegistry)

local RecyclingScopeContext = require(ViewRecyclerReact.ReactAdapter.Private.RecyclingScopeContext)
local RecyclingScope = require(ViewRecyclerReact.ReactAdapter.RecyclingScope)

require(ViewRecyclerReact.Parent.Signals)

local VirtualListShell = require(ViewRecyclerReact.ReactAdapter.Private.VirtualListShell)

require(ViewRecyclerReact.ReactAdapter.createPinnedItem)
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

	local v2 = nil
	local DeclarativeVirtualList
	local DataSourceVirtualList

	if FFlagViewRecyclerReact084 then
		v2 = React.memo(function(p2)
			return createElement(v, { maxPoolSize = p2.maxPoolSize, diagnostics = p2.diagnostics }, {
				List = createElement(VirtualListRenderer, p2)
			})
		end)
	else
		DeclarativeVirtualList = function(p2)
			local dataSource = useReconciledDataSource(p2.data.items, p2.data.getItemKey)
			local clone = table.clone(p2)
			clone.data = nil
			clone.dataSource = dataSource
			return createElement(VirtualListRenderer, clone)
		end

		DataSourceVirtualList = function(p2)
			local clone = table.clone(p2)
			clone.dataSource = p2.data
			clone.data = nil
			return createElement(VirtualListRenderer, clone)
		end
	end

	local function VirtualList(props)
		local v3

		if not (FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08) then
			v3 = React.useContext(RecyclingScopeContext)
		end

		local data = props.data
		assert(data ~= nil, "VirtualList: `data` is required")
		assert(props.itemType ~= nil, "VirtualList: `itemType` is required")

		if not RecyclableViewRegistry.isRegistered(props.itemType) then
			assert(
				type(props.itemType) == "function",
				"VirtualList: `itemType` must be a Recyclable view type or selector"
			)
			local v4

			if type(data.getItemCount) == "function" and data.getItemCount() > 0 then
				v4 = data.getItem(1)
			elseif type(data.items) == "table" then
				v4 = data.items[1]
			end

			if v4 ~= nil then
				assert(
					RecyclableViewRegistry.isRegistered(props.itemType(v4, 1)),
					"VirtualList: `itemType` selector must return a Recyclable view type"
				)
			end
		end

		local v4 = nil
		local list = nil

		if FFlagViewRecyclerReact084 then
			if
				type(data) == "table"
				and type(data.getItemCount) == "function"
				and type(data.getItem) == "function"
				and type(data.getItemKey) == "function"
			then
				v4 = type(data.subscribe) == "function"
			else
				v4 = false
			end
		elseif
			type(data) == "table"
			and type(data.getItemCount) == "function"
			and type(data.getItem) == "function"
			and type(data.getItemKey) == "function"
			and type(data.subscribe) == "function"
		then
			list = createElement(DataSourceVirtualList, props)
		else
			local v5 = type(data) == "table" and type(data.items) == "table" and type(data.getItemKey) == "function"
			assert(v5, "VirtualList: `data` must be a DataSource or { items, getItemKey }")

			list = createElement(DeclarativeVirtualList, props)
		end

		local v5

		if FFlagViewRecyclerReact084 then
			v5 = v4
		else
			v5 = FFlagViewRecyclerReact08
		end

		if not v5 then
			if FFlagViewRecyclerReact084 then
				local v6 = type(data) == "table" and type(data.items) == "table" and type(data.getItemKey) == "function"
				assert(v6, "VirtualList: `data` must be a DataSource or { items, getItemKey }")
			elseif v3 ~= nil then
				assert(props.maxPoolSize == nil, "VirtualList: configure maxPoolSize on RecyclingScope")
				return list
			end
		end

		if not FFlagViewRecyclerReact084 then
			return createElement(v, {
				maxPoolSize = props.maxPoolSize,
				diagnostics = props.diagnostics
			}, {
				List = list
			})
		end

		local items

		if not v4 then
			items = data.items
		end

		local v6

		if not v4 then
			v6 = data.getItemKey
		end

		local dataSource = useReconciledDataSource(items, v6)

		local clone = table.clone(props)
		clone.data = nil

		if v4 then
			dataSource = data
		end

		clone.dataSource = dataSource
		return createElement(v2, clone)
	end

	return VirtualList
end

return { create = createVirtualList }
