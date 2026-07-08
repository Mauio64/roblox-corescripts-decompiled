local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local Text = require(Parent.AppCommonLib).Text
local AppFonts = require(Parent.Style).AppFonts
local withStyle = require(Parent.UIBlox).Style.withStyle
local v6 = Roact.PureComponent:extend("ChatDisabledIndicator")

v6.defaultProps = {
	LayoutOrder = 1,
	chatEnabled = false,
	chatDisabledText = "TRANSLATED To chat with your friends, turn on chat in your Privacy Settings.",
	privacyButtonText = "TRANSLATED Privacy Settings",
	privacyButtonEnabled = true,
	navigateToPrivacy = function() -- line: 18
	end
}

function v6.render(p1) -- line: 22
	-- upvalues: withStyle (copy), Text (copy), AppFonts (copy), Roact (copy)
	return withStyle(function(p2) -- line: 23
		-- upvalues: Text (copy), p1 (copy), AppFonts (copy), Roact (copy)
		local v9 = p2.Font.SubHeader1.RelativeSize * p2.Font.BaseSize
		local v10 = Text.GetTextWidth(p1.props.privacyButtonText, AppFonts.default:getDefault(), v9)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = p1.props.LayoutOrder
		}, {
			IndicatorInner = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 160),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}, {
				UIList = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Imagelabel = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = "rbxasset://textures/ui/LuaChat/icons/ic-friends.png",
					Size = UDim2.new(0, 72, 0, 72)
				}),
				DisabledMessage = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					TextWrapped = true,
					Font = AppFonts.default:getDefault(),
					TextColor3 = p2.Theme.TextDefault.Color,
					TextTransparency = p2.Theme.TextDefault.Transparency,
					TextSize = p2.Font.SubHeader1.RelativeSize * p2.Font.BaseSize,
					Size = UDim2.new(0.8, 0, 0.5, 0),
					Text = p1.props.chatDisabledText
				}),
				PrivacySettings = not p1.props.chatEnabled and (p1.props.privacyButtonEnabled and Roact.createElement("ImageButton", {
					AutoButtonColor = false,
					Size = UDim2.new(0, v10 + 6, 0, 36),
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					BorderSizePixel = 0,
					ScaleType = "Slice",
					SliceCenter = Rect.new(3, 3, 4, 4),
					Image = "rbxasset://textures/ui/LuaChat/9-slice/input-default.png",
					ImageColor3 = Color3.fromRGB(0, 176, 111),
					[Roact.Event.Activated] = p1.props.navigateToPrivacy
				}, {
					Textlabel = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Font = AppFonts.default:getDefault(),
						TextSize = v9,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						Text = p1.props.privacyButtonText,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center
					})
				}))
			})
		})
	end)
end

return v6
