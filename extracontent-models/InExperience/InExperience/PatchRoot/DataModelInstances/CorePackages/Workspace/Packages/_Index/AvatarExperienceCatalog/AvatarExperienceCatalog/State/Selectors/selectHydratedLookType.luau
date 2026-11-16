local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

require(parent.AvatarExperienceCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local selectHydratedWidgetData = require(script.Parent.selectHydratedWidgetData)

local function selectHydratedLookType(p, p2: string)
	local v = selectHydratedWidgetData(p)
	local v2 = v and v[ItemTypeEnum.Look]
	local v3 = v2 and v2[p2]
	return v3 and v3.lookType or nil
end

return selectHydratedLookType
