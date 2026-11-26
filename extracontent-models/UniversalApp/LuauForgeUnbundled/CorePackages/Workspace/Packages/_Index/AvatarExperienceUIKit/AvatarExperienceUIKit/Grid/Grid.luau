local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Loggers").mutedError

local defineFastFlag = game:DefineFastFlag("AXDebugGridShouldErrorOnInvalidRowCount", false)

local function GridRow(props)
	local children = {
		GridRowLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for k, item in props.items do
		children[`item-{props.getItemId(item)}-{k}`] = React.createElement("Frame", {
			Size = UDim2.new(UDim.new(1 / props.itemsPerRow, 0), UDim.new(0, 0)),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = k
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, props.gapHorizontal / 2),
				PaddingRight = UDim.new(0, props.gapHorizontal / 2)
			}),
			Content = props.renderItem({
				item = item,
				index = (props.rowIndex - 1) * props.itemsPerRow + k,
				gridInformation = {
					row = props.rowIndex,
					column = (k - 1) % props.itemsPerRow + 1
				}
			})
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder
	}, children)
end

return (React.forwardRef(function(props, p2)
	local v5 = props.itemsPerRow <= 0 and 1 or props.itemsPerRow

	if defineFastFlag and props.itemsPerRow <= 0 then
		mutedError(`itemsPerRow must be a positive number greater than 0, received {v5}`)
	end

	local gapVertical = props.gapVertical or 0
	local gapHorizontal = props.gapHorizontal or 0

	local v6 = math.ceil(#props.items / v5)

	local children = {
		GridLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, gapVertical)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, -gapHorizontal / 2),
			PaddingRight = UDim.new(0, -gapHorizontal / 2)
		})
	}

	for i = 1, v6 do
		local v7 = (i - 1) * v5 + 1
		local v8 = {}
		table.move(props.items, v7, v7 + v5 - 1, v7, v8)
		children["row-" .. tostring(i)] = React.createElement(GridRow, {
			items = v8,
			itemsPerRow = v5,
			renderItem = props.renderItem,
			getItemId = props.getItemId,
			LayoutOrder = i,
			gapHorizontal = gapHorizontal,
			rowIndex = i
		})
	end

	return React.createElement("Frame", {
		Size = props.Size or UDim2.fromScale(1, 1),
		AutomaticSize = props.AutomaticSize,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		ref = p2
	}, children)
end))
