local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local function getCatalogContentToHydrate(list, p, p2: number?)
	local catalogContentToHydrate = {}

	if not list or #list == 0 then
		return catalogContentToHydrate
	end

	local v

	if p2 == nil then
		v = #list
	else
		v = math.min(p2, #list)
	end

	local v2 = {}

	for i = 1, v do
		local item = list[i]
		local kind = item.type

		local v3 = v2[kind]

		if v3 == nil then
			if p and p[kind] then
				v3 = p[kind]
			else
				v3 = false
			end

			v2[kind] = v3
		end

		local v4

		if v3 then
			v4 = v3[item.id]
		end

		local v5

		if kind == ItemTypeEnum.Look then
			v5 = not FFlagAXMigrateAllTabToSduiDev
		else
			v5 = false
		end

		if v5 or not v4 then
			table.insert(catalogContentToHydrate, item)
		end
	end

	return catalogContentToHydrate
end

return getCatalogContentToHydrate
