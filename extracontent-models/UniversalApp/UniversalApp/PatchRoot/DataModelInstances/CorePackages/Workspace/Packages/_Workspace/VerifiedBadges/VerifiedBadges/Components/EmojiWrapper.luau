local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")
local Cryo = require(VerifiedBadges.Parent.Cryo)
local React = require(VerifiedBadges.Parent.React)
local ReactRoblox = require(VerifiedBadges.Parent.ReactRoblox)
local t1 = {
	anchorPoint = Vector2.new(),
	position = UDim2.new(),
	color = Color3.fromHex("#fff"),
	font = Enum.Font.Gotham,
	size = UDim2.fromScale(1, 0),
	automaticSize = Enum.AutomaticSize.XY,
	verticalAlignment = Enum.VerticalAlignment.Center
}

local function EmojiWrapper(t2: {[any]: any}) -- line: 88
	-- upvalues: Cryo (copy), t1 (copy), React (copy), ReactRoblox (copy)
	local v8 = Cryo.Dictionary.join(t1, t2)

	if v8.children then
		assert(React.Children.count(v8.children) <= 1, "EmojiWrapper can only contain one child")
	end

	if v8.emoji == "" then
		return v8.children
	end

	local v9, v10 = React.useState(0)
	local v11, v12 = React.useState(-1)
	local v13 = React.useCallback(function(p1) -- line: 102
		-- upvalues: v8 (copy), v11 (copy), v12 (copy), v9 (copy), v10 (copy)
		local v15 = if not v8.maximumEmojiSize then p1.AbsoluteSize.Y else math.min(p1.AbsoluteSize.Y, v8.maximumEmojiSize)

		if v15 ~= v11 then
			v12(v9)
			v10(v15)
		end
	end, {
		v9,
		v11
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = v8.layoutOrder,
		AnchorPoint = v8.anchorPoint,
		Position = v8.position,
		Size = v8.size,
		AutomaticSize = v8.automaticSize
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = v8.horizontalAlignment,
			VerticalAlignment = v8.verticalAlignment,
			Padding = UDim.new(0, -v9)
		}),
		ChildrenWrapper = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			[ReactRoblox.Change.AbsoluteSize] = v13
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, v9)
			}),
			Children = React.createElement(React.Fragment, nil, v8.children)
		}),
		Emoji = React.createElement("TextLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Text = v8.emoji,
			Font = v8.font,
			TextColor3 = v8.color,
			TextSize = v9,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.fromOffset(v9, v9)
		}, {
			Button = t2.onActivated and React.createElement("ImageButton", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				[ReactRoblox.Event.Activated] = t2.onActivated
			}),
			UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
				MinTextSize = 0,
				MaxTextSize = math.max(v9, 1)
			})
		})
	})
end

return EmojiWrapper
