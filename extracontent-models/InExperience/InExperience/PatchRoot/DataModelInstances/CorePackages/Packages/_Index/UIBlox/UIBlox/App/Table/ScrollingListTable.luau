local parent = script.Parent.Parent.Parent
local core = parent.Core
local parent2 = parent.Parent

local React = require(parent2.React)
local VirtualizedList = require(parent2.VirtualizedList)
local virtualizedList = VirtualizedList.VirtualizedList
local Cryo = require(parent2.Cryo)
local withStyle = require(core.Style.withStyle)

local v = { selectable = true, size = UDim2.fromScale(1, 1) }

local function ScrollingListTable(p)
	return withStyle(function(p2)
		local joined = Cryo.Dictionary.join(v, p)

		local cells = joined.cells
		local children = {}

		for i, cell in ipairs(cells) do
			local name = "Cell " .. i
			local createElement = React.createElement
			local v2 = {
				LayoutOrder = i,
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				Name = name
			}
			local divider

			if i < #cells then
				divider = React.createElement("Frame", {
					Size = UDim2.new(1, -24, 0, 1),
					Position = UDim2.new(0, 24, 1, -1),
					BorderSizePixel = 0,
					BackgroundColor3 = p2.Theme.Divider.Color,
					BackgroundTransparency = p2.Theme.Divider.Transparency,
					ZIndex = 100
				}) or nil
			end

			children[name] = createElement("Frame", v2, { Content = cell, Divider = divider })
		end

		return React.createElement(virtualizedList, {
			Size = joined.size,
			data = children,
			renderItem = function(p3)
				return p3.item
			end,
			getItemCount = function(_)
				return #cells
			end,
			getItem = function(p3, p4: number)
				return p3["Cell " .. tostring(p4)]
			end,
			keyExtractor = function(_, p3: number)
				return "Cell " .. tostring(p3)
			end,
			style = {
				AnchorPoint = joined.anchorPoint,
				Position = joined.position,
				BackgroundTransparency = 1,
				LayoutOrder = joined.layoutOrder,
				Name = joined.Name or "ListTable",
				ScrollBarThickness = 0,
				Selectable = joined.selectable
			},
			contentContainerStyle = { BackgroundTransparency = 1 }
		})
	end)
end

return ScrollingListTable
