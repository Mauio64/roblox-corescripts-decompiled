local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local extended = Roact.PureComponent:extend("SendButton")

extended.defaultProps = {
	sendText = "Send",
	sentText = "Sent!",
	sendingText = "Sending..",
	failedText = "Failed",
	sentStatus = nil,
	isLoading = false,
	onActivated = function()
		return Promise.resolve()
	end
}

function extended.render(p2)
	return UIBlox.Style.withStyle(function(props)
		local v5

		if p2.props.sentStatus == "sent" then
			v5 = p2.props.sentText
		elseif p2.props.sentStatus == "sending" then
			v5 = p2.props.sendingText
		else
			v5 = if p2.props.sentStatus == "failed" then p2.props.failedText else p2.props.sendText
		end

		local v6 = props.Font.BaseSize * props.Font.Body.RelativeSize

		local x = getTextSize(v5, v6, props.Tokens.Typography.BodyLarge.Font, Vector2.new(10000, 10000)).X

		local element = Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) },
			{
				inactiveButton = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					TextSize = v6,
					TextColor3 = props.Theme.TextDefault.Color,
					TextTransparency = props.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Right,
					Text = v5
				})
			}
		)

		local v9 = Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0)
			},
			{
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				activeButton = Roact.createElement("ImageButton", {
					BackgroundTransparency = 1,
					ImageColor3 = props.Theme.SecondaryDefault.Color,
					ImageTransparency = props.Theme.SecondaryDefault.Transparency,
					Image = "rbxasset:///textures/ui/LuaDiscussions/buttonStroke.png",
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 8, 8),
					Size = UDim2.new(1, 0, 1, 0),
					[Roact.Event.Activated] = p2.props.onActivated
				}, {
					layout = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					interior = Roact.createElement(
						"Frame",
						{
							BackgroundColor3 = props.Theme.BackgroundUIDefault.Color,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(1, -2, 1, -2)
						},
						{
							layout = Roact.createElement("UIListLayout", {
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Center
							}),
							Label = Roact.createElement("TextLabel", {
								Size = UDim2.new(0, x, 0, v6),
								BackgroundTransparency = 1,
								Text = v5,
								FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
								TextSize = v6,
								TextColor3 = props.Theme.SecondaryContent.Color,
								TextTransparency = props.Theme.SecondaryContent.Transparency
							})
						}
					)
				})
			}
		)
		local v10

		if p2.props.isLoading then
			v10 = Roact.createElement(skeleton, {
				Size = UDim2.new(0, x + 14, 0, 32),
				radius = radius.Small
			})
		else
			local createElement3 = Roact.createElement
			local v12 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, x + 14, 0, 32)
			}
			local v13 = {
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				element = 0
			}

			v9 = p2.props.sentStatus and element or v9
			v13.element = v9
			v10 = createElement3("Frame", v12, v13) or Roact.createElement(skeleton, {
				Size = UDim2.new(0, x + 14, 0, 32),
				radius = radius.Small
			})
		end

		return v10
	end)
end

return extended
