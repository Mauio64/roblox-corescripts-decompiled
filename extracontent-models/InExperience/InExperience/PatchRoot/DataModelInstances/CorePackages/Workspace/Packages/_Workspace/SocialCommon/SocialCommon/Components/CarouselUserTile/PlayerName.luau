local Parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local UIBlox = require(Parent.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local Text = require(Parent.AppCommonLib).Text
local Constants = require(script.Parent.Constants)
local FFlagHomepagePYMKPresence = require(Parent.SharedFlags).FFlagHomepagePYMKPresence
local t1 = {
	width = Constants.TILE_SIZE
}

return function(t2: {[any]: any}) -- line: 27
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), Text (copy), StyledTextLabel (copy), FFlagHomepagePYMKPresence (copy)
	local v12 = Cryo.Dictionary.join(t1, t2)
	local v13 = useStyle()
	local Theme = v13.Theme
	local Font = v13.Font
	local v16 = React.useMemo(function() -- line: 34
		-- upvalues: Text (copy), v12 (copy), Font (copy)
		return Text.GetTextHeight(v12.name, Font.CaptionHeader.Font, Font.BaseSize * Font.CaptionHeader.RelativeSize, 10000)
	end, {
		v12.name,
		Font.CaptionHeader.Font,
		Font.BaseSize * Font.CaptionHeader.RelativeSize
	})

	return React.createElement(StyledTextLabel, {
		lineHeight = 1,
		fluidSizing = false,
		layoutOrder = v12.layoutOrder,
		text = v12.name,
		fontStyle = Font.CaptionHeader,
		colorStyle = Theme.TextEmphasis,
		size = UDim2.fromOffset(v12.width, v16),
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Left,
		textYAlignment = Enum.TextYAlignment.Center,
		richText = not not FFlagHomepagePYMKPresence
	})
end
