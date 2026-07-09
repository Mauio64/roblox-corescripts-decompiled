local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local FFlagAXFixBundleRedirectFromCatalogForSlots = require(Modules.AvatarExperience.Flags.FFlagAXFixBundleRedirectFromCatalogForSlots)
local FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters
local u7 = nil

local function createCategorySubcategoryTable(p1, p2) -- line: 21
	return {
		category = p1,
		subcategory = p2
	}
end
local function CreateAvatarEditorStructure() -- line: 28
	-- upvalues: FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters (copy), FFlagAXFixBundleRedirectFromCatalogForSlots (copy), GetAvatarEditorCategories (copy), Constants (copy)
	local t1 = {}
	local u14 = if not FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters and not FFlagAXFixBundleRedirectFromCatalogForSlots then nil else {}
	local t2 = {}
	local v16 = GetAvatarEditorCategories()

	if FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters then
		local function handleCategoryInfo(p3, p4, p5, p6) -- line: 43
			-- upvalues: t1 (copy), u14 (ref), handleCategoryInfo (copy)
			local t3 = {
				category = p4,
				subcategory = p5,
				subcategoryFilter = p6
			}

			if p3.AssetTypeIdStrings then
				for _, v64 in p3.AssetTypeIdStrings do
					t1[v64] = t3
				end
			end

			if p3.BundleTypeIdStrings then
				for _, v66 in p3.BundleTypeIdStrings do
					u14[v66] = t3
				end
			end

			if p3.Subcategories then
				for v67, v68 in p3.Subcategories do
					handleCategoryInfo(v68, p4, v67, nil)
				end
			end

			if p3.SubcategoryFilters then
				for v69, v70 in p3.SubcategoryFilters do
					handleCategoryInfo(v70, p4, p5, v69)
				end
			end
		end

		for v18, v19 in v16 do
			handleCategoryInfo(v19, v18, nil, nil)
		end
	else
		for _, v21 in v16 do
			local Subcategories = v21.Subcategories

			if Subcategories then
				if FFlagAXFixBundleRedirectFromCatalogForSlots then
					for _, v24 in Subcategories do
						if v24.AssetTypeIdStrings then
							for _, v26 in v24.AssetTypeIdStrings do
								local Category = v24.Category
								local Subcategory = v24.Subcategory

								t1[v26] = {
									category = Category,
									subcategory = Subcategory
								}
							end
						end

						if v24.BundleTypeIdStrings then
							for _, v30 in v24.BundleTypeIdStrings do
								local Category = v21.Category
								local Subcategory = v24.Subcategory

								u14[v30] = {
									category = Category,
									subcategory = Subcategory
								}
							end
						end

						if v24.OutfitType then
							local OutfitType = v24.OutfitType
							local Category = v21.Category
							local Subcategory = v21.Subcategory

							t2[OutfitType] = {
								category = Category,
								subcategory = Subcategory
							}
						end
					end
				else
					for _, v37 in Subcategories do
						if v37.AssetTypeIdStrings then
							for _, v39 in v37.AssetTypeIdStrings do
								local Category = v37.Category
								local Subcategory = v37.Subcategory

								t1[v39] = {
									category = Category,
									subcategory = Subcategory
								}
							end
						elseif v37.BundleTypes then
							local Category = v21.Category
							local Subcategory = v21.Subcategory

							u14 = {
								category = Category,
								subcategory = Subcategory
							}
						elseif v37.OutfitType then
							local OutfitType = v37.OutfitType
							local Category = v21.Category
							local Subcategory = v21.Subcategory

							t2[OutfitType] = {
								category = Category,
								subcategory = Subcategory
							}
						end
					end
				end
			elseif v21.AssetTypeIdStrings then
				for _, v48 in v21.AssetTypeIdStrings do
					local Category = v21.Category
					local Subcategory = v21.Subcategory

					t1[v48] = {
						category = Category,
						subcategory = Subcategory
					}
				end
			elseif v21.OutfitType then
				local OutfitType = v21.OutfitType
				local Category = v21.Category
				local Subcategory = v21.Subcategory

				t2[OutfitType] = {
					category = Category,
					subcategory = Subcategory
				}
			end
		end
	end

	local t4 = {}

	local function fillFromAssetTypes(p7, p8) -- line: 145
		-- upvalues: t4 (copy)
		for _, v74 in p8 do
			if not t4[v74] then
				t4[v74] = {}
			end

			local v75 = t4[v74]

			v75[#v75 + 1] = p7
		end
	end
	local function fillAssetTypeToSearchUuids(p9) -- line: 156
		-- upvalues: fillFromAssetTypes (copy), fillAssetTypeToSearchUuids (copy)
		for _, v78 in p9 do
			if v78.AssetTypeIdStrings and v78.SearchUuid then
				fillFromAssetTypes(v78.SearchUuid, v78.AssetTypeIdStrings)
			end

			if v78.Subcategories then
				fillAssetTypeToSearchUuids(v78.Subcategories)
			end
		end
	end
	local function fillAssetTypeNoCategories() -- line: 168
		-- upvalues: Constants (copy), t1 (copy), FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters (copy), u14 (ref), t2 (copy)
		for v79, _ in Constants.DynamicHeadAssetTypes do
			if not t1[v79] then
				if FFlagAXLeaveCatalogToAvatarPromptHandleSubcategoryFilters then
					t1[v79] = u14[Constants.BundleTypeIdStrings.DynamicHead]
				else
					t1[v79] = t2[Constants.OutfitTypes.DynamicHead]
				end
			end
		end
	end

	fillAssetTypeToSearchUuids(GetAvatarEditorCategories())
	fillAssetTypeNoCategories()

	return {
		AssetTypeToCategorySubcategory = t1,
		AssetTypeToSearchUuids = t4,
		BundleToCategorySubcategory = u14,
		OutfitTypeToCategorySubcategory = t2
	}
end
local function GetAvatarEditorStructure() -- line: 193
	-- upvalues: u7 (ref), CreateAvatarEditorStructure (copy)
	if not u7 then
		u7 = CreateAvatarEditorStructure()
	end

	return u7
end

return GetAvatarEditorStructure
