local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Constants")
local normalizeScreenSizeForWire = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Utils.normalizeScreenSizeForWire

local function getCatalogConfigKey(p2, p3)
	local screenSizeForWire = normalizeScreenSizeForWire(p3)
	return `{module.CatalogSduiConfigKeyPrefix}-{p2}-{screenSizeForWire}`
end

return getCatalogConfigKey
