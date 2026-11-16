local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/ReactRoblox")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local v5 = {
	anchorPoint = Vector2.new(),
	position = UDim2.new(),
	color = Color3.fromHex("#fff"),
	font = Enum.Font.Gotham,
	size = UDim2.fromScale(1, 0),
	automaticSize = Enum.AutomaticSize.XY,
	verticalAlignment = Enum.VerticalAlignment.Center
}

local function EmojiWrapper(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	if joined.children then
		assert(React.Children.count(joined.children) <= 1, "EmojiWrapper can only contain one child")
	end

	if joined.emoji == "" then
		return joined.children
	end

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(-1)

	local v6 = React.useCallback(function(p3)
		local v7

		if joined.maximumEmojiSize then
			v7 = math.min(p3.AbsoluteSize.Y, joined.maximumEmojiSize)
		else
			v7 = p3.AbsoluteSize.Y
		end

		if v7 ~= state2 then
			setState2(state)
			setState(v7)
		end
	end, { state, state2 })

	local createElement = React.createElement
	local v8 = {
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
				[ReactRoblox.Change.AbsoluteSize] = v6
			},
			{
				Padding = React.createElement("UIPadding", {
					PaddingRight = UDim.new(0, state)
				}),
				Children = React.createElement(React.Fragment, nil, joined.children)
			}
		),
		Emoji = 0
	}

	local createElement3 = React.createElement
	local v11 = {
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
	local v12 = if not foundationFontFaceMigration then joined.font else nil
	v11.Font = v12
	local v13 = if foundationFontFaceMigration then normalizeFontFace(joined.font) else nil
	v11.FontFace = v13
	v11.TextColor3 = joined.color
	v11.TextSize = state

	v11.TextYAlignment = Enum.TextYAlignment.Center
	v11.TextXAlignment = Enum.TextXAlignment.Center
	v11.Size = UDim2.fromOffset(state, state)

	local v15 = p2.onActivated

	if v15 then
		v15 = React.createElement("ImageButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[ReactRoblox.Event.Activated] = p2.onActivated
		})
	end

	children.Emoji = createElement3("TextLabel", v11, {
		Button = v15,
		UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
			MaxTextSize = math.max(state, 1),
			MinTextSize = 0
		})
	})
	return createElement("Frame", v8, children)
end

return EmojiWrapper
