local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local ItemTypeEnum = require(Parent.AvatarExperienceCommon).Enums.ItemTypeEnum
local selectHydratedWidgetData = require(script.Parent.selectHydratedWidgetData)

local function selectHydratedLookType(p1, s1: string) -- line: 21
	-- upvalues: selectHydratedWidgetData (copy), ItemTypeEnum (copy)
	local v7 = selectHydratedWidgetData(p1)
	local v8 = v7 and v7[ItemTypeEnum.Look]
	local v9 = v8 and v8[s1]

	return v9 and v9.lookType or nil
end

return selectHydratedLookType
