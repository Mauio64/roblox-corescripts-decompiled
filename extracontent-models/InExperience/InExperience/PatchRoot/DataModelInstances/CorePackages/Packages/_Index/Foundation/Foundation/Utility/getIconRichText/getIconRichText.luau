local parent = script:FindFirstAncestor("Foundation").Parent
local BuilderIcons = require(parent.BuilderIcons)
local Font = BuilderIcons.Font
local IconVariant = BuilderIcons.IconVariant

local function getIconRichText(p: string, p2)
	local v = Font[p2 or IconVariant.Regular]

	return `<font family="{v.Family}" weight="{v.Weight.Value}">{p}</font>`
end

return getIconRichText
