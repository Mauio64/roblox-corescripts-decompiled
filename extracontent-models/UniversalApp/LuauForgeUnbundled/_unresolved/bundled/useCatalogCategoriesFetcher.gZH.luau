local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.LuauPolyfill)
local Promise = require(CorePackages.Packages.Promise)

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/egx")
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService

local module2 = require("@luauforge/bundled/dSW")
local module3 = require("@luauforge/bundled/dSZ")
local module4 = require("@luauforge/bundled/gZI")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local api = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Api

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXCatalogCategoriesSDUIDebugDiff = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUIDebugDiff
local fFlagAXCatalogCategoriesSDUILinks = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUILinks

local function useCatalogCategoriesFetcher()
	local v5 = useRoactService(module)

	local v6 = if fFlagAXCatalogCategoriesSDUILinks then useDispatch() else nil

	return (React.useCallback(function(p2)
		local catalogCategoriesStore = module2.getCatalogCategoriesStore()

		if
			fFlagAXCatalogCategoriesSDUI
			and catalogCategoriesStore.getHasFetchedCategories(false)
			and not p2
		then
			return Promise.resolve(nil)
		end

		local catalogCategories, v7 = api.getCatalogCategories(v5, 1)

		return (catalogCategories:andThen(function(items)
			if not items then
				logging.warn("fetchCatalogCategories: categoriesResponse is nil")
				return
			end

			local v8 = module3()

			if fFlagAXCatalogCategoriesSDUIDebugDiff then
				module4.logCategoryDifferences(items, v8)
			end

			local result = { v8[1] }

			for k, item in items do
				if item.Id ~= "1" then
					table.insert(result, item)
				end
			end

			catalogCategoriesStore.setCategories(result)

			if fFlagAXCatalogCategoriesSDUILinks then
				local v9 = catalogCategoriesStore.setHasFetchedCategories(true)

				if fFlagAXCatalogCategoriesSDUILinks and v9 and v6 then
					v6(v9)
				end
			end

			return result
		end):catch(function(message)
			logging.warn("fetchCatalogCategories error: " .. tostring(message))

			if fFlagAXCatalogCategoriesSDUI then
				error(message)
			end
		end))
	end, { v5 }))
end

return useCatalogCategoriesFetcher
