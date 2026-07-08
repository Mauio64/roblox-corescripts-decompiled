local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local UIBlox = require(Parent.UIBlox)
local React = require(Parent.React)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useStyle (copy), React (copy), ImageSetLabel (copy), IconSize (copy), Images (copy), StyledTextLabel (copy)
	local v10 = useStyle()
	local frameHeight = t1.frameHeight

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, frameHeight),
		LayoutOrder = t1.layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		ImageIcon = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, IconSize.Large, 0, IconSize.Large),
			ScaleType = Enum.ScaleType.Fit,
			Image = Images[t1.imagePath],
			ImageTransparency = v10.Theme.SystemPrimaryDefault.Transparency
		}),
		TextFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, -48, 0, frameHeight)
		}, {
			TextLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Header = React.createElement(StyledTextLabel, {
				lineHeight = 1,
				layoutOrder = 1,
				text = t1.headerText,
				fontStyle = v10.Font.Header2,
				colorStyle = v10.Theme.TextEmphasis,
				size = UDim2.new(1, 0, 0.5, 0),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center
			}),
			Body = React.createElement(StyledTextLabel, {
				lineHeight = 1,
				layoutOrder = 2,
				text = t1.descriptionText,
				fontStyle = v10.Font.CaptionBody,
				colorStyle = v10.Theme.TextDefault,
				size = UDim2.new(1, 0, 0.5, 0),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center
			})
		})
	})
end
