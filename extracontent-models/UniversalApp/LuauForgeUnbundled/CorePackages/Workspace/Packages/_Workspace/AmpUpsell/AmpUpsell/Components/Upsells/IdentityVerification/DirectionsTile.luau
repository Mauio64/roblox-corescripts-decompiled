local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconSize = UIBlox.App.Constant.IconSize
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local styledTextLabel = UIBlox.App.Text.StyledTextLabel

return function(props)
	local v5 = useStyle()

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
			ImageIcon = React.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, iconSize.Large, 0, iconSize.Large),
				ScaleType = Enum.ScaleType.Fit,
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Image = images[props.imagePath],
				ImageTransparency = v5.Theme.SystemPrimaryDefault.Transparency
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
					Header = React.createElement(styledTextLabel, {
						text = props.headerText,
						fontStyle = v5.Font.Header2,
						colorStyle = v5.Theme.TextEmphasis,
						size = UDim2.new(1, 0, 0.5, 0),
						lineHeight = 1,
						textTruncate = Enum.TextTruncate.AtEnd,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						layoutOrder = 1
					}),
					Body = React.createElement(styledTextLabel, {
						text = props.descriptionText,
						fontStyle = v5.Font.CaptionBody,
						colorStyle = v5.Theme.TextDefault,
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
