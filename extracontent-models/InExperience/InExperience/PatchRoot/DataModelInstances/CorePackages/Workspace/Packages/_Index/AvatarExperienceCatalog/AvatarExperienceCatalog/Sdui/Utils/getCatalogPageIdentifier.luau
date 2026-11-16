local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local Constants = require(AvatarExperienceCatalog.Sdui.Constants)

local v = { ["catalog-tab:all"] = "catalog-tab:recommended" }

local function getCatalogPageIdentifier(p: string)
	local v2 = v[p] or p
	return `{Constants.CatalogContentIdentifierPrefix}:{v2}`
end

return getCatalogPageIdentifier
