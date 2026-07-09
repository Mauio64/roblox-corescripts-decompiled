local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local View = require(Parent.Foundation).View

local function VirtualizedItem(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), Signals (copy), View (copy)
	local v7, v8 = React.useState(-1)
	local v9 = React.useMemo(function() -- line: 27
		-- upvalues: React (copy), t1 (copy)
		return React.joinBindings({
			itemWidth = t1.itemWidth,
			itemHeight = t1.itemHeight
		}):map(function(p1) -- line: 28
			return UDim2.fromOffset(p1.itemWidth, p1.itemHeight)
		end)
	end, {})
	local v10 = React.joinBindings({
		numColumns = t1.numColumns,
		itemWidth = t1.itemWidth,
		itemHeight = t1.itemHeight
	})
	local v11 = React.useMemo(function() -- line: 41
		-- upvalues: v10 (copy), v7 (copy), t1 (copy)
		return v10:map(function(t2: {[any]: any}) -- line: 42
			-- upvalues: v7 (copy), t1 (copy)
			return UDim2.fromOffset((v7 - 1) % t2.numColumns * (t2.itemWidth + t1.gapSize), math.floor((v7 - 1) / t2.numColumns) * (t2.itemHeight + t1.gapSize))
		end)
	end, {
		v7,
		t1.gapSize
	})

	React.useEffect(function() -- line: 50
		-- upvalues: Signals (copy), t1 (copy), v8 (copy)
		local v12 = Signals.createEffect(function(p2) -- line: 53
			-- upvalues: t1 (copy), v8 (copy)
			local v16 = t1.getMinVirtualizedIndex(p2)
			local v17 = t1.getMaxVirtualizedIndex(p2) - v16 + 1
			local v18 = (v16 - 1) % v17 + 1
			local v19 = v16 + (t1.relativeIndex - v18) % v17

			v8(v19)
		end)

		return function() -- line: 62
			-- upvalues: v12 (copy)
			v12()
		end
	end, {
		t1.relativeIndex,
		t1.getMinVirtualizedIndex,
		t1.getMaxVirtualizedIndex
	})

	return React.createElement(View, {
		Size = v9,
		Position = v11,
		ZIndex = v7 ~= 1 and 1 or 2
	}, {
		Item = t1.getElement(v7)
	})
end

return React.memo(VirtualizedItem)
