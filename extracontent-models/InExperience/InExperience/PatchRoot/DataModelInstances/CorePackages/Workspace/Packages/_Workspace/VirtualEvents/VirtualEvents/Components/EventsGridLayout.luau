local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local t1 = {
	numItemsShown = 1e999,
	itemPadding = UDim.new(0, 12)
}

local function EventsGridLayout(t2: {[any]: any}) -- line: 19
	-- upvalues: Cryo (copy), t1 (copy), React (copy)
	local v7 = Cryo.Dictionary.join(t1, t2)
	local v8 = React.useMemo(function() -- line: 22
		-- upvalues: v7 (copy), React (copy)
		local t3 = {}

		for i = 1, v7.numItemsShown do
			local v12 = v7.items[i]

			t3[i] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = i,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Content = v12
			})
		end

		return t3
	end, {
		v7.items,
		v7.numItemsShown
	})
	local v9 = React.useMemo(function() -- line: 39
		-- upvalues: v8 (copy), React (copy), v7 (copy)
		local t4 = {}

		for i = 1, #v8, 2 do
			local v15 = v8[i]
			local v16 = v8[i + 1]
			local v17 = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = i
			}, {
				Layout = React.createElement("UIListLayout", {
					Padding = v7.itemPadding,
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left
				}),
				CellFrame1 = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(0.5, -v7.itemPadding.Offset / 2, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Item = React.createElement(React.Fragment, nil, v15)
				}),
				CellFrame2 = v16 and React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(0.5, -v7.itemPadding.Offset / 2, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Item = React.createElement(React.Fragment, nil, v16)
				})
			})

			t4["Row" .. math.ceil(i / 2)] = v17
		end

		return t4
	end, {
		v7.items,
		v8
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Layout = React.createElement("UIListLayout", {
			Padding = v7.itemPadding,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		Rows = React.createElement(React.Fragment, nil, v9)
	})
end

return EventsGridLayout
