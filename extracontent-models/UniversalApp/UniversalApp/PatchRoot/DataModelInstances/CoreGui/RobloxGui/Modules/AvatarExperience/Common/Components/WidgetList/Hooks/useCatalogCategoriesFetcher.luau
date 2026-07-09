local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(CorePackages.Packages.LuauPolyfill)

local Promise = require(CorePackages.Packages.Promise)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local RoactNetworking = require(game:GetService("CoreGui").RobloxGui.Modules.LuaApp.Services.RoactNetworking)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local GetCatalogCategories = require(Modules.AvatarExperience.Catalog.GetCatalogCategories)
local CatalogCategoryDiffUtils = require(Modules.AvatarExperience.Common.Debug.CatalogCategoryDiffUtils)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local Api = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Api
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXCatalogCategoriesSDUIDebugDiff = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUIDebugDiff
local FFlagAXCatalogCategoriesSDUILinks = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUILinks

local function useCatalogCategoriesFetcher() -- line: 66
	-- upvalues: useRoactService (copy), RoactNetworking (copy), FFlagAXCatalogCategoriesSDUILinks (copy), useDispatch (copy), React (copy), GetCatalogCategoriesStore (copy), FFlagAXCatalogCategoriesSDUI (copy), Promise (copy), Api (copy), Logging (copy), GetCatalogCategories (copy), FFlagAXCatalogCategoriesSDUIDebugDiff (copy), CatalogCategoryDiffUtils (copy)
	local v18 = useRoactService(RoactNetworking)
	local v19 = if not FFlagAXCatalogCategoriesSDUILinks then nil else useDispatch()

	return (React.useCallback(function(b1: boolean?) -- line: 72
		-- upvalues: GetCatalogCategoriesStore (copy), FFlagAXCatalogCategoriesSDUI (copy), Promise (copy), Api (copy), v18 (copy), Logging (copy), GetCatalogCategories (copy), FFlagAXCatalogCategoriesSDUIDebugDiff (copy), CatalogCategoryDiffUtils (copy), FFlagAXCatalogCategoriesSDUILinks (copy), v19 (copy)
		local v21 = GetCatalogCategoriesStore.getCatalogCategoriesStore()

		if FFlagAXCatalogCategoriesSDUI and (v21.getHasFetchedCategories(false) and not b1) then
			return Promise.resolve(nil)
		end

		local v22, _ = Api.getCatalogCategories(v18, 1)

		return (v22:andThen(function(p1) -- line: 86
			-- upvalues: Logging (copy), GetCatalogCategories (copy), FFlagAXCatalogCategoriesSDUIDebugDiff (copy), CatalogCategoryDiffUtils (copy), v21 (copy), FFlagAXCatalogCategoriesSDUILinks (copy), v19 (copy)
			if not p1 then
				Logging.warn("fetchCatalogCategories: categoriesResponse is nil")

				return
			end

			local v25 = GetCatalogCategories()

			if FFlagAXCatalogCategoriesSDUIDebugDiff then
				CatalogCategoryDiffUtils.logCategoryDifferences(p1, v25)
			end

			local t1 = { v25[1] }

			for _, v28 in p1 do
				if v28.Id ~= "1" then
					table.insert(t1, v28)
				end
			end

			v21.setCategories(t1)

			if FFlagAXCatalogCategoriesSDUILinks then
				local v29 = v21.setHasFetchedCategories(true)

				if FFlagAXCatalogCategoriesSDUILinks and v29 and v19 then
					v19(v29)
				end
			end

			return t1
		end):catch(function(p2) -- line: 121
			-- upvalues: Logging (copy), FFlagAXCatalogCategoriesSDUI (copy)
			Logging.warn("fetchCatalogCategories error: " .. tostring(p2))

			if FFlagAXCatalogCategoriesSDUI then
				error(p2)
			end
		end))
	end, { v18 }))
end

return useCatalogCategoriesFetcher
