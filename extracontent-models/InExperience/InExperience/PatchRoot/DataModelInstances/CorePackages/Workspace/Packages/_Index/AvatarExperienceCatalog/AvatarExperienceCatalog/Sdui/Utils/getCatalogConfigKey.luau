local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local Constants = require(AvatarExperienceCatalog.Sdui.Constants)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local normalizeScreenSizeForWire = AvatarExperienceCommon.Utils.normalizeScreenSizeForWire

local function getCatalogConfigKey(p: string, p2: string)
	local screenSizeForWire = normalizeScreenSizeForWire(p2)
	return `{Constants.CatalogSduiConfigKeyPrefix}-{p}-{screenSizeForWire}`
end

return getCatalogConfigKey
