local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local mutedError = require(Parent.Loggers).mutedError
local v4 = game:DefineFastFlag("AXDebugGridShouldErrorOnInvalidRowCount", false)

local function GridRow(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy)
	local t2 = {
		GridRowLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for v8, v9 in t1.items do
		t2[`item-{ t1.getItemId(v9) }-{ v8 }`] = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(UDim.new(1 / t1.itemsPerRow, 0), UDim.new(0, 0)),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = v8
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, t1.gapHorizontal / 2),
				PaddingRight = UDim.new(0, t1.gapHorizontal / 2)
			}),
			Content = t1.renderItem({
				item = v9,
				index = (t1.rowIndex - 1) * t1.itemsPerRow + v8,
				gridInformation = {
					row = t1.rowIndex,
					column = (v8 - 1) % t1.itemsPerRow + 1
				}
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, t2)
end

return (React.forwardRef(function(t3: {[any]: any}, p1) -- line: 80
	-- upvalues: v4 (copy), mutedError (copy), React (copy), GridRow (copy)
	local v12 = if not (t3.itemsPerRow <= 0) then t3.itemsPerRow else 1

	if v4 and t3.itemsPerRow <= 0 then
		mutedError(`itemsPerRow must be a positive number greater than 0, received { v12 }`)
	end

	local v13 = t3.gapVertical or 0
	local v14 = t3.gapHorizontal or 0
	local v15 = math.ceil(#t3.items / v12)
	local t4 = {
		GridLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v13)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, -v14 / 2),
			PaddingRight = UDim.new(0, -v14 / 2)
		})
	}

	for i = 1, v15 do
		local v18 = (i - 1) * v12 + 1
		local t5 = {}

		table.move(t3.items, v18, v18 + v12 - 1, v18, t5)
		t4["row-" .. tostring(i)] = React.createElement(GridRow, {
			items = t5,
			itemsPerRow = v12,
			renderItem = t3.renderItem,
			getItemId = t3.getItemId,
			LayoutOrder = i,
			gapHorizontal = v14,
			rowIndex = i
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = t3.Size or UDim2.fromScale(1, 1),
		AutomaticSize = t3.AutomaticSize,
		LayoutOrder = t3.LayoutOrder,
		ref = p1
	}, t4)
end))
