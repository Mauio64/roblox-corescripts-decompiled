local module = require("@luauforge/bundled/dOj")
local module2 = require("@luauforge/bundled/dMx")

local module3 = require("@luauforge/bundled/dOu")
local fFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters

local fFlagAXPhotoboothMomentsBugFixes = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsBugFixes

local module4 = require("@luauforge/bundled/dOv")

local avatarEditorStructure = nil

local function createCategorySubcategoryTable(p2, p3)
	return { category = p2, subcategory = p3 }
end

local function CreateAvatarEditorStructure()
	local v5 = {}

	local v6 = (fFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters or module3) and {} or nil

	local v7 = {}

	local v8 = module()

	if fFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters then
		local function handleCategoryInfo(data, k, p2, p3)
			local v9 = { category = k, subcategory = p2, subcategoryFilter = p3 }

			if data.AssetTypeIdStrings then
				for k2, assetTypeIdString in data.AssetTypeIdStrings do
					v5[assetTypeIdString] = v9
				end
			end

			if data.BundleTypeIdStrings then
				for k2, bundleTypeIdString in data.BundleTypeIdStrings do
					v6[bundleTypeIdString] = v9
				end
			end

			if data.Subcategories then
				for k2, subcategory in data.Subcategories do
					handleCategoryInfo(subcategory, k, k2, nil)
				end
			end

			if data.SubcategoryFilters then
				for k2, subcategoryFilter in data.SubcategoryFilters do
					handleCategoryInfo(subcategoryFilter, k, p2, k2)
				end
			end
		end

		for k, v9 in v8 do
			handleCategoryInfo(v9, k, nil, nil)
		end
	else
		for k, v9 in v8 do
			local subcategories = v9.Subcategories

			if subcategories then
				if module3 then
					for k2, subcategory in subcategories do
						if subcategory.AssetTypeIdStrings then
							for k3, assetTypeIdString in subcategory.AssetTypeIdStrings do
								v5[assetTypeIdString] = {
									category = subcategory.Category,
									subcategory = subcategory.Subcategory
								}
							end
						end

						if subcategory.BundleTypeIdStrings then
							for k3, bundleTypeIdString in subcategory.BundleTypeIdStrings do
								v6[bundleTypeIdString] = {
									category = v9.Category,
									subcategory = subcategory.Subcategory
								}
							end
						end

						if subcategory.OutfitType then
							v7[subcategory.OutfitType] = {
								category = v9.Category,
								subcategory = v9.Subcategory
							}
						end
					end
				else
					for k2, subcategory in subcategories do
						if subcategory.AssetTypeIdStrings then
							for k3, assetTypeIdString in subcategory.AssetTypeIdStrings do
								v5[assetTypeIdString] = {
									category = subcategory.Category,
									subcategory = subcategory.Subcategory
								}
							end
						elseif subcategory.BundleTypes then
							v6 = {
								category = v9.Category,
								subcategory = v9.Subcategory
							}
						elseif subcategory.OutfitType then
							v7[subcategory.OutfitType] = {
								category = v9.Category,
								subcategory = v9.Subcategory
							}
						end
					end
				end
			elseif v9.AssetTypeIdStrings then
				for k2, assetTypeIdString in v9.AssetTypeIdStrings do
					v5[assetTypeIdString] = {
						category = v9.Category,
						subcategory = v9.Subcategory
					}
				end
			elseif v9.OutfitType then
				v7[v9.OutfitType] = {
					category = v9.Category,
					subcategory = v9.Subcategory
				}
			end
		end
	end

	local v9 = {}

	local function fillFromAssetTypes(searchUuid, assetTypeIdStrings)
		for k, item in assetTypeIdStrings do
			if not v9[item] then
				v9[item] = {}
			end

			local v10 = v9[item]
			v10[#v10 + 1] = searchUuid
		end
	end

	local function fillAssetTypeToSearchUuids(items)
		for k, item in items do
			if item.AssetTypeIdStrings and item.SearchUuid then
				fillFromAssetTypes(item.SearchUuid, item.AssetTypeIdStrings)
			end

			if item.Subcategories then
				fillAssetTypeToSearchUuids(item.Subcategories)
			end
		end
	end

	local function fillAssetTypeNoCategories()
		for k, dynamicHeadAssetType in module2.DynamicHeadAssetTypes do
			if v5[k] then
				continue
			end

			if fFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters then
				v5[k] = v6[module2.BundleTypeIdStrings.DynamicHead]
			else
				v5[k] = v7[module2.OutfitTypes.DynamicHead]
			end
		end
	end

	fillAssetTypeToSearchUuids(module())

	local v10 = fFlagAXPhotoboothMomentsBugFixes and module4()

	if v10 then
		fillAssetTypeToSearchUuids({ v10 })
	end

	fillAssetTypeNoCategories()

	return {
		AssetTypeToCategorySubcategory = v5,
		AssetTypeToSearchUuids = v9,
		BundleToCategorySubcategory = v6,
		OutfitTypeToCategorySubcategory = v7
	}
end

local function GetAvatarEditorStructure()
	if not avatarEditorStructure then
		avatarEditorStructure = CreateAvatarEditorStructure()
	end

	return avatarEditorStructure
end

return GetAvatarEditorStructure
