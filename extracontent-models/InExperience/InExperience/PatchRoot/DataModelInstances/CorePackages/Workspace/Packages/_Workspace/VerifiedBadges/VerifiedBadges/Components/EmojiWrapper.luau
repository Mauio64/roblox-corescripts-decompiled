local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")

local Cryo = require(VerifiedBadges.Parent.Cryo)
local Foundation = require(VerifiedBadges.Parent.Foundation)
local React = require(VerifiedBadges.Parent.React)
local ReactRoblox = require(VerifiedBadges.Parent.ReactRoblox)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local v = {
	anchorPoint = Vector2.new(),
	position = UDim2.new(),
	color = Color3.fromHex("#fff"),
	font = Enum.Font.Gotham,
	size = UDim2.fromScale(1, 0),
	automaticSize = Enum.AutomaticSize.XY,
	verticalAlignment = Enum.VerticalAlignment.Center
}

local function EmojiWrapper(p)
	local joined = Cryo.Dictionary.join(v, p)

	if joined.children then
		assert(React.Children.count(joined.children) <= 1, "EmojiWrapper can only contain one child")
	end

	if joined.emoji == "" then
		return joined.children
	end

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(-1)

	local v2 = React.useCallback(function(p2)
		local v2

		if joined.maximumEmojiSize then
			v2 = math.min(p2.AbsoluteSize.Y, joined.maximumEmojiSize)
		else
			v2 = p2.AbsoluteSize.Y
		end

		if v2 ~= state2 then
			setState2(state)
			setState(v2)
		end
	end, { state, state2 })

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = joined.layoutOrder,
		AnchorPoint = joined.anchorPoint,
		Position = joined.position,
		Size = joined.size,
		AutomaticSize = joined.automaticSize,
		BackgroundTransparency = 1
	}

	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = joined.horizontalAlignment,
			VerticalAlignment = joined.verticalAlignment,
			Padding = UDim.new(0, -state)
		}),
		ChildrenWrapper = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				[ReactRoblox.Change.AbsoluteSize] = v2
			},
			{
				Padding = React.createElement("UIPadding", { PaddingRight = UDim.new(0, state) }),
				Children = React.createElement(React.Fragment, nil, joined.children)
			}
		),
		Emoji = 0
	}

	local createElement2 = React.createElement
	local v4 = {
		LayoutOrder = 2,
		Text = joined.emoji,
		Font = 0,
		FontFace = 0,
		TextColor3 = 0,
		TextSize = 0,
		BackgroundTransparency = 1,
		TextYAlignment = 0,
		TextXAlignment = 0,
		Size = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = joined.font
	end

	v4.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(joined.font)
	end

	v4.FontFace = fontFace
	v4.TextColor3 = joined.color
	v4.TextSize = state

	v4.TextYAlignment = Enum.TextYAlignment.Center
	v4.TextXAlignment = Enum.TextXAlignment.Center
	v4.Size = UDim2.fromOffset(state, state)

	local button = p.onActivated

	if button then
		button = React.createElement("ImageButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[ReactRoblox.Event.Activated] = p.onActivated
		})
	end

	children.Emoji = createElement2("TextLabel", v4, {
		Button = button,
		UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
			MaxTextSize = math.max(state, 1),
			MinTextSize = 0
		})
	})
	return createElement("Frame", v3, children)
end

return EmojiWrapper
