require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local v5 = {
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

local v6 = { ALL = "All", ANIMATIONS = "Animations", ALL_ANIMATIONS = "AllAnimations" }

local v7 = {
	BUNDLES = "Bundles",
	T_SHIRTS = "T-Shirts",
	DRESSES_PANTS = "Dresses & Pants",
	HEADS = "Heads",
	ANIMATION_BUNDLES = "AnimationBundles",
	TSHIRTS = "TShirts",
	DRESS_SKIRT = "DressSkirt",
	HATS = "Hats"
}

local v8 = { HEADS = "22" }
local function deepCompareTables(list, list2, name)
	local result = {}

	if type(list) ~= type(list2) then
		table.insert(
			result,
			string.format("%s: type mismatch (SDUI: %s, Legacy: %s)", name, type(list), (type(list2)))
		)

		return result
	end

	if type(list) ~= "table" then
		return result
	end

	if #list > 0 or #list2 > 0 then
		if #list ~= #list2 then
			table.insert(
				result,
				string.format("%s: array length mismatch (SDUI: %d, Legacy: %d)", name, #list, #list2)
			)
		end

		for i = 1, math.max(#list, #list2) do
			local item = list[i]
			local item2 = list2[i]
			local v9 = string.format("%s[%d]", name, i)

			if item == nil and item2 ~= nil then
				table.insert(result, string.format("%s: missing in SDUI", v9))
			elseif item == nil or item2 ~= nil then
				if item ~= nil and item2 ~= nil then
					local v10 = deepCompareTables(item, item2, v9)

					for k, v11 in v10 do
						table.insert(result, v11)
					end
				end
			else
				table.insert(result, string.format("%s: missing in Legacy", v9))
			end
		end

		return result
	else
		local set = {}

		for k in list do
			set[k] = true
		end

		for k in list2 do
			set[k] = true
		end

		for k in set do
			local item = list[k]
			local item2 = list2[k]
			local v9 = string.format("%s.%s", name, (tostring(k)))

			if item == nil and item2 ~= nil then
				local v10 = string.match(name, "^All%.") or name == "All"

				local v11 = k == "ShowSponsored" or k == "ShowTopics" or k == "CategoryFilter"

				local v12 = k == "CanAnimateCameraBasedMood" and item2 == false

				local v13 = k == "CategoryId" or k == "SubcategoryId" or k == "isSubcategory"

				if not (v10 and v11 or v12 or v13) then
					table.insert(
						result,
						string.format("%s: missing in SDUI (Legacy has: %s)", v9, (tostring(item2)))
					)
				end
			elseif item == nil or item2 ~= nil then
				if item ~= nil and item2 ~= nil then
					local v10 = deepCompareTables(item, item2, v9)

					for k2, v11 in v10 do
						table.insert(result, v11)
					end
				end
			else
				local v10 = k == "WidgetContext" or k == "LocalizedTitle"

				local v11 = k == "DisableFilters" and item == false

				local v12 = k == "CanAnimateCameraBasedMood" and item == false

				local v13 = k == "ShowLooksAsOrganicContent" and item == false

				local v14 = k == "CategoryId" or k == "SubcategoryId" or k == "isSubcategory"

				if not (v10 or v11 or v12 or v13 or v14) then
					table.insert(
						result,
						string.format("%s: missing in Legacy (SDUI has: %s)", v9, (tostring(item)))
					)
				end
			end
		end

		return result
	end
end

local function compareCategories(item, items)
	local v9 = {}
	local v10 = {}

	for k, v11 in item do
		if k ~= "Subcategories" then
			v9[k] = v11
		end
	end

	for k, item2 in items do
		if k ~= "Subcategories" then
			v10[k] = item2
		end
	end

	return (deepCompareTables(v9, v10, item.Name or "Unknown"))
end

local function compareSubcategories(p2, p3)
	print("compareSubcategories", p2, p3)
	return (deepCompareTables(p2, p3, p2.Name or "Unknown"))
end

local function logSubcategoryDifferences(subcategories, subcategories2, name)
	for k, item in subcategories do
		local v9 = nil

		for k2, item2 in subcategories2 do
			local v11 = item.Name == item2.Id

			local v12 = item.Name == "Bundles" and item2.Id == "AnimationBundles"

			local v13 = item.Name == "T-Shirts" and item2.Id == "TShirts"

			local v14 = item.Name == "Dresses & Pants" and item2.Id == "DressSkirt"

			local v15 = item.Name == "Heads" and item.Id == "22" and item2.Id == "Hats"

			if v11 or v12 or v13 or v14 or v15 then
				v9 = item2
				break
			end
		end

		if v9 then
			print("compareSubcategories", item, v9)
			local v11 = deepCompareTables(item, v9, item.Name or "Unknown")

			if #v11 > 0 then
				warn(string.format(
					"[GetCatalogCategoriesSDUI] Differences found for subcategory '%s' in category '%s':",
					item.Name,
					name
				))

				for k2, v12 in v11 do
					warn(string.format("  - %s", v12))
				end
			end
		else
			warn(string.format(
				"[GetCatalogCategoriesSDUI] No matching legacy subcategory found for SDUI subcategory '%s' in category '%s'",
				item.Name,
				name
			))
		end
	end
end

return {
	logCategoryDifferences = function(items, items2)
		for k, item in items do
			print("sduiCategory", item)
			local v9 = nil

			for k2, item2 in items2 do
				local v11 = item.Name == item2.Id or item.Name == item2.Name
				local v12

				if
					item.Name == "Animations"
					and (item2.Id == "AllAnimations" or item2.Name == "AllAnimations")
				then
					v12 = true
				else
					v12 = item.Name == "AllAnimations"
						and (item2.Id == "Animations" or item2.Name == "Animations")
				end

				if v11 or v12 then
					print("matchingLegacyCategory", item2)
					v9 = item2
					break
				end
			end

			if v9 then
				local v11 = compareCategories(item, v9)

				if #v11 > 0 then
					warn(string.format(
						"[GetCatalogCategoriesSDUI] Differences found for category '%s':",
						item.Name
					))

					for k2, v12 in v11 do
						warn(string.format("  - %s", v12))
					end
				end

				if item.Subcategories and v9.Subcategories then
					logSubcategoryDifferences(item.Subcategories, v9.Subcategories, item.Name)
				elseif item.Subcategories and not v9.Subcategories then
					warn(string.format(
						"[GetCatalogCategoriesSDUI] SDUI category '%s' has subcategories but legacy category does not",
						item.Name
					))
				elseif not item.Subcategories and v9.Subcategories then
					warn(string.format(
						"[GetCatalogCategoriesSDUI] Legacy category '%s' has subcategories but SDUI category does not",
						item.Name
					))
				end
			else
				warn(string.format(
					"[GetCatalogCategoriesSDUI] No matching legacy category found for SDUI category '%s'",
					item.Name
				))
			end
		end
	end
}
