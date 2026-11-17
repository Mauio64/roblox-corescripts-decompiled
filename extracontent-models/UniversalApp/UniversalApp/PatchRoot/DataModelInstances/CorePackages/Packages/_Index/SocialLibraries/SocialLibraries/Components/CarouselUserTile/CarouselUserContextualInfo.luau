local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local llama = dependencies.llama

local uiBlox = dependencies.UIBlox
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local style = uiBlox.Style
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local images = uiBlox.App.ImageSet.Images
local iconSize = uiBlox.App.Constant.IconSize

require(script.Parent.StyleTypes)
local Constants = require(script.Parent.Constants)

local v = { maxNumberOfLines = Constants.LINES_MAX, lineWidth = Constants.TILE_SIZE }

return function(p)
	local joined = llama.Dictionary.join(v, p)
	local icon = joined.icon
	local label = joined.label

	return style.withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font
		local font2 = label.font or font.CaptionBody
		local text = label.text

		local createElement = roact.createElement
		local v2 = { LayoutOrder = joined.layoutOrder, BackgroundTransparency = 1 }

		local v3 = {
			UIListLayout = roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 2)
			}),
			IconFrame = 0,
			ContextualText = 0
		}
		local iconFrame

		if icon and icon.path then
			iconFrame = roact.createElement(
				"Frame",
				{
					Size = UDim2.fromOffset(iconSize.Small, iconSize.Small),
					BackgroundTransparency = 1
				},
				{
					layout = roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					ImageLabel = roact.createElement(imageSetLabel, {
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
			)
		end

		v3.IconFrame = iconFrame
		local contextualText

		if text then
			contextualText = roact.createElement(styledTextLabel, {
				layoutOrder = 2,
				size = UDim2.fromOffset(
					icon and joined.lineWidth - (iconSize.Small + 2) or joined.lineWidth,
					font.BaseSize * font2.RelativeSize * joined.maxNumberOfLines
				),
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

		v3.ContextualText = contextualText
		return createElement("Frame", v2, v3)
	end)
end
