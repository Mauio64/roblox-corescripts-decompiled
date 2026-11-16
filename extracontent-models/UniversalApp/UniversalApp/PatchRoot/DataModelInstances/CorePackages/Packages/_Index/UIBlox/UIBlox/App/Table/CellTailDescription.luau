local parent = script.Parent.Parent
local parent2 = parent.Parent
local core = parent2.Core
local parent3 = parent2.Parent

local t = require(parent3.t)
local validateColorInfo = require(core.Style.Validator.validateColorInfo)
local validateFontInfo = require(core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(core.Style.Validator.validateTypographyInfo)

local Roact = require(parent3.Roact)
local React = require(parent3.React)
local withStyle = require(core.Style.withStyle)
local GenericTextLabel = require(parent2.Core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local IconSize = require(parent.ImageSet.Enum.IconSize)
local getIconSize = require(parent.ImageSet.getIconSize)
local Images = require(parent.ImageSet.Images)
local UIBloxConfig = require(parent2.UIBloxConfig)

local extended = Roact.PureComponent:extend("CellTailDescription")

extended.validateProps = t.strictInterface({
	text = t.optional(t.string),
	textColor = t.optional(validateColorInfo),
	textFont = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	renderTextOverride = t.optional(t.callback),
	showArrow = t.optional(t.boolean),
	infoIcon = t.optional(t.string),
	testId = t.optional(t.string)
})

extended.defaultProps = {
	showArrow = false,
	infoIcon = nil,
	testId = "--uiblox-cell-tail-description"
}

function extended:init()
	function self.getDescription(text, colorStyle, fontStyle, layoutOrder, callback)
		local v = nil

		if text then
			if callback then
				v = callback()
			end

			return v or Roact.createElement(GenericTextLabel, {
				LayoutOrder = layoutOrder,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = text,
				colorStyle = colorStyle,
				fontStyle = fontStyle,
				BackgroundTransparency = 1
			})
		end

		return v
	end
end

function extended.render(p)
	local text = p.props.text
	local renderTextOverride = p.props.renderTextOverride
	local showArrow = p.props.showArrow
	local v = p.props.infoIcon ~= nil

	if text or showArrow or v then
		return withStyle(function(p2)
			local textColor = p.props.textColor or p2.Theme.TextDefault
			local textFont = p.props.textFont or p2.Font.Body

			local createElement = Roact.createElement
			local v2 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY
			}
			local tag = React.Tag
			local v3

			if p.props.testId then
				v3 = `data-testid={p.props.testId}`
			end

			v2[tag] = v3
			local v4 = {
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 8)
				}),
				Description = p.getDescription(text, textColor, textFont, 1, renderTextOverride),
				RightArrow = 0,
				InfoIcon = 0
			}
			local rightArrow

			if showArrow then
				local createElement2 = Roact.createElement
				local label = ImageSetComponent.Label
				local size

				if UIBloxConfig.enableScalingForSomeEdpIcons then
					size = UDim2.fromOffset(getIconSize(IconSize.Small, p2), getIconSize(IconSize.Small, p2))
				else
					size = UDim2.fromOffset(getIconSize(IconSize.Small), getIconSize(IconSize.Small))
				end

				rightArrow = createElement2(label, {
					LayoutOrder = 2,
					Size = size,
					BackgroundTransparency = 1,
					Image = Images["icons/navigation/pushRight_small"],
					ImageColor3 = p2.Theme.TextEmphasis.Color,
					ImageTransparency = p2.Theme.TextEmphasis.Transparency
				}) or nil
			end

			v4.RightArrow = rightArrow
			local infoIcon

			if v then
				local createElement2 = Roact.createElement
				local label = ImageSetComponent.Label
				local size

				if UIBloxConfig.enableScalingForSomeEdpIcons then
					size = UDim2.fromOffset(getIconSize(IconSize.Small, p2), getIconSize(IconSize.Small, p2))
				else
					size = UDim2.fromOffset(getIconSize(IconSize.Small), getIconSize(IconSize.Small))
				end

				infoIcon = createElement2(label, {
					LayoutOrder = 2,
					Size = size,
					Image = p.props.infoIcon,
					ImageColor3 = p2.Theme.IconEmphasis.Color,
					ImageTransparency = p2.Theme.IconEmphasis.Transparency,
					BorderSizePixel = 0,
					BackgroundTransparency = 1
				}) or nil
			end

			v4.InfoIcon = infoIcon
			return createElement("Frame", v2, v4)
		end)
	end

	return nil
end

return extended
