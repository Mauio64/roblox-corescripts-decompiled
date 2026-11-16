require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module2 = require("@luauforge/bundled/fuD")
local module3 = require("@luauforge/bundled/dRQ")
local module4 = require("@luauforge/bundled/dPF")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local function getMatchingCatalogCategoryIds(p2)
	if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
		local matchingCatalogPageIds = p2.MatchingCatalogPageIds

		if matchingCatalogPageIds then
			return matchingCatalogPageIds.CategoryId, matchingCatalogPageIds.SubcategoryId
		end

		return nil, nil
	else
		local matchingCatalogPage = p2.MatchingCatalogPage

		if not matchingCatalogPage then
			return nil, nil
		end

		local subcategoryKey = matchingCatalogPage.SubcategoryKey
		local rawValue = matchingCatalogPage.CategoryKey:rawValue()

		if subcategoryKey then
			return rawValue, (subcategoryKey:rawValue())
		end

		return rawValue, nil
	end
end

local function getLoadedCatalogCategoryInfoById(p2, p3)
	local v5 = module4()

	if module3.extractCategoryById(p2, v5) == nil then
		return nil
	end

	return module2.getCatalogCategoryInfoById(p2, p3)
end

local function getEditorCategoryUnifiedFields(data, p2, p3)
	if not data then
		return {}
	end

	local taxonomyUuid = nil
	local v5, v6

	if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
		local matchingCatalogPageIds = data.MatchingCatalogPageIds

		if matchingCatalogPageIds then
			v5 = matchingCatalogPageIds.CategoryId
			v6 = matchingCatalogPageIds.SubcategoryId
		end
	else
		local matchingCatalogPage = data.MatchingCatalogPage

		if matchingCatalogPage then
			local subcategoryKey = matchingCatalogPage.SubcategoryKey
			v5 = matchingCatalogPage.CategoryKey:rawValue()

			if subcategoryKey then
				v6 = subcategoryKey:rawValue()
			end
		end
	end

	if v5 then
		local v7 = (p3 or getLoadedCatalogCategoryInfoById)(v5, v6)

		if v7 then
			taxonomyUuid = v7.TaxonomyUuid
		end
	end

	local v7 = { category = data.Name, subcategory = 0, taxonomyId = 0 }
	local v8 = if p2 then p2.Name else nil
	v7.subcategory = v8
	v7.taxonomyId = taxonomyUuid
	return v7
end

return getEditorCategoryUnifiedFields
