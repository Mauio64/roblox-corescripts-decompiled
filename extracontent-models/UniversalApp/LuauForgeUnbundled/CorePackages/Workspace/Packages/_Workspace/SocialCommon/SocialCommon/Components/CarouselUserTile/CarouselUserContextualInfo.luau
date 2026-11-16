local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Cryo")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.Constant.IconSize
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local text = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/AppCommonLib").Text

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/CarouselUserTile/Constants")

local v5 = { maxNumberOfLines = Constants.LINES_MAX, lineWidth = Constants.TILE_SIZE }

function LUAUFORGE_MODULE_GLOBALS_abj_CarouselUserContextualInfo(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local icon = joined.icon
	local label = joined.label
	local v6 = useStyle()
	local v7 = useTextSizeOffset()
	local theme = v6.Theme
	local font = v6.Font
	local font2 = label.font or font.CaptionBody
	local text2 = label.text

	local v8 = icon and joined.lineWidth - (iconSize.Small + 2) or joined.lineWidth

	local v9 = React.useMemo(function()
		return (math.min(
			(font.BaseSize * font2.RelativeSize + v7) * joined.maxNumberOfLines,
			text.GetTextHeight(text2 or "", font2.Font, font.BaseSize * font2.RelativeSize, v8)
		))
	end, {
		font2.Font,
		font.BaseSize,
		font2.RelativeSize,
		joined.maxNumberOfLines,
		text2,
		v7,
		v8
	})

	local createElement = React.createElement
	local v11 = {
		LayoutOrder = joined.layoutOrder,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}
	local v12 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 2)
		}),
		IconFrame = 0,
		ContextualText = 0
	}

	local v13 = if icon and icon.path then React.createElement(
		"Frame",
		{
			Size = UDim2.fromOffset(iconSize.Small, iconSize.Small),
			BackgroundTransparency = 1
		},
		{
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			ImageLabel = React.createElement(imageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Image = images[icon.path],
				ImageColor3 = icon.color or theme.IconDefault.Color,
				ImageTransparency = icon.transparency or theme.IconDefault.Transparency,
				Size = icon.size or UDim2.fromOffset(iconSize.Small, iconSize.Small),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		}
	) else nil
	v12.IconFrame = v13

	local v14 = if text2 then React.createElement(styledTextLabel, {
		layoutOrder = 2,
		size = UDim2.fromOffset(v8, v9),
		lineHeight = 1,
		text = text2,
		textXAlignment = Enum.TextXAlignment.Left,
		textYAlignment = Enum.TextYAlignment.Top,
		textTruncate = Enum.TextTruncate.AtEnd,
		fontStyle = font2,
		colorStyle = label.colorStyle or theme.SecondaryContent,
		fluidSizing = false,
		richText = false
	}) else nil
	v12.ContextualText = v14
	return createElement("Frame", v11, v12)
end

return LUAUFORGE_MODULE_GLOBALS_abj_CarouselUserContextualInfo
