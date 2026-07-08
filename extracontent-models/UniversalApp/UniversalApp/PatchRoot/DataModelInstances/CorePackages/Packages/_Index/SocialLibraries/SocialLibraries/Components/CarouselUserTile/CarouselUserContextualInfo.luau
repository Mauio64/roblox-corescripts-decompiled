local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local llama = dependencies.llama
local UIBlox = dependencies.UIBlox
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local UIBloxStyle = UIBlox.Style
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local getTextHeight = require(script.Parent.getTextHeight)

require(script.Parent.StyleTypes)

local Constants = require(script.Parent.Constants)
local t1 = {
	maxNumberOfLines = Constants.LINES_MAX,
	lineWidth = Constants.TILE_SIZE
}

return function(t2: {[any]: any}) -- line: 46
	-- upvalues: llama (copy), t1 (copy), UIBloxStyle (copy), Roact (copy), IconSize (copy), ImageSetLabel (copy), Images (copy), StyledTextLabel (copy), getTextHeight (copy)
	local v15 = llama.Dictionary.join(t1, t2)
	local icon = v15.icon
	local label = v15.label

	return UIBloxStyle.withStyle(function(p1) -- line: 51
		-- upvalues: label (copy), Roact (copy), v15 (copy), icon (copy), IconSize (copy), ImageSetLabel (copy), Images (copy), StyledTextLabel (copy), getTextHeight (copy)
		local Theme = p1.Theme
		local p1Font = p1.Font
		local v21 = label.font or p1Font.CaptionBody
		local text = label.text

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = v15.layoutOrder
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 2)
			}),
			IconFrame = if not icon or not icon.path then nil else Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(IconSize.Small, IconSize.Small)
			}, {
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Top,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				ImageLabel = Roact.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Image = Images[icon.path],
					ImageColor3 = icon.color or Theme.IconDefault.Color,
					ImageTransparency = icon.transparency or Theme.IconDefault.Transparency,
					Size = icon.size or UDim2.fromOffset(IconSize.Small, IconSize.Small),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			}),
			ContextualText = if not text then nil else Roact.createElement(StyledTextLabel, {
				layoutOrder = 2,
				lineHeight = 1,
				fluidSizing = false,
				richText = false,
				size = UDim2.fromOffset(icon and v15.lineWidth - (IconSize.Small + 2) or v15.lineWidth, getTextHeight(text, v21.Font, p1Font.BaseSize * v21.RelativeSize) * v15.maxNumberOfLines),
				text = text,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Top,
				textTruncate = Enum.TextTruncate.AtEnd,
				fontStyle = v21,
				colorStyle = label.colorStyle or Theme.SecondaryContent
			})
		})
	end)
end
