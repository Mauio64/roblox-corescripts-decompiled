local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local v5 = {}
local center = Enum.HorizontalAlignment.Center
v5[center] = {
	[Enum.VerticalAlignment.Center] = {
		anchor = Vector2.new(0.5, 0.5),
		position = UDim2.fromScale(0.5, 0.5)
	},
	[Enum.VerticalAlignment.Top] = {
		anchor = Vector2.new(0.5, 0),
		position = UDim2.fromScale(0.5, 0)
	},
	[Enum.VerticalAlignment.Bottom] = {
		anchor = Vector2.new(0.5, 1),
		position = UDim2.fromScale(0.5, 1)
	}
}

local left = Enum.HorizontalAlignment.Left
v5[left] = {
	[Enum.VerticalAlignment.Center] = {
		anchor = Vector2.new(0, 0.5),
		position = UDim2.fromScale(0, 0.5)
	},
	[Enum.VerticalAlignment.Top] = {
		anchor = Vector2.new(0, 0),
		position = UDim2.fromScale(0, 0)
	},
	[Enum.VerticalAlignment.Bottom] = {
		anchor = Vector2.new(0, 1),
		position = UDim2.fromScale(0, 1)
	}
}

local right = Enum.HorizontalAlignment.Right
v5[right] = {
	[Enum.VerticalAlignment.Center] = {
		anchor = Vector2.new(1, 0.5),
		position = UDim2.fromScale(1, 0.5)
	},
	[Enum.VerticalAlignment.Top] = {
		anchor = Vector2.new(1, 0),
		position = UDim2.fromScale(1, 0)
	},
	[Enum.VerticalAlignment.Bottom] = {
		anchor = Vector2.new(1, 1),
		position = UDim2.fromScale(1, 1)
	}
}

local function Frame(props)
	local v9, v10 = React.useMemo(function()
		if props.horizontalAlignment and props.verticalAlignment then
			return
				v5[props.horizontalAlignment][props.verticalAlignment].anchor,
				v5[props.horizontalAlignment][props.verticalAlignment].position
		end

		return nil, nil
	end, { props.horizontalAlignment, props.verticalAlignment })

	return React.createElement("Frame", {
		AnchorPoint = props.AnchorPoint or v9,
		BackgroundColor3 = props.BackgroundColor3,
		BackgroundTransparency = props.BackgroundTransparency or 1,
		BorderSizePixel = 0,
		ClipsDescendants = props.ClipsDescendants,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position or v10,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex,
		children = props.children
	})
end

return Frame
