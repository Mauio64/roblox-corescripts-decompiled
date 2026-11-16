local parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text

local Constants = require(script.Parent.Constants)

local v = { maxNumberOfLines = Constants.LINES_MAX, lineWidth = Constants.TILE_SIZE }

function CarouselUserContextualInfo(p)
	local joined = Cryo.Dictionary.join(v, p)
	local icon = joined.icon
	local label = joined.label
	local v2 = useStyle()
	local v3 = useTextSizeOffset()
	local theme = v2.Theme
	local font = v2.Font
	local font2 = label.font or font.CaptionBody
	local text = label.text

	local v4 = icon and joined.lineWidth - (IconSize.Small + 2) or joined.lineWidth

	local v5 = React.useMemo(function()
		return (math.min(
			(font.BaseSize * font2.RelativeSize + v3) * joined.maxNumberOfLines,
			Text.GetTextHeight(text or "", font2.Font, font.BaseSize * font2.RelativeSize, v4)
		))
	end, { font2.Font, font.BaseSize, font2.RelativeSize, joined.maxNumberOfLines, text, v3, v4 })

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = joined.layoutOrder,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}
	local v7 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 2)
		}),
		IconFrame = 0,
		ContextualText = 0
	}
	local iconFrame

	if icon and icon.path then
		iconFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.fromOffset(IconSize.Small, IconSize.Small),
				BackgroundTransparency = 1
			},
			{
				layout = React.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Top,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				ImageLabel = React.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Image = Images[icon.path],
					ImageColor3 = icon.color or theme.IconDefault.Color,
					ImageTransparency = icon.transparency or theme.IconDefault.Transparency,
					Size = icon.size or UDim2.fromOffset(IconSize.Small, IconSize.Small),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			}
		)
	end

	v7.IconFrame = iconFrame
	local contextualText

	if text then
		contextualText = React.createElement(StyledTextLabel, {
			layoutOrder = 2,
			size = UDim2.fromOffset(v4, v5),
			lineHeight = 1,
			text = text,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Top,
			textTruncate = Enum.TextTruncate.AtEnd,
			fontStyle = font2,
			colorStyle = label.colorStyle or theme.SecondaryContent,
			fluidSizing = false,
			richText = false
		})
	end

	v7.ContextualText = contextualText
	return createElement("Frame", v6, v7)
end

return CarouselUserContextualInfo
