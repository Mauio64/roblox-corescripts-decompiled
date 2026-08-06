local Parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local UIBlox = require(Parent.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local Text = require(Parent.AppCommonLib).Text
local t1 = {
	width = require(script.Parent.Constants).TILE_SIZE
}

return function(t2: {[any]: any}) -- line: 25
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), Text (copy), StyledTextLabel (copy)
	local v10 = Cryo.Dictionary.join(t1, t2)
	local v11 = useStyle()
	local Theme = v11.Theme
	local Font = v11.Font
	local v14 = React.useMemo(function() -- line: 32
		-- upvalues: Text (copy), v10 (copy), Font (copy)
		return Text.GetTextHeight(v10.name, Font.CaptionHeader.Font, Font.BaseSize * Font.CaptionHeader.RelativeSize, 10000)
	end, {
		v10.name,
		Font.CaptionHeader.Font,
		Font.BaseSize * Font.CaptionHeader.RelativeSize
	})

	return React.createElement(StyledTextLabel, {
		lineHeight = 1,
		fluidSizing = false,
		richText = true,
		layoutOrder = v10.layoutOrder,
		text = v10.name,
		fontStyle = Font.CaptionHeader,
		colorStyle = Theme.TextEmphasis,
		size = UDim2.fromOffset(v10.width, v14),
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Left,
		textYAlignment = Enum.TextYAlignment.Center
	})
end
