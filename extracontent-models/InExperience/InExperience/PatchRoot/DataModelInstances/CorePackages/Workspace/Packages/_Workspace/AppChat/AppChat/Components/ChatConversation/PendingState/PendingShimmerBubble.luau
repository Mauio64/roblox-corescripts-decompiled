local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local useStyle = UIBlox.Core.Style.useStyle

local v = {
	addTopPadding = false,
	addBottomPadding = false,
	backgroundTransparency = 0.4,
	heightFactor = 1,
	isIncoming = false,
	showAvatarCircle = false,
	widthPercentage = 0.5
}

local function PendingShimmerBubble(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local style = joined.style or v2
	local v3

	if joined.addBottomPadding then
		v3 = style.Tokens.Size.Size_600
	else
		v3 = style.Tokens.Size.Size_100
	end

	local size_900 = style.Tokens.Size.Size_900
	local color = style.Theme.UIDefault.Color
	local v4 = useChatPagePadding()

	local createElement = React.createElement
	local v5 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local createElement2 = React.createElement
	local v6 = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = 0,
		SortOrder = 0,
		VerticalAlignment = 0,
		Padding = 0
	}
	local horizontalAlignment

	if joined.isIncoming then
		horizontalAlignment = Enum.HorizontalAlignment.Left
	else
		horizontalAlignment = Enum.HorizontalAlignment.Right
	end

	v6.HorizontalAlignment = horizontalAlignment

	v6.SortOrder = Enum.SortOrder.LayoutOrder
	v6.VerticalAlignment = Enum.VerticalAlignment.Bottom
	v6.Padding = UDim.new(0, style.Tokens.Size.Size_100)
	local children = {
		UIListLayout = createElement2("UIListLayout", v6),
		ContentPadding = 0,
		IncomingFrame = 0,
		ShimmerBubble = 0
	}

	local createElement3 = React.createElement
	local v7 = {
		PaddingLeft = UDim.new(0, v4.left),
		PaddingRight = UDim.new(0, v4.right),
		PaddingBottom = UDim.new(0, v3),
		PaddingTop = 0
	}
	local paddingTop

	if joined.addTopPadding then
		paddingTop = UDim.new(0, style.Tokens.Size.Size_600)
	end

	v7.PaddingTop = paddingTop
	children.ContentPadding = createElement3("UIPadding", v7)
	local incomingFrame

	if joined.isIncoming then
		local createElement4 = React.createElement
		local v8 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, size_900, 0, size_900),
			LayoutOrder = 1
		}
		local avatarCircleShimmer

		if joined.showAvatarCircle then
			avatarCircleShimmer = React.createElement("Frame", {
				BackgroundTransparency = joined.backgroundTransparency,
				BackgroundColor3 = color,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				LayoutOrder = 1
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, style.Tokens.Radius.Circle)
				})
			})
		end

		incomingFrame = createElement4("Frame", v8, { AvatarCircleShimmer = avatarCircleShimmer })
	end

	children.IncomingFrame = incomingFrame

	children.ShimmerBubble = React.createElement("Frame", {
		BackgroundTransparency = joined.backgroundTransparency,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Size = UDim2.new(
			joined.widthPercentage,
			0,
			0,
			joined.heightFactor * style.Tokens.Size.Size_500 + style.Tokens.Size.Size_400
		),
		LayoutOrder = 2
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, style.Tokens.Size.Size_300)
		}),
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(800 * joined.widthPercentage, 1000)
		})
	})
	return createElement("Frame", v5, children)
end

return PendingShimmerBubble
