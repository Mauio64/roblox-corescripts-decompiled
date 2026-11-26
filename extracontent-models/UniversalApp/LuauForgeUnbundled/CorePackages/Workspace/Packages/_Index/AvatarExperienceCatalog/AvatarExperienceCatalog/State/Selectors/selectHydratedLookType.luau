require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceModel").Enums.ItemTypeEnum

local selectHydratedWidgetData = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Selectors/selectHydratedWidgetData")

local function selectHydratedLookType(p2, p3)
	local v5 = selectHydratedWidgetData(p2)
	local v6 = v5 and v5[itemTypeEnum.Look]
	local v7 = v6 and v6[p3]
	return v7 and v7.lookType or nil
end

return selectHydratedLookType
