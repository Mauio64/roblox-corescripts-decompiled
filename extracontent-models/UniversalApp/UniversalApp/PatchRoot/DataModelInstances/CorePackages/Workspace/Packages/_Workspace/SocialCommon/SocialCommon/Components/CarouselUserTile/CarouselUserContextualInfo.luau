local Parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local UIBlox = require(Parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Text = require(Parent.AppCommonLib).Text
local Constants = require(script.Parent.Constants)
local t1 = {
	maxNumberOfLines = Constants.LINES_MAX,
	lineWidth = Constants.TILE_SIZE
}

function CarouselUserContextualInfo(t2: {[any]: any}) -- line: 51
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useTextSizeOffset (copy), IconSize (copy), React (copy), Text (copy), ImageSetLabel (copy), Images (copy), StyledTextLabel (copy)
	local v15 = Cryo.Dictionary.join(t1, t2)
	local icon = v15.icon
	local label = v15.label
	local v18 = useStyle()
	local v19 = useTextSizeOffset()
	local Theme = v18.Theme
	local Font = v18.Font
	local v22 = label.font or Font.CaptionBody
	local text = label.text
	local v24 = icon and v15.lineWidth - (IconSize.Small + 2) or v15.lineWidth
	local v25 = React.useMemo(function() -- line: 64
		-- upvalues: Font (copy), v22 (copy), v19 (copy), v15 (copy), Text (copy), text (copy), v24 (copy)
		return (math.min((Font.BaseSize * v22.RelativeSize + v19) * v15.maxNumberOfLines, Text.GetTextHeight(text or "", v22.Font, Font.BaseSize * v22.RelativeSize, v24)))
	end, {
		v22.Font,
		Font.BaseSize,
		v22.RelativeSize,
		v15.maxNumberOfLines,
		text,
		v19,
		v24
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = v15.layoutOrder,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 2)
		}),
		IconFrame = if not icon or not icon.path then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(IconSize.Small, IconSize.Small)
		}, {
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			ImageLabel = React.createElement(ImageSetLabel, {
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
		ContextualText = if not text then nil else React.createElement(StyledTextLabel, {
			layoutOrder = 2,
			lineHeight = 1,
			fluidSizing = false,
			richText = false,
			size = UDim2.fromOffset(v24, v25),
			text = text,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Top,
			textTruncate = Enum.TextTruncate.AtEnd,
			fontStyle = v22,
			colorStyle = label.colorStyle or Theme.SecondaryContent
		})
	})
end

return CarouselUserContextualInfo
