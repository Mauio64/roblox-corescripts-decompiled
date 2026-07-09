local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local _ = {
	SHOW_SPONSORED = "ShowSponsored",
	SHOW_TOPICS = "ShowTopics",
	CATEGORY_FILTER = "CategoryFilter",
	WIDGET_CONTEXT = "WidgetContext",
	LOCALIZED_TITLE = "LocalizedTitle",
	CATEGORY_ID = "CategoryId",
	SUBCATEGORY_ID = "SubcategoryId",
	IS_SUBCATEGORY = "isSubcategory",
	CAN_ANIMATE_CAMERA_BASED_MOOD = "CanAnimateCameraBasedMood",
	DISABLE_FILTERS = "DisableFilters",
	SHOW_LOOKS_AS_ORGANIC_CONTENT = "ShowLooksAsOrganicContent",
	SUBCATEGORIES = "Subcategories"
}
local _ = {
	ALL = "All",
	ANIMATIONS = "Animations",
	ALL_ANIMATIONS = "AllAnimations"
}
local _ = {
	BUNDLES = "Bundles",
	T_SHIRTS = "T-Shirts",
	DRESSES_PANTS = "Dresses & Pants",
	HEADS = "Heads",
	ANIMATION_BUNDLES = "AnimationBundles",
	TSHIRTS = "TShirts",
	DRESS_SKIRT = "DressSkirt",
	HATS = "Hats"
}
local _ = {
	HEADS = "22"
}

local function deepCompareTables(p1, p2, s1: string) -- line: 79
	-- upvalues: deepCompareTables (copy)
	local t1 = {}

	if type(p1) ~= type(p2) then
		table.insert(t1, string.format("%s: type mismatch (SDUI: %s, Legacy: %s)", s1, type(p1), (type(p2))))

		return t1
	end

	if type(p1) == "table" then
		local v14 = false

		if #p1 > 0 or #p2 > 0 then
			v14 = true
		end

		if v14 then
			if #p1 ~= #p2 then
				table.insert(t1, string.format("%s: array length mismatch (SDUI: %d, Legacy: %d)", s1, #p1, #p2))
			end

			for i = 1, math.max(#p1, #p2) do
				local v16 = p1[i]
				local v17 = p2[i]
				local v18 = string.format("%s[%d]", s1, i)

				if v16 == nil and v17 ~= nil then
					table.insert(t1, string.format("%s: missing in SDUI", v18))
				elseif v16 ~= nil and v17 == nil then
					table.insert(t1, string.format("%s: missing in Legacy", v18))
				elseif v16 ~= nil and v17 ~= nil then
					for _, v20 in (deepCompareTables(v16, v17, v18)) do
						table.insert(t1, v20)
					end
				end
			end

			return t1
		end

		local t2 = {}

		for v22 in p1 do
			t2[v22] = true
		end

		for v23 in p2 do
			t2[v23] = true
		end

		for v24 in t2 do
			local v25 = p1[v24]
			local v26 = p2[v24]
			local v27 = string.format("%s.%s", s1, (tostring(v24)))

			if v25 == nil and v26 ~= nil then
				local v28 = string.match(s1, "^All%.") or s1 == "All"
				local v29 = v24 == "ShowSponsored" or (v24 == "ShowTopics" or v24 == "CategoryFilter")
				local v30 = v24 == "CanAnimateCameraBasedMood" and v26 == false
				local v31 = v24 == "CategoryId" or (v24 == "SubcategoryId" or v24 == "isSubcategory")

				if (not v28 or not v29) and not v30 and not v31 then
					table.insert(t1, string.format("%s: missing in SDUI (Legacy has: %s)", v27, (tostring(v26))))
				end
			elseif v25 ~= nil and v26 == nil then
				local v32 = v24 == "WidgetContext" or v24 == "LocalizedTitle"
				local v33 = v24 == "DisableFilters" and v25 == false
				local v34 = v24 == "CanAnimateCameraBasedMood" and v25 == false
				local v35 = v24 == "ShowLooksAsOrganicContent" and v25 == false
				local v36 = v24 == "CategoryId" or (v24 == "SubcategoryId" or v24 == "isSubcategory")

				if not v32 and not v33 and not v34 and not v35 and not v36 then
					table.insert(t1, string.format("%s: missing in Legacy (SDUI has: %s)", v27, (tostring(v25))))
				end
			elseif v25 ~= nil and v26 ~= nil then
				for _, v38 in (deepCompareTables(v25, v26, v27)) do
					table.insert(t1, v38)
				end
			end
		end

		return t1
	end

	return t1
end
local function compareCategories(p3, p4) -- line: 238
	-- upvalues: deepCompareTables (copy)
	local t3 = {}
	local t4 = {}

	for v43, v44 in p3 do
		if v43 ~= "Subcategories" then
			t3[v43] = v44
		end
	end

	for v45, v46 in p4 do
		if v45 ~= "Subcategories" then
			t4[v45] = v46
		end
	end

	return (deepCompareTables(t3, t4, p3.Name or "Unknown"))
end
local function compareSubcategories(p5, p6) -- line: 264
	-- upvalues: deepCompareTables (copy)
	print("compareSubcategories", p5, p6)

	return (deepCompareTables(p5, p6, p5.Name or "Unknown"))
end
local function logSubcategoryDifferences(t5: {[any]: any}, t6: {[any]: any}, s2: string) -- line: 270
	-- upvalues: deepCompareTables (copy)
	for _, v53 in t5 do
		local v54 = nil

		for _, v56 in t6 do
			local v57 = v53.Name == v56.Id
			local v58 = v53.Name == "Bundles" and v56.Id == "AnimationBundles"
			local v59 = v53.Name == "T-Shirts" and v56.Id == "TShirts"
			local v60 = v53.Name == "Dresses & Pants" and v56.Id == "DressSkirt"
			local v61 = v53.Name == "Heads" and (v53.Id == "22" and v56.Id == "Hats")

			if v57 or v58 or v59 or v60 or v61 then
				v54 = v56

				break
			end
		end

		if v54 then
			print("compareSubcategories", v53, v54)

			local v62 = deepCompareTables(v53, v54, v53.Name or "Unknown")

			if #v62 > 0 then
				warn(string.format("[GetCatalogCategoriesSDUI] Differences found for subcategory '%s' in category '%s':", v53.Name, s2))

				for _, v64 in v62 do
					warn(string.format("  - %s", v64))
				end
			end
		else
			warn(string.format("[GetCatalogCategoriesSDUI] No matching legacy subcategory found for SDUI subcategory '%s' in category '%s'", v53.Name, s2))
		end
	end
end

return {
	logCategoryDifferences = function(t7: {[any]: any}, t8: {[any]: any}) -- line: 334
		-- upvalues: compareCategories (copy), logSubcategoryDifferences (copy)
		for _, v68 in t7 do
			print("sduiCategory", v68)

			local v69 = nil

			for _, v71 in t8 do
				local v72 = v68.Name == v71.Id or v68.Name == v71.Name
				local v73 = v68.Name == "Animations" and (v71.Id == "AllAnimations" or v71.Name == "AllAnimations") or v68.Name == "AllAnimations" and (v71.Id == "Animations" or v71.Name == "Animations")

				if v72 or v73 then
					v69 = v71
					print("matchingLegacyCategory", v69)

					break
				end
			end

			if v69 then
				local v74 = compareCategories(v68, v69)

				if #v74 > 0 then
					warn(string.format("[GetCatalogCategoriesSDUI] Differences found for category '%s':", v68.Name))

					for _, v76 in v74 do
						warn(string.format("  - %s", v76))
					end
				end

				if v68.Subcategories and v69.Subcategories then
					logSubcategoryDifferences(v68.Subcategories, v69.Subcategories, v68.Name)
				elseif v68.Subcategories and not v69.Subcategories then
					warn(string.format("[GetCatalogCategoriesSDUI] SDUI category '%s' has subcategories but legacy category does not", v68.Name))
				elseif not v68.Subcategories and v69.Subcategories then
					warn(string.format("[GetCatalogCategoriesSDUI] Legacy category '%s' has subcategories but SDUI category does not", v68.Name))
				end
			else
				warn(string.format("[GetCatalogCategoriesSDUI] No matching legacy category found for SDUI category '%s'", v68.Name))
			end
		end
	end
}
