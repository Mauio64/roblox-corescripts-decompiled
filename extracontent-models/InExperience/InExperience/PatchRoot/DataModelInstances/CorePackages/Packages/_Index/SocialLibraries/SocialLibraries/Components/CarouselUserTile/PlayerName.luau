local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local llama = dependencies.llama
local UIBlox = dependencies.UIBlox
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local UIBloxStyle = UIBlox.Style
local getTextHeight = require(script.Parent.getTextHeight)

require(script.Parent.StyleTypes)

local t1 = {
	width = require(script.Parent.Constants).TILE_SIZE
}

return function(t2: {[any]: any}) -- line: 25
	-- upvalues: llama (copy), t1 (copy), UIBloxStyle (copy), Roact (copy), StyledTextLabel (copy), getTextHeight (copy)
	local v11 = llama.Dictionary.join(t1, t2)

	return UIBloxStyle.withStyle(function(p1) -- line: 28
		-- upvalues: Roact (copy), StyledTextLabel (copy), v11 (copy), getTextHeight (copy)
		local Theme = p1.Theme
		local p1Font = p1.Font

		return Roact.createElement(StyledTextLabel, {
			lineHeight = 1,
			fluidSizing = false,
			richText = false,
			layoutOrder = v11.layoutOrder,
			text = v11.name,
			fontStyle = p1Font.CaptionHeader,
			colorStyle = Theme.TextEmphasis,
			size = UDim2.fromOffset(v11.width, getTextHeight(v11.name, p1Font.CaptionHeader.Font, p1Font.BaseSize * p1Font.CaptionHeader.RelativeSize)),
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Center
		})
	end)
end
