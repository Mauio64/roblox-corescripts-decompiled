local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local FetchWidgetInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchWidgetInfo)
local FetchHydratedWidgetContent = require(Modules.AvatarExperience.Catalog.Thunks.FetchHydratedWidgetContent)
local getContentToHyderate = require(Modules.AvatarExperience.Common.Components.WidgetList.Utils.getContentToHyderate)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Promise = require(CorePackages.Packages.Promise)

require(Modules.AvatarExperience.Catalog.Reducers.Categories)

local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local mutedError = require(Modules.LuaApp.mutedError)
local FFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local FFlagAXFixHydratedWidgetsParams = AvatarExperienceFlags.FFlagAXFixHydratedWidgetsParams
local FFlagAXOnlyHydrateVisibleRows = AvatarExperienceFlags.FFlagAXOnlyHydrateVisibleRows
local FIntAXPrefetchWidgetHydrationRowsPortrait = AvatarExperienceFlags.FIntAXPrefetchWidgetHydrationRowsPortrait
local FIntAXPrefetchWidgetHydrationRowsLandscape = AvatarExperienceFlags.FIntAXPrefetchWidgetHydrationRowsLandscape

local function selectCatalogCategories(p1) -- line: 41
	return p1.AvatarExperience.Catalog.Categories
end
local function selectWidgetsState(p2) -- line: 45
	return p2.AvatarExperience and (p2.AvatarExperience.Common and p2.AvatarExperience.Common.Widgets)
end
local function getWidgetContext(p3) -- line: 49
	-- upvalues: CatalogUtils (copy), AvatarScreen (copy)
	local v26 = nil
	local categoryId = p3.categoryId
	local subcategoryId = p3.subcategoryId

	if categoryId then
		v26 = CatalogUtils.getContextForWidgetsById(AvatarScreen.Catalog, categoryId, subcategoryId)
	end

	return v26
end
local function fetchHydratedWidgets(p4, p5, p6, p7, s1: string?, s2: string?) -- line: 61
	-- upvalues: Promise (copy), FFlagAXFixHydratedWidgetsParams (copy), mutedError (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogUtils (copy), AvatarScreen (copy), FetchWidgetInfo (copy), FFlagAXMoveAllTabToWidgetOnly (copy), getContentToHyderate (copy), FFlagAXOnlyHydrateVisibleRows (copy), selectIsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsLandscape (copy), FetchHydratedWidgetContent (copy), Logging (copy)
	return Promise.new(function(resolve, reject) -- line: 69
		-- upvalues: FFlagAXFixHydratedWidgetsParams (copy), s1 (copy), mutedError (copy), s2 (copy), p6 (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogUtils (copy), AvatarScreen (copy), p4 (copy), FetchWidgetInfo (copy), p5 (copy), p7 (copy), FFlagAXMoveAllTabToWidgetOnly (copy), getContentToHyderate (copy), FFlagAXOnlyHydrateVisibleRows (copy), selectIsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsLandscape (copy), FetchHydratedWidgetContent (copy), Logging (copy)
		local t1

		if FFlagAXFixHydratedWidgetsParams then
			if s1 == nil then
				mutedError("[fetchHydratedWidgets] categoryId is required")
			end

			t1 = {
				categoryId = s1,
				subcategoryId = s2
			}
		else
			t1 = {
				categoryId = p6.Id,
				subcategoryId = if not FFlagAXFixHydratedWidgetsParams then p6.subcategoryId else nil,
				category = if not FFlagAXFixHydratedWidgetsParams then p6.Category or 1 else nil,
				subcategory = if not FFlagAXFixHydratedWidgetsParams then p6.Subcategory or 0 else nil
			}
		end

		local WidgetContext

		if FFlagAXCatalogCategoriesSDUI then
			WidgetContext = p6.WidgetContext
		else
			WidgetContext = nil

			local categoryId = t1.categoryId
			local subcategoryId = t1.subcategoryId

			if categoryId then
				WidgetContext = CatalogUtils.getContextForWidgetsById(AvatarScreen.Catalog, categoryId, subcategoryId)
			end
		end

		local v41 = p4(FetchWidgetInfo(p5, nil, WidgetContext))

		if v41 and v41.andThen then
			v41:andThen(function(p8) -- line: 91
				-- upvalues: p7 (copy), CatalogUtils (copy), AvatarScreen (copy), FFlagAXMoveAllTabToWidgetOnly (copy), getContentToHyderate (copy), FFlagAXOnlyHydrateVisibleRows (copy), selectIsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsLandscape (copy), resolve (copy), p4 (copy), FetchHydratedWidgetContent (copy), p5 (copy)
				local v43 = p7:getState()
				local v44 = v43.AvatarExperience and (v43.AvatarExperience.Common and v43.AvatarExperience.Common.Widgets)
				local v45 = v44 and v44.HydratedWidgetData or {}
				local v46 = v44 and v44.ContextWidgetInfo or {}
				local Categories = v43.AvatarExperience.Catalog.Categories
				local v48 = nil
				local categoryId = Categories.categoryId
				local subcategoryId = Categories.subcategoryId

				if categoryId then
					v48 = CatalogUtils.getContextForWidgetsById(AvatarScreen.Catalog, categoryId, subcategoryId)
				end

				local v51 = v48 and v46[v48] or nil
				local v52 = v51 and v51.Details or {}
				local n1 = 0

				if FFlagAXMoveAllTabToWidgetOnly then
					local t2 = {}

					for _, v56 in v52 do
						local v57 = getContentToHyderate(v56, v45)

						if v57 and #v57 > 0 then
							n1 += 1
							table.insert(t2, {
								content = v57,
								id = v56.id
							})
						end
					end

					if FFlagAXOnlyHydrateVisibleRows then
						local v58 = if not selectIsPortrait(v43) then FIntAXPrefetchWidgetHydrationRowsLandscape else FIntAXPrefetchWidgetHydrationRowsPortrait
						local t3 = {}

						for i = 1, math.min(#t2, v58) do
							table.insert(t3, t2[i])
						end

						t2 = t3
						n1 = #t2
					end

					if n1 == 0 then
						resolve(p8)

						return
					end

					local n2 = 0

					for _, v63 in t2 do
						task.spawn(function() -- line: 142
							-- upvalues: p4 (copy), FetchHydratedWidgetContent (copy), p5 (copy), v63 (copy), n2 (ref), n1 (ref), resolve (copy), p8 (copy)
							local v70 = p4(FetchHydratedWidgetContent(p5, v63.content, v63.id))

							if v70 and v70.andThen then
								v70:finally(function() -- line: 145
									-- upvalues: n2 (ref), n1 (ref), resolve (copy), p8 (copy)
									n2 += 1

									if n2 >= n1 then
										resolve(p8)
									end
								end)
							end
						end)
					end
				else
					local n3 = 0

					for _, v66 in v52 do
						local v67 = getContentToHyderate(v66, v45)

						if v67 and #v67 > 0 then
							n1 += 1

							local v68 = p4(FetchHydratedWidgetContent(p5, v67, v66.id))

							if v68 and v68.andThen then
								v68:finally(function() -- line: 167
									-- upvalues: n3 (ref), n1 (ref), resolve (copy), p8 (copy)
									n3 += 1

									if n3 >= n1 then
										resolve(p8)
									end
								end)
							end
						end
					end

					if n1 == 0 then
						resolve(p8)
					end
				end
			end, function(p9) -- line: 182
				-- upvalues: Logging (copy), reject (copy)
				Logging.warn("fetchHydratedWidgets: Hydrated widgets fetch failed: " .. tostring(p9))
				reject(p9)
			end)

			return
		end

		resolve(true)
	end)
end

return fetchHydratedWidgets
