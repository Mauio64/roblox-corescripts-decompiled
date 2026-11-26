local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceModel").Enums.ItemTypeEnum

local fFlagAXMigrateAllTabToSduiDev = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXMigrateAllTabToSduiDev

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")

local function getCatalogContentToHydrate(list, p2, p3)
	local catalogContentToHydrate = {}

	if not list or #list == 0 then
		return catalogContentToHydrate
	end

	local v5 = if p3 == nil then #list else math.min(p3, #list)

	local v6 = {}

	for i = 1, v5 do
		local item = list[i]
		local kind = item.type

		local v7 = v6[kind]

		if v7 == nil then
			v7 = if p2 and p2[kind] then p2[kind] else false

			v6[kind] = v7
		end

		local v8 = if v7 then v7[item.id] else nil

		local v9 = kind == itemTypeEnum.Look and not fFlagAXMigrateAllTabToSduiDev

		if v9 or not v8 then
			table.insert(catalogContentToHydrate, item)
		end
	end

	return catalogContentToHydrate
end

return getCatalogContentToHydrate
