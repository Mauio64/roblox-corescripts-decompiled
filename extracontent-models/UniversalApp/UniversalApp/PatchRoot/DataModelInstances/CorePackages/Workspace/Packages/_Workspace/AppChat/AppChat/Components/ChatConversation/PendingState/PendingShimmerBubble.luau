local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local UIBlox = require(AppChatParent.UIBlox)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local useStyle = UIBlox.Core.Style.useStyle
local t1 = {
	addTopPadding = false,
	addBottomPadding = false,
	backgroundTransparency = 0.4,
	heightFactor = 1,
	isIncoming = false,
	showAvatarCircle = false,
	widthPercentage = 0.5
}

local function PendingShimmerBubble(t2: {[any]: any}) -- line: 39
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useChatPagePadding (copy), React (copy)
	local v11 = Cryo.Dictionary.join(t1, t2)
	local v12 = useStyle()
	local v13 = v11.style or v12
	local v14 = if not v11.addBottomPadding then v13.Tokens.Size.Size_100 else v13.Tokens.Size.Size_600
	local Size_900 = v13.Tokens.Size.Size_900
	local UIDefaultColor = v13.Theme.UIDefault.Color
	local v17 = useChatPagePadding()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = if not v11.isIncoming then Enum.HorizontalAlignment.Right else Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, v13.Tokens.Size.Size_100)
		}),
		ContentPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v17.left),
			PaddingRight = UDim.new(0, v17.right),
			PaddingBottom = UDim.new(0, v14),
			PaddingTop = if not v11.addTopPadding then nil else UDim.new(0, v13.Tokens.Size.Size_600)
		}),
		IncomingFrame = if not v11.isIncoming then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(0, Size_900, 0, Size_900)
		}, {
			AvatarCircleShimmer = if not v11.showAvatarCircle then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 1,
				BackgroundTransparency = v11.backgroundTransparency,
				BackgroundColor3 = UIDefaultColor,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, v13.Tokens.Radius.Circle)
				})
			})
		}),
		ShimmerBubble = React.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 2,
			BackgroundTransparency = v11.backgroundTransparency,
			BackgroundColor3 = UIDefaultColor,
			Size = UDim2.new(v11.widthPercentage, 0, 0, v11.heightFactor * v13.Tokens.Size.Size_500 + v13.Tokens.Size.Size_400)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v13.Tokens.Size.Size_300)
			}),
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(800 * v11.widthPercentage, 1000)
			})
		})
	})
end

return PendingShimmerBubble
