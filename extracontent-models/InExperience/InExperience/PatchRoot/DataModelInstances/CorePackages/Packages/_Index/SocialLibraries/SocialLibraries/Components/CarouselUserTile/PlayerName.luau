local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local llama = dependencies.llama

local uiBlox = dependencies.UIBlox
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local style = uiBlox.Style

require(script.Parent.StyleTypes)
local Constants = require(script.Parent.Constants)

local v = { width = Constants.TILE_SIZE }

return function(p)
	local joined = llama.Dictionary.join(v, p)

	return style.withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font
		local v2 = font.BaseSize * font.CaptionHeader.RelativeSize

		return roact.createElement(styledTextLabel, {
			layoutOrder = joined.layoutOrder,
			text = joined.name,
			fontStyle = font.CaptionHeader,
			colorStyle = theme.TextEmphasis,
			size = UDim2.fromOffset(joined.width, v2),
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Center,
			lineHeight = 1,
			fluidSizing = false,
			richText = false
		})
	end)
end
