local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParentParent.Core
local ParentParentParentParent = ParentParentParent.Parent
local t = require(ParentParentParentParent.t)
local validateColorInfo = require(Core.Style.Validator.validateColorInfo)
local validateFontInfo = require(Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(Core.Style.Validator.validateTypographyInfo)
local Roact = require(ParentParentParentParent.Roact)
local React = require(ParentParentParentParent.React)
local withStyle = require(Core.Style.withStyle)
local GenericTextLabel = require(ParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local Images = require(ParentParent.ImageSet.Images)
local UIBloxConfig = require(ParentParentParent.UIBloxConfig)
local v18 = Roact.PureComponent:extend("CellTailDescription")

v18.validateProps = t.strictInterface({
	text = t.optional(t.string),
	textColor = t.optional(validateColorInfo),
	textFont = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	renderTextOverride = t.optional(t.callback),
	showArrow = t.optional(t.boolean),
	infoIcon = t.optional(t.string),
	testId = t.optional(t.string)
})
v18.defaultProps = {
	showArrow = false,
	infoIcon = nil,
	testId = "--uiblox-cell-tail-description"
}

function v18.init(p1) -- line: 44
	-- upvalues: Roact (copy), GenericTextLabel (copy)
	function p1.getDescription(p2, p3, p4, p5, p6) -- line: 45
		-- upvalues: Roact (copy), GenericTextLabel (copy)
		local v30 = nil

		if p2 then
			if p6 then
				v30 = p6()
			end

			if not v30 then
				v30 = Roact.createElement(GenericTextLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = p5,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = p2,
					colorStyle = p3,
					fontStyle = p4
				})
			end
		end

		return v30
	end
end
function v18.render(p7) -- line: 69
	-- upvalues: withStyle (copy), Roact (copy), React (copy), ImageSetComponent (copy), UIBloxConfig (copy), getIconSize (copy), IconSize (copy), Images (copy)
	local text = p7.props.text
	local renderTextOverride = p7.props.renderTextOverride
	local showArrow = p7.props.showArrow
	local v24 = p7.props.infoIcon ~= nil

	if not text and (not showArrow and not v24) then
		return nil
	end

	return withStyle(function(p8) -- line: 79
		-- upvalues: p7 (copy), Roact (copy), React (copy), text (copy), renderTextOverride (copy), showArrow (copy), ImageSetComponent (copy), UIBloxConfig (copy), getIconSize (copy), IconSize (copy), Images (copy), v24 (copy)
		local v32 = p7.props.textColor or p8.Theme.TextDefault
		local v33 = p7.props.textFont or p8.Font.Body

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			[React.Tag] = if not p7.props.testId then nil else `data-testid={ p7.props.testId }`
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 8)
			}),
			Description = p7.getDescription(text, v32, v33, 1, renderTextOverride),
			RightArrow = showArrow and Roact.createElement(ImageSetComponent.Label, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = if not UIBloxConfig.enableScalingForSomeEdpIcons then UDim2.fromOffset(getIconSize(IconSize.Small), getIconSize(IconSize.Small)) else UDim2.fromOffset(getIconSize(IconSize.Small, p8), getIconSize(IconSize.Small, p8)),
				Image = Images["icons/navigation/pushRight_small"],
				ImageColor3 = p8.Theme.TextEmphasis.Color,
				ImageTransparency = p8.Theme.TextEmphasis.Transparency
			}) or nil,
			InfoIcon = v24 and Roact.createElement(ImageSetComponent.Label, {
				LayoutOrder = 2,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = if not UIBloxConfig.enableScalingForSomeEdpIcons then UDim2.fromOffset(getIconSize(IconSize.Small), getIconSize(IconSize.Small)) else UDim2.fromOffset(getIconSize(IconSize.Small, p8), getIconSize(IconSize.Small, p8)),
				Image = p7.props.infoIcon,
				ImageColor3 = p8.Theme.IconEmphasis.Color,
				ImageTransparency = p8.Theme.IconEmphasis.Transparency
			}) or nil
		})
	end)
end

return v18
