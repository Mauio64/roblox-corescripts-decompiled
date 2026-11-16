local parent = script:FindFirstAncestor("AmpUpsell").Parent
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local React = require(parent.React)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

local function ProgressTile(props)
	local frameHeight = props.frameHeight
	local layoutOrder = props.layoutOrder
	local finished = props.finished
	local progressText = props.progressText
	local v = useStyle()

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(1, 0, 0, frameHeight),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}

	local v3 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		}),
		StatusIcon = 0,
		TextFrame = 0
	}
	local statusIcon

	if finished then
		statusIcon = React.createElement(ImageSetLabel, {
			Size = UDim2.new(0, frameHeight, 0, frameHeight),
			ScaleType = Enum.ScaleType.Fit,
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Image = Images["icons/status/success"],
			ImageTransparency = v.Theme.SystemPrimaryDefault.Transparency,
			ImageColor3 = v.Theme.IconEmphasis.Color
		})
	else
		statusIcon = React.createElement(Loading, { size = IconSize.Small })
	end

	v3.StatusIcon = statusIcon

	v3.TextFrame = React.createElement("Frame", {
		Size = UDim2.new(1, -frameHeight - 12, 0, frameHeight),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}, {
		ProgressText = React.createElement(StyledTextLabel, {
			text = progressText,
			fontStyle = v.Font.CaptionBody,
			colorStyle = v.Theme.TextDefault,
			size = UDim2.new(1, 0, 1, 0),
			lineHeight = 1,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Center
		})
	})
	return createElement("Frame", v2, v3)
end

return ProgressTile
