local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Roact = require(AppChatParent.Roact)
local UIBlox = require(AppChatParent.UIBlox)
local Constants = require(AppChat.Constants)
local PlayButton = require(script.Parent.PlayButton)
local FitFrameVertical = require(AppChat.Components.ChatConversation.AssetCardComponents.FitFrameVertical)
local v8 = Roact.PureComponent:extend("BuyToPlay")

v8.defaultProps = {
	text = "Buy to play!",
	gamePrice = 100
}

function v8.render(p1) -- line: 26
	-- upvalues: UIBlox (copy), Roact (copy), FitFrameVertical (copy), Constants (copy), PlayButton (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 27
		-- upvalues: Roact (copy), FitFrameVertical (copy), Constants (copy), p1 (copy), PlayButton (copy)
		return Roact.createElement(FitFrameVertical, {
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 6)
		}, {
			gamePriceFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 16)
			}, {
				layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 4)
				}),
				robuxIcon = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(0, 16, 1, 0),
					Image = Constants.SmallRobuxIcon,
					ImageColor3 = p2.Theme.ContextualPrimaryDefault.Color
				}),
				priceLabel = Roact.createElement("TextLabel", {
					TextSize = 16,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, -16, 1, 0),
					Text = p1.props.gamePrice,
					TextColor3 = p2.Theme.ContextualPrimaryDefault.Color,
					TextXAlignment = Enum.TextXAlignment.Left,
					Font = Enum.Font.Gotham
				})
			}),
			playButton = Roact.createElement(PlayButton, {
				LayoutOrder = 2,
				placeId = p1.placeId,
				text = p1.props.text
			})
		})
	end)
end

return v8
