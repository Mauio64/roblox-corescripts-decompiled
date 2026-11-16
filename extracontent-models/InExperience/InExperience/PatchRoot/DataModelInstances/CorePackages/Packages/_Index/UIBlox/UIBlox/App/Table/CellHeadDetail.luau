local parent = script.Parent.Parent.Parent
local core = parent.Core
local parent2 = parent.Parent

local t = require(parent2.t)
local validateColorInfo = require(core.Style.Validator.validateColorInfo)
local validateFontInfo = require(core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(core.Style.Validator.validateTypographyInfo)

local Roact = require(parent2.Roact)
local withStyle = require(core.Style.withStyle)
local GenericTextLabel = require(parent.Core.Text.GenericTextLabel.GenericTextLabel)

local extended = Roact.PureComponent:extend("CellHeadDetail")

extended.validateProps = t.strictInterface({
	labelText = t.string,
	labelTextColor = t.optional(validateColorInfo),
	labelTextFont = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	subLabelText = t.optional(t.string),
	subLabelTextColor = t.optional(validateColorInfo),
	subLabelTextFont = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	openTypeFeatures = t.optional(t.string)
})

function extended.render(p)
	return withStyle(function(p2)
		local labelText = p.props.labelText
		local labelTextColor = p.props.labelTextColor or p2.Theme.TextEmphasis
		local labelTextFont = p.props.labelTextFont or p2.Font.Header2

		local subLabelText = p.props.subLabelText
		local subLabelTextColor = p.props.subLabelTextColor or p2.Theme.TextDefault
		local subLabelTextFont = p.props.subLabelTextFont or p2.Font.CaptionBody

		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY
			},
			{
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				Label = Roact.createElement(GenericTextLabel, {
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = labelText,
					colorStyle = labelTextColor,
					fontStyle = labelTextFont,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				SubLabel = subLabelText and Roact.createElement(GenericTextLabel, {
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = subLabelText,
					colorStyle = subLabelTextColor,
					fontStyle = subLabelTextFont,
					openTypeFeatures = p.props.openTypeFeatures,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left
				}) or nil
			}
		)
	end)
end

return extended
