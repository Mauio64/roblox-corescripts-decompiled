local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local module = require("@luauforge/bundled/dFs")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

require("@luauforge/bundled/dSX")

local module2 = require("@luauforge/bundled/dPN")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local function createCategorySelectionStore(p2)
	local v5 = nil

	if fFlagAXMigrateAllTabToSduiDev then
		v5 = module2.DefaultCatalogCategoryId
	elseif fFlagAXCatalogCategoriesSDUI then
		local categories = p2.getCategories(false)
		v5 = #categories > 0 and categories[1].Id or module2.DefaultCatalogCategoryId
	end

	if not fFlagAXCatalogCategoriesSDUI then
		v5 = module2.DefaultCatalogCategoryId
	end

	local v8, v9 = createSignal({ categoryId = v5, subcategoryId = nil })

	local computed = createComputed(function(p3)
		local categoryId = v8(p3).categoryId

		if fFlagAXMigrateAllTabToSduiDev and not p2.getCategoriesMap(p3)[categoryId] then
			return module2.DefaultCatalogCategoryId
		end

		return categoryId
	end)

	local computed2 = createComputed(function(p3)
		return v8(p3).subcategoryId
	end)

	local computed3 = createComputed(function(p3)
		local v10 = computed(p3)

		if v10 == nil then
			v10 = module2.DefaultCatalogCategoryId
		end

		return p2.getCategoriesMap(p3)[v10]
	end)

	local computed4 = createComputed(function(p3)
		local v10 = computed2(p3)

		if v10 == nil then
			return nil
		end

		local v11 = computed3(p3)

		if v11 == nil then
			return nil
		end

		local subcategories = v11.Subcategories

		if subcategories ~= nil then
			for k, subcategory in subcategories do
				if subcategory.Id == v10 then
					return subcategory
				end
			end
		end

		return nil
	end)

	local function changeCategory(p3, p4): boolean
		if p4 == nil then
			if p3 == nil then
				module("[Category Selection Store] changeCategory received both categoryId and subcategoryId as nil")

				return false
			end

			local categoriesMap = p2.getCategoriesMap(false)

			if categoriesMap[p3] then
				v9({ categoryId = p3, subcategoryId = nil })

				return true
			end

			if not fFlagAXMigrateAllTabToSduiDev then
				return false
			end

			for k, category in categoriesMap do
				if category and category.SubcategoriesMap and category.SubcategoriesMap[p3] then
					v9({ categoryId = category.Id, subcategoryId = p3 })

					return true
				end
			end

			return false
		else
			local v10 = nil

			if p3 == nil then
				if fFlagAXMigrateAllTabToSduiDev then
					local categoriesMap = p2.getCategoriesMap(false)

					for k, category in categoriesMap do
						if category and category.SubcategoriesMap and category.SubcategoriesMap[p4] then
							v10 = category
							break
						end
					end
				else
					local categories = p2.getCategories(false)

					for k, category in categories do
						if category and category.SubcategoriesMap and category.SubcategoriesMap[p4] then
							v10 = category
							break
						end
					end
				end
			else
				v10 = p2.getCategoriesMap(false)[p3]
			end

			if not v10 then
				return false
			end

			local v11 = false
			local subcategories = v10.Subcategories

			if subcategories ~= nil then
				for k, subcategory in subcategories do
					if subcategory.Id == p4 then
						v11 = true
						break
					end
				end
			end

			if not v11 then
				return false
			end

			v9({ categoryId = v10.Id, subcategoryId = p4 })

			return true
		end
	end

	return {
		selectedCategoryId = computed,
		selectedCategory = computed3,
		selectedSubcategoryId = computed2,
		selectedSubcategory = computed4,
		selectedCategoryInfo = createComputed(function(p3)
			local v10 = computed4(p3)

			if v10 then
				return v10
			end

			return computed3(p3)
		end),
		changeCategory = changeCategory
	}
end

return createCategorySelectionStore
