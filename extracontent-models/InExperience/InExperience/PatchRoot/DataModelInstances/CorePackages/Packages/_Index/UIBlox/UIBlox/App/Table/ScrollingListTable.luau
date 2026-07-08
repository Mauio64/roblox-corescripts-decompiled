local ParentParent = script.Parent.Parent.Parent
local Core = ParentParent.Core
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local VirtualizedList = require(ParentParentParent.VirtualizedList).VirtualizedList
local Cryo = require(ParentParentParent.Cryo)
local withStyle = require(Core.Style.withStyle)
local t1 = {
	selectable = true,
	size = UDim2.fromScale(1, 1)
}

local function ScrollingListTable(t2: {[any]: any}) -- line: 39
	-- upvalues: withStyle (copy), Cryo (copy), t1 (copy), React (copy), VirtualizedList (copy)
	return withStyle(function(p1) -- line: 40
		-- upvalues: Cryo (copy), t1 (copy), t2 (copy), React (copy), VirtualizedList (copy)
		local v12 = Cryo.Dictionary.join(t1, t2)
		local t3 = {}
		local cells = v12.cells

		for i, v in ipairs(cells) do
			local v17 = "Cell " .. i

			t3[v17] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Name = v17
			}, {
				Content = v,
				Divider = i < #cells and React.createElement("Frame", {
					BorderSizePixel = 0,
					ZIndex = 100,
					Size = UDim2.new(1, -24, 0, 1),
					Position = UDim2.new(0, 24, 1, -1),
					BackgroundColor3 = p1.Theme.Divider.Color,
					BackgroundTransparency = p1.Theme.Divider.Transparency
				}) or nil
			})
		end

		return React.createElement(VirtualizedList, {
			Size = v12.size,
			data = t3,
			renderItem = function(p2) -- line: 70
				return p2.item
			end,
			getItemCount = function(_) -- line: 73
				-- upvalues: cells (copy)
				return #cells
			end,
			getItem = function(p4, n1: number) -- line: 76
				return p4["Cell " .. tostring(n1)]
			end,
			keyExtractor = function(_, n2: number) -- line: 80
				return "Cell " .. tostring(n2)
			end,
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				AnchorPoint = v12.anchorPoint,
				Position = v12.position,
				LayoutOrder = v12.layoutOrder,
				Name = v12.Name or "ListTable",
				Selectable = v12.selectable
			},
			contentContainerStyle = {
				BackgroundTransparency = 1
			}
		})
	end)
end

return ScrollingListTable
