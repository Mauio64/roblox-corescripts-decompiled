local Parent = script:FindFirstAncestor("Utils").Parent
local defaultTokenColors = require(script.defaultTokenColors)

require(Parent.Types)

local t1 = {
	tokenColors = {},
	defaultColors = defaultTokenColors
}

function t1.setColors(p1) -- line: 11
	-- upvalues: t1 (copy)
	assert(type(p1) == "table", "Theme.updateColors expects a table")

	for v5, v6 in p1 do
		t1.tokenColors[v5] = v6
	end
end
function t1.getColoredRichText(color3: Color3, s1: string) -- line: 19
	return "<font color=\"#" .. color3:ToHex() .. "\">" .. s1 .. "</font>"
end
function t1.getColor(p2) -- line: 23
	-- upvalues: t1 (copy)
	return t1.tokenColors[p2]
end

t1.setColors(defaultTokenColors)

return t1
