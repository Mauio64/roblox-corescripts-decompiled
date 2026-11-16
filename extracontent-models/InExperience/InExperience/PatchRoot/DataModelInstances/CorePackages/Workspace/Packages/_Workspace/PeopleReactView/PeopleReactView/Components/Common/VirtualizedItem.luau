local parent = script:FindFirstAncestor("PeopleReactView").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local Foundation = require(parent.Foundation)
local View = Foundation.View

local function VirtualizedItem(props)
	local state, setState = React.useState(-1)

	local size = React.useMemo(function()
		return React.joinBindings({ itemWidth = props.itemWidth, itemHeight = props.itemHeight }):map(function(p)
			return UDim2.fromOffset(p.itemWidth, p.itemHeight)
		end)
	end, {})

	local joinBindings = React.joinBindings({
		numColumns = props.numColumns,
		itemWidth = props.itemWidth,
		itemHeight = props.itemHeight
	})

	local position = React.useMemo(function()
		return joinBindings:map(function(data)
			return UDim2.fromOffset(
				(state - 1) % data.numColumns * (data.itemWidth + props.gapSize),
				math.floor((state - 1) / data.numColumns) * (data.itemHeight + props.gapSize)
			)
		end)
	end, { state, props.gapSize })

	React.useEffect(function()
		local effect = Signals.createEffect(function(p)
			local minVirtualizedIndex = props.getMinVirtualizedIndex(p)
			local v = props.getMaxVirtualizedIndex(p) - minVirtualizedIndex + 1
			local v2 = (minVirtualizedIndex - 1) % v + 1
			setState(minVirtualizedIndex + (props.relativeIndex - v2) % v)
		end)

		return function()
			effect()
		end
	end, { props.relativeIndex, props.getMinVirtualizedIndex, props.getMaxVirtualizedIndex })

	return React.createElement(View, {
		Size = size,
		Position = position,
		ZIndex = state == 1 and 2 or 1
	}, { Item = props.getElement(state) })
end

return React.memo(VirtualizedItem)
