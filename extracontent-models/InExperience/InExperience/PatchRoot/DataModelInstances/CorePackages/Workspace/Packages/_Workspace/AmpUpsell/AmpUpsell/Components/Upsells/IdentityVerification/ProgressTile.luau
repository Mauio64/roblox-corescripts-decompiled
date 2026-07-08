local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local UIBlox = require(Parent.UIBlox)
local Foundation = require(Parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local React = require(Parent.React)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

local function ProgressTile(t1: {[any]: any}) -- line: 24
	-- upvalues: useStyle (copy), React (copy), ImageSetLabel (copy), Images (copy), Loading (copy), IconSize (copy), StyledTextLabel (copy)
	local frameHeight = t1.frameHeight
	local layoutOrder = t1.layoutOrder
	local finished = t1.finished
	local progressText = t1.progressText
	local v17 = useStyle()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, frameHeight),
		LayoutOrder = layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		}),
		StatusIcon = if not finished then React.createElement(Loading, {
			size = IconSize.Small
		}) else React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, frameHeight, 0, frameHeight),
			ScaleType = Enum.ScaleType.Fit,
			Image = Images["icons/status/success"],
			ImageTransparency = v17.Theme.SystemPrimaryDefault.Transparency,
			ImageColor3 = v17.Theme.IconEmphasis.Color
		}),
		TextFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, -frameHeight - 12, 0, frameHeight)
		}, {
			ProgressText = React.createElement(StyledTextLabel, {
				lineHeight = 1,
				text = progressText,
				fontStyle = v17.Font.CaptionBody,
				colorStyle = v17.Theme.TextDefault,
				size = UDim2.new(1, 0, 1, 0),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center
			})
		})
	})
end

return ProgressTile
