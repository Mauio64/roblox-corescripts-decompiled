local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Constants")

local v5 = { ["catalog-tab:all"] = "catalog-tab:recommended" }

local function getCatalogPageIdentifier(p2)
	local v6 = v5[p2] or p2
	return `{module.CatalogContentIdentifierPrefix}:{v6}`
end

return getCatalogPageIdentifier
