local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)
local Axis = ViewRecycler.Axis
local ItemHooks = require(ViewRecyclerReact.ReactAdapter.ItemHooks)
local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewReadiness = require(ViewRecyclerReact.ReactAdapter.RecyclableViewReadiness)
local SignalsReact = require(ViewRecyclerReact.Parent.SignalsReact)
require(ViewRecyclerReact.ReactAdapter.VirtualList)
local createRecyclableView = require(ViewRecyclerReact.ReactAdapter.createRecyclableView)

local createElement = React.createElement

local function createItemViewType(data)
	local component = data.component
	return createRecyclableView(function(p)
		local v = ItemHooks.useRecyclingAssignment()
		local current3 = SignalsReact.useSignalState(v)
		local current4 = SignalsReact.useSignalState(ItemHooks.useRecyclingIndex())
		local ref = React.useRef(nil)
		local ref2 = React.useRef(nil)

		if current3 ~= nil then
			ref.current = current3
		end

		if current4 ~= nil then
			ref2.current = current4
		end

		local current = ref.current
		local current2 = ref2.current

		if current == nil or current2 == nil then
			return nil
		end

		return createElement(component, {
			item = current.value,
			index = current2,
			pending = p.pending
		})
	end, {
		readiness = data.readiness or RecyclableViewReadiness.ReadyOnCommit,
		hideWhilePending = data.hideWhilePending
	})
end

return {
	create = function(p)
		return function(data)
			assert(type(data) == "table", "createVirtualList: definition must be a table")
			local itemType

			if data.itemComponent == nil then
				local itemComponents = data.itemComponents
				local getItemComponent = data.getItemComponent

				local v = type(itemComponents) == "table" and #itemComponents > 0
				assert(v, "createVirtualList: itemComponents must be a non-empty array")

				assert(type(getItemComponent) == "function", "createVirtualList: getItemComponent must be a function")
				local v2 = {}

				for _, itemComponent in itemComponents do
					local component = itemComponent.component
					assert(type(component) == "function", "createVirtualList: component must be a React component")
					assert(v2[component] == nil, "createVirtualList: each component may be declared only once")

					v2[component] = createItemViewType(itemComponent)
				end

				itemType = function(p2, p3)
					local v3 = v2[getItemComponent(p2, p3)]
					assert(v3 ~= nil, "createVirtualList: getItemComponent returned an undeclared component")
					return v3
				end
			else
				assert(
					type(data.itemComponent) == "function",
					"createVirtualList: itemComponent must be a React component"
				)

				assert(data.itemComponents == nil, "createVirtualList: choose one definition form")
				itemType = createItemViewType({
					component = data.itemComponent,
					readiness = data.readiness,
					hideWhilePending = data.hideWhilePending
				})
			end

			local function SpecializedVirtualList(props)
				local v = props.pinnedStartItem == nil and props.pinnedEndItem == nil
				assert(v, "createVirtualList: pinned Items require VirtualList")

				local clone = table.clone(props)
				clone.axis = props.axis or Axis.Y
				clone.itemType = itemType
				return createElement(p, clone)
			end

			return SpecializedVirtualList
		end
	end
}
