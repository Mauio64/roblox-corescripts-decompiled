local parent = script:FindFirstAncestor("Markdown").Parent
local CommonMark = require(parent.CommonMark)
local Underline = require(script.Parent.Underline)

return {
	new = function()
		return CommonMark.Parser.Delimiter.EmphasisLikeDelimiterProcessor.new(95, {
			minLength = 2,
			createStrongEmphasis = Underline
		})
	end
}
