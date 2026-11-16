local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)

local v = { itemPadding = UDim.new(0, 12), numItemsShown = 1e999 }

local function EventsGridLayout(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = React.useMemo(function()
		local children = {}

		for i = 1, joined.numItemsShown do
			local item = joined.items[i]

			children[i] = React.createElement(
				"Frame",
				{
					LayoutOrder = i,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				},
				{ Content = item }
			)
		end

		return children
	end, { joined.items, joined.numItemsShown })

	local v3 = React.useMemo(function()
		local elements = {}

		for i = 1, #v2, 2 do
			local v3 = v2[i]
			local v4 = v2[i + 1]

			local element = React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = i
				},
				{
					Layout = React.createElement("UIListLayout", {
						Padding = joined.itemPadding,
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left
					}),
					CellFrame1 = React.createElement("Frame", {
						Size = UDim2.new(0.5, -joined.itemPadding.Offset / 2, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 1
					}, {
						Item = React.createElement(React.Fragment, nil, v3)
					}),
					CellFrame2 = v4 and React.createElement("Frame", {
						Size = UDim2.new(0.5, -joined.itemPadding.Offset / 2, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 2
					}, {
						Item = React.createElement(React.Fragment, nil, v4)
					})
				}
			)

			elements["Row" .. math.ceil(i / 2)] = element
		end

		return elements
	end, { joined.items, v2 })

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		},
		{
			Layout = React.createElement("UIListLayout", {
				Padding = joined.itemPadding,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			Rows = React.createElement(React.Fragment, nil, v3)
		}
	)
end

return EventsGridLayout
