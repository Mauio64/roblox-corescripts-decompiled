local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("InputHelpTextWithIcon")

function extended.render(p2)
	local helpText = p2.props.helpText
	local iconImage = p2.props.iconImage

	return withStyle(function(props)
		local v5 = props.Font.CaptionBody.RelativeSize * props.Font.BaseSize
		return Roact.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 0)
			},
			{
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Icon = Roact.createElement(imageSetLabel, {
					LayoutOrder = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = iconImage,
					ImageColor3 = props.Theme.SystemPrimaryDefault.Color,
					Size = UDim2.fromOffset(v5, v5)
				}),
				Text = Roact.createElement("TextLabel", {
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
					Size = UDim2.new(1, -v5, 0, 0),
					Text = helpText,
					TextColor3 = props.Theme.SystemPrimaryDefault.Color,
					TextSize = props.Font.CaptionBody.RelativeSize * props.Font.BaseSize,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 2)
					})
				})
			}
		)
	end)
end

return extended
