local Parent = script:FindFirstAncestor("Utils").Parent

require(Parent.Types)

local Utility = require(script.Utility)
local Theme = require(script.Theme)
local defaultTokenColors = require(script.Theme.defaultTokenColors)
local t1 = {
	defaultLexer = require(script.Lexer)
}

function t1.highlight(s1: string, p1) -- line: 14
	-- upvalues: Theme (copy), defaultTokenColors (copy), Utility (copy), t1 (copy)
	if p1 then
		Theme.setColors(p1)
	else
		Theme.setColors(defaultTokenColors)
	end

	local v8 = Utility.convertTabsToSpaces(Utility.removeControlChars(s1))
	local defaultLexer = t1.defaultLexer
	local v10 = Theme.getColor("iden")
	local s2 = ""

	for v12, v13 in defaultLexer.scan(v8) do
		local v14 = Theme.getColor(v12) or v10

		s2 ..= Theme.getColoredRichText(v14, Utility.sanitizeRichText(v13))
	end

	return s2
end
function t1.getTokenColor(p2) -- line: 35
	-- upvalues: Theme (copy)
	return Theme.getColor(p2)
end

return t1
