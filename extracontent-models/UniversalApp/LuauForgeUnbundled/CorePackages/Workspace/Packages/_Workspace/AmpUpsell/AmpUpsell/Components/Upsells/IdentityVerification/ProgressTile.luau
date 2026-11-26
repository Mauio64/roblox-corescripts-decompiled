local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local styledTextLabel = UIBlox.App.Text.StyledTextLabel

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

local function ProgressTile(props)
	local frameHeight = props.frameHeight
	local layoutOrder = props.layoutOrder
	local finished = props.finished
	local progressText = props.progressText
	local v5 = useStyle()

	local createElement = React.createElement
	local v7 = {
		Size = UDim2.new(1, 0, 0, frameHeight),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}

	local v8 = {
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

	local v9 = if finished then React.createElement(imageSetLabel, {
		Size = UDim2.new(0, frameHeight, 0, frameHeight),
		ScaleType = Enum.ScaleType.Fit,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Image = images["icons/status/success"],
		ImageTransparency = v5.Theme.SystemPrimaryDefault.Transparency,
		ImageColor3 = v5.Theme.IconEmphasis.Color
	}) else React.createElement(loading, { size = iconSize.Small })
	v8.StatusIcon = v9

	v8.TextFrame = React.createElement("Frame", {
		Size = UDim2.new(1, -frameHeight - 12, 0, frameHeight),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}, {
		ProgressText = React.createElement(styledTextLabel, {
			text = progressText,
			fontStyle = v5.Font.CaptionBody,
			colorStyle = v5.Theme.TextDefault,
			size = UDim2.new(1, 0, 1, 0),
			lineHeight = 1,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Center
		})
	})
	return createElement("Frame", v7, v8)
end

return ProgressTile
