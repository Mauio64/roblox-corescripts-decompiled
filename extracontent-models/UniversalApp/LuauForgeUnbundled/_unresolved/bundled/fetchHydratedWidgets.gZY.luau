local CorePackages = game:GetService("CorePackages")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/bundled/gZZ")
local module3 = require("@luauforge/bundled/haa")
local module4 = require("@luauforge/bundled/hab")
local module5 = require("@luauforge/bundled/dVl")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
require("@luauforge/bundled/dKT")
local Promise = require(CorePackages.Packages.Promise)
require("@luauforge/bundled/dSU")
local module6 = require("@luauforge/bundled/gJS")

local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local module7 = require("@luauforge/bundled/dFs")

local fFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local fFlagAXFixHydratedWidgetsParams = AvatarExperienceFlags.FFlagAXFixHydratedWidgetsParams
local fIntAXPrefetchWidgetHydrationRowsPortrait = AvatarExperienceFlags.FIntAXPrefetchWidgetHydrationRowsPortrait
local fIntAXPrefetchWidgetHydrationRowsLandscape = AvatarExperienceFlags.FIntAXPrefetchWidgetHydrationRowsLandscape

local function selectCatalogCategories(p2)
	return p2.AvatarExperience.Catalog.Categories
end

local function selectWidgetsState(p2)
	return p2.AvatarExperience and p2.AvatarExperience.Common and p2.AvatarExperience.Common.Widgets
end

local function getWidgetContext(p2)
	local categoryId = p2.categoryId
	local subcategoryId = p2.subcategoryId
	local widgetContext

	if categoryId then
		widgetContext = module5.getContextForWidgetsById(avatarScreen.Catalog, categoryId, subcategoryId)
	end

	return widgetContext
end

local function fetchHydratedWidgets(callback, p2, data, object, p3, p4)
	return Promise.new(function(callback2, callback3)
		local v5

		if fFlagAXFixHydratedWidgetsParams then
			if p3 == nil then
				module7("[fetchHydratedWidgets] categoryId is required")
			end

			v5 = { categoryId = p3, subcategoryId = p4 }
		else
			v5 = {
				categoryId = data.Id,
				subcategoryId = 0,
				category = 0,
				subcategory = 0
			}
			local v6 = if not fFlagAXFixHydratedWidgetsParams then data.subcategoryId else nil
			v5.subcategoryId = v6
			v5.category = not fFlagAXFixHydratedWidgetsParams and (data.Category or 1) or nil
			v5.subcategory = not fFlagAXFixHydratedWidgetsParams and (data.Subcategory or 0) or nil
		end

		local v6

		if fFlagAXCatalogCategoriesSDUI then
			v6 = data.WidgetContext
		else
			local categoryId = v5.categoryId
			local subcategoryId = v5.subcategoryId

			if categoryId then
				v6 = module5.getContextForWidgetsById(avatarScreen.Catalog, categoryId, subcategoryId)
			end
		end

		local v7 = callback(module2(p2, nil, v6))

		if v7 and v7.andThen then
			v7:andThen(function(p5)
				local state = object:getState()
				local widgets = state.AvatarExperience
					and state.AvatarExperience.Common
					and state.AvatarExperience.Common.Widgets

				local hydratedWidgetData = widgets and widgets.HydratedWidgetData or {}
				local contextWidgetInfo = widgets and widgets.ContextWidgetInfo or {}
				local categories = state.AvatarExperience.Catalog.Categories

				local categoryId = categories.categoryId
				local subcategoryId = categories.subcategoryId
				local v8

				if categoryId then
					v8 = module5.getContextForWidgetsById(avatarScreen.Catalog, categoryId, subcategoryId)
				end

				local v9 = v8 and contextWidgetInfo[v8] or nil
				local details = v9 and v9.Details or {}

				local count = 0

				if fFlagAXMoveAllTabToWidgetOnly then
					local v10 = {}

					for k, detail in details do
						local v11 = module4(detail, hydratedWidgetData)

						if not (v11 and #v11 > 0) then
							continue
						end

						count += 1
						table.insert(v10, { content = v11, id = detail.id })
					end

					local v11

					if module6(state) then
						v11 = fIntAXPrefetchWidgetHydrationRowsPortrait
					else
						v11 = fIntAXPrefetchWidgetHydrationRowsLandscape
					end

					local v12 = {}

					for i = 1, math.min(#v10, v11) do
						table.insert(v12, v10[i])
					end

					local count2 = #v12

					if count2 == 0 then
						callback2(p5)
						return
					end

					local count3 = 0

					for k, v13 in v12 do
						local function fn()
							local v14 = callback(module3(p2, v13.content, v13.id))

							if v14 and v14.andThen then
								v14:finally(function()
									count3 += 1

									if count2 <= count3 then
										callback2(p5)
									end
								end)
							end
						end

						task.spawn(fn)
					end
				else
					local count2 = 0

					for k, detail in details do
						local v10 = module4(detail, hydratedWidgetData)

						if not (v10 and #v10 > 0) then
							continue
						end

						count += 1
						local v11 = callback(module3(p2, v10, detail.id))

						if v11 and v11.andThen then
							v11:finally(function()
								count2 += 1

								if count <= count2 then
									callback2(p5)
								end
							end)
						end
					end

					if count == 0 then
						callback2(p5)
					end
				end
			end, function(p5)
				logging.warn("fetchHydratedWidgets: Hydrated widgets fetch failed: " .. tostring(p5))
				callback3(p5)
			end)
		else
			callback2(true)
		end
	end)
end

return fetchHydratedWidgets
