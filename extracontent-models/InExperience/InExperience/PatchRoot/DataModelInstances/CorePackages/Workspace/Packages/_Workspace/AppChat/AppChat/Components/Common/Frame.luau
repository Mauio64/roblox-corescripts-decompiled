local AppChat = script:FindFirstAncestor("AppChat")
local React = require(AppChat.Parent.React)
local t1 = {
	[Enum.HorizontalAlignment.Center] = {
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
	},
	[Enum.HorizontalAlignment.Left] = {
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
	},
	[Enum.HorizontalAlignment.Right] = {
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
}

local function Frame(t2: {[any]: any}) -- line: 36
	-- upvalues: React (copy), t1 (copy)
	local v6, v7 = React.useMemo(function() -- line: 37
		-- upvalues: t2 (copy), t1 (copy)
		if t2.horizontalAlignment and t2.verticalAlignment then
			return t1[t2.horizontalAlignment][t2.verticalAlignment].anchor, t1[t2.horizontalAlignment][t2.verticalAlignment].position
		end

		return nil, nil
	end, {
		t2.horizontalAlignment,
		t2.verticalAlignment
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		AnchorPoint = t2.AnchorPoint or v6,
		BackgroundColor3 = t2.BackgroundColor3,
		BackgroundTransparency = t2.BackgroundTransparency or 1,
		ClipsDescendants = t2.ClipsDescendants,
		LayoutOrder = t2.LayoutOrder,
		Position = t2.Position or v7,
		Size = t2.Size or UDim2.fromScale(1, 1),
		ZIndex = t2.ZIndex,
		children = t2.children
	})
end

return Frame
