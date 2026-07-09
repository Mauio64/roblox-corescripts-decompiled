local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

require(Parent.AvatarExperienceCommon)
require(Parent.DataHydration)

local HttpService = game:GetService("HttpService")
local t1 = {
	AllAnimations = "AllAnimation",
	AnimationBundles = "Animation",
	Emotes = "Emotes"
}
local t2 = {
	Recommended = {
		Name = "All",
		CategoryFilter = "Recommended"
	},
	HighDefinition = {
		CategoryFilter = "HighDefinition"
	}
}

local function widgetContextFromName(s1: string) -- line: 48
	local v8 = s1:gsub(" ", "-"):gsub("%.", "-")

	return `catalog-tab:{ string.lower(v8) }`
end
local function createMapMarketplaceCategoryToCatalogCategory() -- line: 53
	-- upvalues: HttpService (copy), t2 (copy), t1 (copy)
	local t3 = {}

	local function getOrCreateSearchUuid(s2: string) -- line: 62
		-- upvalues: t3 (copy), HttpService (copy)
		local v13 = t3[s2]

		if v13 then
			return v13
		end

		local guid = HttpService:GenerateGUID(true)

		t3[s2] = guid

		return guid
	end
	local function mapInternal(p1, t4: {[any]: any}, b1: boolean?, t5: {[any]: any}) -- line: 79
		-- upvalues: mapInternal (ref), t2 (copy), t3 (copy), HttpService (copy), t1 (copy)
		t5[p1.id] = true

		local t6 = nil

		if p1.subcategories and #p1.subcategories > 0 then
			t6 = {}

			for _, v21 in p1.subcategories do
				if not t5[v21] then
					local v22 = t4[v21]

					if v22 then
						table.insert(t6, mapInternal(v22, t4, true, t5))
					end
				end
			end

			if #t6 == 0 then
				t6 = nil
			end
		end

		t5[p1.id] = nil

		local v23 = t2[p1.id]
		local t7 = {
			Id = p1.id,
			Name = if not v23 or not v23.Name then p1.name else v23.Name,
			CategoryFilter = if not v23 then nil else v23.CategoryFilter,
			Title = p1.title,
			LocalizedTitle = p1.title
		}
		local v25 = p1.name:gsub(" ", "-"):gsub("%.", "-")

		t7.WidgetContext = `catalog-tab:{ string.lower(v25) }`

		local id = p1.id
		local v27 = t3[id]

		if v27 then
		else
			v27 = HttpService:GenerateGUID(true)
			t3[id] = v27
		end

		t7.SearchUuid = v27
		t7.TaxonomyUuid = p1.taxonomyId
		t7.AssetTypeIdStrings = p1.assetTypes
		t7.BundleTypes = p1.bundleTypes
		t7.TileType = p1.tileType
		t7.TimeToRefresh = p1.timeToRefresh
		t7.CategoryId = p1.categoryId
		t7.SubcategoryId = p1.subcategoryId
		t7.CameraFocus = p1.cameraFocus
		t7.CameraZoomRadius = p1.cameraZoomRadius
		t7.CanAnimateCameraBasedMood = p1.canAnimateCameraBasedMood
		t7.LooksWidgetContextForOrganicContent = p1.looksWidgetContextForOrganicContent
		t7.PageType = t1[p1.name]
		t7.Subcategories = t6
		t7.isSubcategory = not not b1 or nil

		return t7
	end

	return {
		map = function(p2, t8: {[any]: any}, b2: boolean?) -- line: 146
			-- upvalues: mapInternal (ref)
			return mapInternal(p2, t8, b2, {})
		end,
		clear = function() -- line: 154
			-- upvalues: t3 (copy)
			table.clear(t3)
		end
	}
end

return createMapMarketplaceCategoryToCatalogCategory
