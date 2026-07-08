local Parent = script:FindFirstAncestor("Foundation").Parent
local BuilderIcons = require(Parent.BuilderIcons)
local BuilderIconsFont = BuilderIcons.Font
local IconVariant = BuilderIcons.IconVariant

local function getIconRichText(s1: string, p1) -- line: 8
	-- upvalues: IconVariant (copy), BuilderIconsFont (copy)
	local v8 = BuilderIconsFont[p1 or IconVariant.Regular]

	return `<font family="{ v8.Family }" weight="{ v8.Weight.Value }">{ s1 }</font>`
end

return getIconRichText
