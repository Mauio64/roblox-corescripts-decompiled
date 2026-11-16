require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/deferred/glL")
local module = require("@luauforge/bundled/dRQ")
require("@luauforge/bundled/dPF")

local function findSubcategoryAnywhere(subcategory, items)
	for k, item in items do
		if not item.Subcategories then
			continue
		end

		local subcategoryBySubcategoryId = module.findSubcategoryBySubcategoryId(
			subcategory,
			item.Subcategories
		)

		if subcategoryBySubcategoryId then
			return item, subcategoryBySubcategoryId
		end
	end

	return nil, nil
end

local function resolveCatalogQueryCategory(data, p2)
	local category = tonumber(data.category)
	local subcategory = tonumber(data.subcategory)

	if p2 == nil then
		return { category = category }
	end

	if data.taxonomy then
		local categoryIdsByTaxonomy, v5 = module.findCategoryIdsByTaxonomy(data.taxonomy, p2)

		if categoryIdsByTaxonomy then
			return {
				category = category,
				categoryId = categoryIdsByTaxonomy,
				subcategoryId = v5
			}
		end
	end

	if subcategory then
		local subcategoryAnywhere, v5 = findSubcategoryAnywhere(subcategory, p2)

		if subcategoryAnywhere and v5 and subcategoryAnywhere.CategoryId then
			return {
				category = subcategoryAnywhere.CategoryId,
				subcategory = v5.SubcategoryId,
				categoryId = subcategoryAnywhere.Id,
				subcategoryId = v5.Id
			}
		end
	end

	local v5 = if category then module.findCategoryByCategoryId(category, p2) else nil
	local v7 = if v5 then v5.Id else nil
	return { category = category, categoryId = v7 }
end

return resolveCatalogQueryCategory
