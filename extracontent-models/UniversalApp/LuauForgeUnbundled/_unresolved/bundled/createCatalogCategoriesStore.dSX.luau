local CorePackages = game:GetService("CorePackages")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local Signals = require(CorePackages.Packages.Signals)

local module2 = require("@luauforge/bundled/dFs")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/bundled/dSY")
local module4 = require("@luauforge/bundled/dSZ")

require("@luauforge/bundled/dPD")

local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXCatalogCategoriesSDUILinks = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUILinks
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local createMapMarketplaceCategoryToCatalogCategory

if fFlagAXMigrateAllTabToSduiDev then
	createMapMarketplaceCategoryToCatalogCategory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Sdui.createMapMarketplaceCategoryToCatalogCategory
else
	createMapMarketplaceCategoryToCatalogCategory = nil
end

local function createCatalogCategoriesStore()
	local signal, v5 = Signals.createSignal(false)
	local v6, v7

	if fFlagAXCatalogCategoriesSDUILinks or fFlagAXMigrateAllTabToSduiDev then
		v6, v7 = Signals.createSignal(nil)
	else
		v7 = nil
		v6 = nil
	end

	local function buildCategoryMap(items)
		local categoryMap = {}

		for k, item in items do
			if not (item and item.Id) then
				continue
			end

			local subcategories = item.Subcategories

			if subcategories then
				local subcategoriesById = {}

				for k2, subcategory in subcategories do
					if subcategory.Id then
						subcategoriesById[subcategory.Id] = subcategory
					end
				end

				item.SubcategoriesMap = subcategoriesById
			end

			categoryMap[item.Id] = item
		end

		return categoryMap
	end

	local v8 = nil
	local v9, v10, setCategories

	if fFlagAXMigrateAllTabToSduiDev then
		local getLastReceivedCategories = module3.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).getLastReceivedCategories

		local v11 = module4()[1]

		local mapMarketplaceCategoryToCatalogCategory = createMapMarketplaceCategoryToCatalogCategory()

		local signal2, v12 = Signals.createSignal({})

		v9 = Signals.createComputed(function(p2)
			local v13 = getLastReceivedCategories(p2)

			if not next(v13) then
				return buildCategoryMap({ v11 })
			end

			local v14 = signal2(p2)

			if next(v14) then
				local clone = table.clone(v14)

				for k, v15 in v13 do
					clone[k] = v15
				end

				v13 = clone
			end

			local subcategorySet = {}

			for k, v15 in v13 do
				if not v15.subcategories then
					continue
				end

				for k2, subcategory in v15.subcategories do
					subcategorySet[subcategory] = true
				end
			end

			local values = {}

			for k, v15 in v13 do
				if not subcategorySet[k] then
					table.insert(values, mapMarketplaceCategoryToCatalogCategory.map(v15, v13))
				end
			end

			local categoryMap = buildCategoryMap(values)

			if not categoryMap[v11.Id] then
				categoryMap[v11.Id] = v11
			end

			return categoryMap
		end)

		v10 = function(p2)
			module2("createCatalogCategoriesStore.getCategories called under FFlagAXMigrateAllTabToSduiDev; use `getCategoriesMap` (or `getCategoryOrSubcategory`) instead -- categories are sourced from MarketplaceCatalogCategory hydration.")

			return {}
		end

		local v13 = false
		setCategories = function(p2)
			if not v13 then
				v13 = true
				module2("createCatalogCategoriesStore.setCategories called under FFlagAXMigrateAllTabToSduiDev; categories are sourced from MarketplaceCatalogCategory hydration and this write is ignored.")
			end
		end

		local v14 = true
		v8 = Signals.createEffect(function(p2)
			local lastReceivedCategories = getLastReceivedCategories(p2)
			local v15 = next(lastReceivedCategories) == nil

			if v15 and not v14 then
				mapMarketplaceCategoryToCatalogCategory.clear()
			end

			v14 = v15

			local v16 = signal2(false)

			if v15 then
				if next(v16) then
					v12({})
				end
			else
				local clone = table.clone(v16)
				local flag = false

				for k, lastReceivedCategory in lastReceivedCategories do
					if clone[k] == lastReceivedCategory then
						continue
					end

					clone[k] = lastReceivedCategory
					flag = true
				end

				if flag then
					v12(clone)
				end
			end

			if not (v15 or signal(false)) then
				v5(true)
			end
		end)
	else
		local v11

		if fFlagAXCatalogCategoriesSDUI then
			v11 = { module4()[1] }
		else
			v11 = module4()
		end

		local v12
		v10, v12 = Signals.createSignal(v11)
		local v13
		v9, v13 = Signals.createSignal({})

		v13(buildCategoryMap(v10(false)))

		setCategories = function(p2)
			local clone = table.clone(p2)
			v12(clone)
			v13(buildCategoryMap(clone))
		end
	end

	local fn, fn2, v11

	if fFlagAXCatalogCategoriesSDUILinks or fFlagAXMigrateAllTabToSduiDev then
		fn = function(p2)
			if v7 then
				v7(p2)
			end
		end

		fn2 = function()
			if v7 then
				v7(nil)
			end
		end

		v11 = function(p2)
			v5(p2)

			local v12 = p2 and v6 and v6(false)

			if not v12 then
				return nil
			end

			if fn2 then
				fn2()
			end

			return v12
		end
	else
		fn2 = nil
	end

	local function dispose()
		if v8 then
			v8()
			v8 = nil
		end
	end

	local catalogCategoriesStore = {
		getCategories = v10,
		getCategoriesMap = v9,
		getCategoryOrSubcategory = (fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev) and function(p2, p3)
			local v12 = v9(false)[p2]

			if p3 == nil then
				if not fFlagAXMigrateAllTabToSduiDev or v12 ~= nil then
					return v12
				end

				for k, v13 in v9(false) do
					local subcategoriesMap = v13.SubcategoriesMap
					local v14 = if subcategoriesMap then subcategoriesMap[p2] else nil

					if v14 then
						return v14
					end
				end

				return v12
			elseif v12 == nil or v12.SubcategoriesMap == nil then
				return nil
			else
				return v12.SubcategoriesMap[p3]
			end
		end or nil,
		getHasFetchedCategories = signal,
		setCategories = setCategories,
		setHasFetchedCategories = 0,
		getPendingDeepLinkAction = 0,
		setPendingDeepLinkAction = 0,
		clearPendingDeepLinkAction = 0,
		dispose = 0
	}

	if not (fFlagAXCatalogCategoriesSDUILinks or fFlagAXMigrateAllTabToSduiDev) then
		v11 = v5
	end

	catalogCategoriesStore.setHasFetchedCategories = v11

	catalogCategoriesStore.getPendingDeepLinkAction = v6
	catalogCategoriesStore.setPendingDeepLinkAction = fn
	catalogCategoriesStore.clearPendingDeepLinkAction = fn2
	catalogCategoriesStore.dispose = dispose
	return catalogCategoriesStore
end

return createCatalogCategoriesStore
