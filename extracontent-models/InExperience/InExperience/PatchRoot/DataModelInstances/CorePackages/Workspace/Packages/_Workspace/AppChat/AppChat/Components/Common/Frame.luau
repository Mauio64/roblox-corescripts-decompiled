local AppChat = script:FindFirstAncestor("AppChat")
local React = require(AppChat.Parent.React)

local v = {}
local Center = Enum.HorizontalAlignment.Center
v[Center] = {
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

local Left = Enum.HorizontalAlignment.Left
v[Left] = {
	[Enum.VerticalAlignment.Center] = {
		anchor = Vector2.new(0, 0.5),
		position = UDim2.fromScale(0, 0.5)
	},
	[Enum.VerticalAlignment.Top] = { anchor = Vector2.new(0, 0), position = UDim2.fromScale(0, 0) },
	[Enum.VerticalAlignment.Bottom] = {
		anchor = Vector2.new(0, 1),
		position = UDim2.fromScale(0, 1)
	}
}

local Right = Enum.HorizontalAlignment.Right
v[Right] = {
	[Enum.VerticalAlignment.Center] = {
		anchor = Vector2.new(1, 0.5),
		position = UDim2.fromScale(1, 0.5)
	},
	[Enum.VerticalAlignment.Top] = { anchor = Vector2.new(1, 0), position = UDim2.fromScale(1, 0) },
	[Enum.VerticalAlignment.Bottom] = {
		anchor = Vector2.new(1, 1),
		position = UDim2.fromScale(1, 1)
	}
}

local function Frame(props)
	local v2, v3 = React.useMemo(function()
		if props.horizontalAlignment and props.verticalAlignment then
			return
				v[props.horizontalAlignment][props.verticalAlignment].anchor,
				v[props.horizontalAlignment][props.verticalAlignment].position
		end

		return nil, nil
	end, { props.horizontalAlignment, props.verticalAlignment })

	return React.createElement("Frame", {
		AnchorPoint = props.AnchorPoint or v2,
		BackgroundColor3 = props.BackgroundColor3,
		BackgroundTransparency = props.BackgroundTransparency or 1,
		BorderSizePixel = 0,
		ClipsDescendants = props.ClipsDescendants,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position or v3,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex,
		children = props.children
	})
end

return Frame
