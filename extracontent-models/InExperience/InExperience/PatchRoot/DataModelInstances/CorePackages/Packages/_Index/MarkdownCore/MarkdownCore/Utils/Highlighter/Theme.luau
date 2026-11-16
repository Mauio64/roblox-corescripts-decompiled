local parent = script:FindFirstAncestor("Utils").Parent
local defaultTokenColors = require(script.defaultTokenColors)

require(parent.Types)

local Theme = { tokenColors = {}, defaultColors = defaultTokenColors }

function Theme.setColors(items)
	assert(type(items) == "table", "Theme.updateColors expects a table")

	for k, item in items do
		Theme.tokenColors[k] = item
	end
end

function Theme.getColoredRichText(color: Color3, p: string)
	return "<font color=\"#" .. color:ToHex() .. "\">" .. p .. "</font>"
end

function Theme.getColor(p)
	return Theme.tokenColors[p]
end

Theme.setColors(defaultTokenColors)

return Theme
