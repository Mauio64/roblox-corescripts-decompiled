local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local Constants = require(AvatarExperienceCatalog.Sdui.Constants)
local t1 = {
	["catalog-tab:all"] = "catalog-tab:recommended"
}

local function getCatalogPageIdentifier(s1: string) -- line: 33
	-- upvalues: t1 (copy), Constants (copy)
	local v6 = t1[s1] or s1

	return `{ Constants.CatalogContentIdentifierPrefix }:{ v6 }`
end

return getCatalogPageIdentifier
