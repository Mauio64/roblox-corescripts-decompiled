local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local Constants = require(AvatarExperienceCatalog.Sdui.Constants)
local normalizeScreenSizeForWire = require(script.Parent.normalizeScreenSizeForWire)

local function getCatalogConfigKey(s1: string, s2: string) -- line: 10
	-- upvalues: normalizeScreenSizeForWire (copy), Constants (copy)
	local v7 = normalizeScreenSizeForWire(s2)

	return `{ Constants.CatalogSduiConfigKeyPrefix }-{ s1 }-{ v7 }`
end

return getCatalogConfigKey
