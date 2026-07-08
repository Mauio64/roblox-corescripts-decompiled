local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local Cryo = require(ParentParentParent.Cryo)
local t = require(ParentParentParent.t)
local GetTextSize = require(ParentParent.Core.Text.GetTextSize)
local validateFontInfo = require(ParentParent.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(ParentParent.Core.Style.Validator.validateTypographyInfo)
local validateColorInfo = require(ParentParent.Core.Style.Validator.validateColorInfo)
local validateColorToken = require(ParentParent.Core.Style.Validator.validateColorToken)
local withStyle = require(ParentParent.Core.Style.withStyle)
local UIBloxConfig = require(ParentParent.UIBloxConfig)
local v13 = Roact.PureComponent:extend("GenericTextLabel")

v13.validateProps = t.interface({
	maxSize = t.optional(t.Vector2),
	fontStyle = t.union(validateFontInfo, validateTypographyInfo),
	colorStyle = t.union(validateColorInfo, validateColorToken),
	fluidSizing = t.optional(t.boolean),
	openTypeFeatures = t.optional(t.string)
})
v13.defaultProps = {
	fluidSizing = false,
	openTypeFeatures = nil,
	maxSize = Vector2.new(10000, 10000)
}

function v13.render(p1) -- line: 48
	-- upvalues: withStyle (copy), GetTextSize (copy), Cryo (copy), Roact (copy), UIBloxConfig (copy)
	local propsText = p1.props.Text
	local fluidSizing = p1.props.fluidSizing

	return withStyle(function(p2) -- line: 52
		-- upvalues: p1 (copy), propsText (copy), GetTextSize (copy), Cryo (copy), Roact (copy), fluidSizing (copy), UIBloxConfig (copy)
		local fontStyle = p1.props.fontStyle
		local colorStyle = p1.props.colorStyle
		local v20 = colorStyle.Color or colorStyle.Color3
		local colorStyleTransparency = colorStyle.Transparency
		local RichText = p1.props.RichText
		local BaseSize = p2.Font.BaseSize
		local v24 = if not fontStyle.RelativeMinSize then fontStyle.FontSize else BaseSize * fontStyle.RelativeMinSize
		local v25 = if not fontStyle.RelativeSize then fontStyle.FontSize else BaseSize * fontStyle.RelativeSize
		local fontStyleFont = fontStyle.Font
		local propsSize = p1.props.Size

		if propsSize == nil then
			local v28 = propsText

			if p1.props.TextTruncate == Enum.TextTruncate.AtEnd then
				v28 ..= "..."
			end

			local maxSize = p1.props.maxSize
			local v30 = if not p1.props.LineHeight then v25 else v25 * p1.props.LineHeight
			local v31 = GetTextSize(v28, v30, fontStyleFont, maxSize)

			propsSize = UDim2.new(0, v31.X, 0, v31.Y)
		end

		local v32 = if p1.props.AutomaticSize ~= nil and p1.props.AutomaticSize ~= Enum.AutomaticSize.None then nil else propsSize
		local v33 = p1.props.TextSize or v25
		local v34 = p1.props.AutomaticSize or nil
		local v35 = Cryo.Dictionary.join(p1.props, {
			[Roact.Children] = Cryo.None,
			fluidSizing = Cryo.None,
			fontStyle = Cryo.None,
			openTypeFeatures = Cryo.None,
			colorStyle = Cryo.None,
			maxSize = Cryo.None,
			Size = v32,
			Text = propsText,
			Font = fontStyleFont,
			TextSize = v33,
			AutomaticSize = v34,
			TextColor3 = v20,
			TextTransparency = colorStyleTransparency,
			TextWrapped = p1.props.TextWrapped == nil or p1.props.TextWrapped,
			TextScaled = fluidSizing,
			BackgroundTransparency = 1,
			RichText = RichText
		})

		if UIBloxConfig.enableOpenTypeSupport and p1.props.openTypeFeatures then
			v35 = Cryo.Dictionary.join(v35, {
				OpenTypeFeatures = p1.props.openTypeFeatures
			})
		end

		return Roact.createElement("TextLabel", v35, Cryo.Dictionary.join({
			UITextSizeConstraint = fluidSizing and Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = v25,
				MinTextSize = v24
			} or nil)
		}, p1.props[Roact.Children] or {}))
	end)
end

return v13
