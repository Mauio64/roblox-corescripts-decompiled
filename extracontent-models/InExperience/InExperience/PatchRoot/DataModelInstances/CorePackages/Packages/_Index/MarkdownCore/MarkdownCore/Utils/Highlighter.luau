local parent = script:FindFirstAncestor("Utils").Parent
require(parent.Types)
local Utility = require(script.Utility)
local Theme = require(script.Theme)
local defaultTokenColors = require(script.Theme.defaultTokenColors)

local Highlighter = { defaultLexer = require(script.Lexer) }

function Highlighter.highlight(p: string, p2)
	if p2 then
		Theme.setColors(p2)
	else
		Theme.setColors(defaultTokenColors)
	end

	local convertTabsToSpaces = Utility.convertTabsToSpaces(Utility.removeControlChars(p))
	local defaultLexer = Highlighter.defaultLexer
	local color = Theme.getColor("iden")
	local v = ""

	for k, v2 in defaultLexer.scan(convertTabsToSpaces) do
		local v3 = Theme.getColor(k) or color
		v ..= Theme.getColoredRichText(v3, Utility.sanitizeRichText(v2))
	end

	return v
end

function Highlighter.getTokenColor(p)
	return Theme.getColor(p)
end

return Highlighter
