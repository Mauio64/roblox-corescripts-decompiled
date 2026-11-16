require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")
local useStyle = UIBlox.Core.Style.useStyle

local v5 = {
	addTopPadding = false,
	addBottomPadding = false,
	backgroundTransparency = 0.4,
	heightFactor = 1,
	isIncoming = false,
	showAvatarCircle = false,
	widthPercentage = 0.5
}

local function PendingShimmerBubble(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()
	local style = joined.style or v6

	local v7 = if joined.addBottomPadding then style.Tokens.Size.Size_600 else style.Tokens.Size.Size_100
	local size_900 = style.Tokens.Size.Size_900
	local color = style.Theme.UIDefault.Color
	local v8 = useChatPagePadding()

	local createElement = React.createElement
	local v10 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local createElement2 = React.createElement
	local v12 = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = 0,
		SortOrder = 0,
		VerticalAlignment = 0,
		Padding = 0
	}
	local v13 = if joined.isIncoming then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Right
	v12.HorizontalAlignment = v13

	v12.SortOrder = Enum.SortOrder.LayoutOrder
	v12.VerticalAlignment = Enum.VerticalAlignment.Bottom
	v12.Padding = UDim.new(0, style.Tokens.Size.Size_100)
	local children = {
		UIListLayout = createElement2("UIListLayout", v12),
		ContentPadding = 0,
		IncomingFrame = 0,
		ShimmerBubble = 0
	}

	local createElement3 = React.createElement
	local v15 = {
		PaddingLeft = UDim.new(0, v8.left),
		PaddingRight = UDim.new(0, v8.right),
		PaddingBottom = UDim.new(0, v7),
		PaddingTop = 0
	}
	local v16 = if joined.addTopPadding then UDim.new(0, style.Tokens.Size.Size_600) else nil
	v15.PaddingTop = v16
	children.ContentPadding = createElement3("UIPadding", v15)
	local v17

	if joined.isIncoming then
		local createElement4 = React.createElement
		local v19 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, size_900, 0, size_900),
			LayoutOrder = 1
		}

		local v21 = if joined.showAvatarCircle then React.createElement("Frame", {
			BackgroundTransparency = joined.backgroundTransparency,
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = 1
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, style.Tokens.Radius.Circle)
			})
		}) else nil
		v17 = createElement4("Frame", v19, { AvatarCircleShimmer = v21 })
	end

	children.IncomingFrame = v17

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
	return createElement("Frame", v10, children)
end

return PendingShimmerBubble
