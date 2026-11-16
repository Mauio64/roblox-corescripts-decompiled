local parent = script:FindFirstAncestor("AmpUpsell").Parent
local UIBlox = require(parent.UIBlox)
local React = require(parent.React)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

return function(props)
	local v = useStyle()

	local frameHeight = props.frameHeight

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, frameHeight),
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		},
		{
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			ImageIcon = React.createElement(ImageSetLabel, {
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, IconSize.Large, 0, IconSize.Large),
				ScaleType = Enum.ScaleType.Fit,
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Image = Images[props.imagePath],
				ImageTransparency = v.Theme.SystemPrimaryDefault.Transparency
			}),
			TextFrame = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -48, 0, frameHeight),
					LayoutOrder = 2
				},
				{
					TextLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					Header = React.createElement(StyledTextLabel, {
						text = props.headerText,
						fontStyle = v.Font.Header2,
						colorStyle = v.Theme.TextEmphasis,
						size = UDim2.new(1, 0, 0.5, 0),
						lineHeight = 1,
						textTruncate = Enum.TextTruncate.AtEnd,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						layoutOrder = 1
					}),
					Body = React.createElement(StyledTextLabel, {
						text = props.descriptionText,
						fontStyle = v.Font.CaptionBody,
						colorStyle = v.Theme.TextDefault,
						size = UDim2.new(1, 0, 0.5, 0),
						lineHeight = 1,
						textTruncate = Enum.TextTruncate.AtEnd,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						layoutOrder = 2
					})
				}
			)
		}
	)
end
