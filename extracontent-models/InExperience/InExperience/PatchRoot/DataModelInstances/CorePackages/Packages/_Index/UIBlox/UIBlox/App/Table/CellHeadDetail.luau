local ParentParent = script.Parent.Parent.Parent
local Core = ParentParent.Core
local ParentParentParent = ParentParent.Parent
local t = require(ParentParentParent.t)
local validateColorInfo = require(Core.Style.Validator.validateColorInfo)
local validateFontInfo = require(Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(Core.Style.Validator.validateTypographyInfo)
local Roact = require(ParentParentParent.Roact)
local withStyle = require(Core.Style.withStyle)
local GenericTextLabel = require(ParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local v11 = Roact.PureComponent:extend("CellHeadDetail")

v11.validateProps = t.strictInterface({
	labelText = t.string,
	labelTextColor = t.optional(validateColorInfo),
	labelTextFont = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	subLabelText = t.optional(t.string),
	subLabelTextColor = t.optional(validateColorInfo),
	subLabelTextFont = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	openTypeFeatures = t.optional(t.string)
})

function v11.render(p1) -- line: 30
	-- upvalues: withStyle (copy), Roact (copy), GenericTextLabel (copy)
	return withStyle(function(p2) -- line: 31
		-- upvalues: p1 (copy), Roact (copy), GenericTextLabel (copy)
		local labelText = p1.props.labelText
		local v15 = p1.props.labelTextColor or p2.Theme.TextEmphasis
		local v16 = p1.props.labelTextFont or p2.Font.Header2
		local subLabelText = p1.props.subLabelText
		local v18 = p1.props.subLabelTextColor or p2.Theme.TextDefault
		local v19 = p1.props.subLabelTextFont or p2.Font.CaptionBody

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			Label = Roact.createElement(GenericTextLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = labelText,
				colorStyle = v15,
				fontStyle = v16,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			SubLabel = subLabelText and Roact.createElement(GenericTextLabel, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = subLabelText,
				colorStyle = v18,
				fontStyle = v19,
				openTypeFeatures = p1.props.openTypeFeatures,
				TextXAlignment = Enum.TextXAlignment.Left
			}) or nil
		})
	end)
end

return v11
