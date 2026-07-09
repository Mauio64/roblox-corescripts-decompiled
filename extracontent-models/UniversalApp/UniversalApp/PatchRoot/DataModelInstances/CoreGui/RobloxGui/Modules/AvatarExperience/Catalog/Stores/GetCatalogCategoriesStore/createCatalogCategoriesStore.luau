local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Signals = require(CorePackages.Packages.Signals)
local Modules = CoreGui.RobloxGui.Modules
local mutedError = require(Modules.LuaApp.mutedError)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local GetCatalogCategories = require(Modules.AvatarExperience.Catalog.GetCatalogCategories)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXCatalogCategoriesSDUILinks = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUILinks
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local v11 = if not FFlagAXMigrateAllTabToSduiDev then nil else require(CorePackages.Workspace.Packages.DataHydration)
local v12 = if not FFlagAXMigrateAllTabToSduiDev then nil else require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Sdui.createMapMarketplaceCategoryToCatalogCategory

local function createCatalogCategoriesStore() -- line: 48
	-- upvalues: Signals (copy), FFlagAXCatalogCategoriesSDUILinks (copy), FFlagAXMigrateAllTabToSduiDev (copy), v11 (copy), GetCatalogCategories (copy), v12 (copy), mutedError (copy), FFlagAXCatalogCategoriesSDUI (copy)
	local v14, v15 = Signals.createSignal(false)
	local u16 = nil
	local u17 = nil

	if FFlagAXCatalogCategoriesSDUILinks then
		local v18, v19 = Signals.createSignal(nil)

		u16 = v18
		u17 = v19
	end

	local function buildCategoryMap(t1: {[any]: any}) -- line: 61
		local t2 = {}

		for _, v40 in t1 do
			if v40 and v40.Id then
				local Subcategories = v40.Subcategories

				if Subcategories then
					local t3 = {}

					if Subcategories then
						for _, v44 in Subcategories do
							if v44.Id then
								t3[v44.Id] = v44
							end
						end
					end

					v40.SubcategoriesMap = t3
				end

				t2[v40.Id] = v40
			end
		end

		return t2
	end

	local u21 = nil
	local u25, v26, v28

	if FFlagAXMigrateAllTabToSduiDev then
		local v22 = v11.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false)
		local v23 = GetCatalogCategories()[1]
		local v24 = v12()

		u25 = Signals.createComputed(function(p1) -- line: 108
			-- upvalues: v22 (copy), buildCategoryMap (copy), v23 (copy), v24 (copy)
			local v46 = v22.getLastReceivedCategories(p1)

			if not next(v46) then
				return (buildCategoryMap({ v23 }))
			end

			local t4 = {}

			for _, v49 in v46 do
				if v49.subcategories then
					for _, v51 in v49.subcategories do
						t4[v51] = true
					end
				end
			end

			local t5 = {}

			for v53, v54 in v46 do
				if not t4[v53] then
					table.insert(t5, v24.map(v54, v46))
				end
			end

			local v55 = buildCategoryMap(t5)

			if not v55[v23.Id] then
				v55[v23.Id] = v23
			end

			return v55
		end)

		function v26(_) -- line: 152
			-- upvalues: mutedError (copy)
			mutedError("createCatalogCategoriesStore.getCategories called under FFlagAXMigrateAllTabToSduiDev; use `getCategoriesMap` (or `getCategoryOrSubcategory`) instead -- categories are sourced from MarketplaceCatalogCategory hydration.")

			return {}
		end

		local u27 = false

		function v28(_: {[any]: any}) -- line: 168
			-- upvalues: u27 (ref), mutedError (copy)
			if not u27 then
				u27 = true
				mutedError("createCatalogCategoriesStore.setCategories called under FFlagAXMigrateAllTabToSduiDev; categories are sourced from MarketplaceCatalogCategory hydration and this write is ignored.")
			end
		end

		local u29 = true

		u21 = Signals.createEffect(function(p3) -- line: 179
			-- upvalues: v22 (copy), u29 (ref), v24 (copy), v14 (copy), v15 (copy)
			local v59 = v22.getLastReceivedCategories(p3)
			local v60 = next(v59) == nil

			if v60 and not u29 then
				v24.clear()
			end

			u29 = v60

			if not v60 and not v14(false) then
				v15(true)
			end
		end)
	else
		local v30

		v26, v30 = Signals.createSignal(if not FFlagAXCatalogCategoriesSDUI then GetCatalogCategories() else { GetCatalogCategories()[1] })

		local v31, v32 = Signals.createSignal({})

		u25 = v31

		function v28(t7: {[any]: any}) -- line: 205
			-- upvalues: v30 (copy), v32 (copy), buildCategoryMap (copy)
			local v62 = table.clone(t7)

			v30(v62)
			v32((buildCategoryMap(v62)))
		end

		v32((buildCategoryMap(v26(false))))
	end

	local v33 = nil
	local u34 = nil
	local v35 = nil

	if FFlagAXCatalogCategoriesSDUILinks then
		function v33(p4) -- line: 220
			-- upvalues: u17 (ref)
			if u17 then
				u17(p4)
			end
		end
		function u34() -- line: 226
			-- upvalues: u17 (ref)
			if u17 then
				u17(nil)
			end
		end
		function v35(b1: boolean) -- line: 232
			-- upvalues: v15 (copy), u16 (ref), u34 (ref)
			v15(b1)

			if b1 and u16 then
				local v65 = u16(false)

				if v65 then
					if u34 then
						u34()
					end

					return v65
				end
			end

			return nil
		end
	end

	local v36 = nil

	if FFlagAXCatalogCategoriesSDUI then
		function v36(s1: string, s2: string?) -- line: 251
			-- upvalues: u25 (ref)
			local v68 = u25(false)[s1]

			if s2 == nil then
				return v68
			end

			if v68 == nil or v68.SubcategoriesMap == nil then
				return nil
			end

			return v68.SubcategoriesMap[s2]
		end
	end

	return {
		getCategories = v26,
		getCategoriesMap = u25,
		getCategoryOrSubcategory = v36,
		getHasFetchedCategories = v14,
		setCategories = v28,
		setHasFetchedCategories = if not FFlagAXCatalogCategoriesSDUILinks then v15 else v35,
		getPendingDeepLinkAction = u16,
		setPendingDeepLinkAction = v33,
		clearPendingDeepLinkAction = u34,
		dispose = function() -- line: 269
			-- upvalues: u21 (ref)
			if u21 then
				u21()
				u21 = nil
			end
		end
	}
end

return createCatalogCategoriesStore
