local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local tutils = require(CorePackages.Packages.tutils)

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getCatalogPageThumbnailPrefetchItems = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Sdui.getCatalogPageThumbnailPrefetchItems
local fFlagAXPrefetchSduiWidgetThumbnails = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPrefetchSduiWidgetThumbnails

local module2 = require("@luauforge/bundled/fCI")
local module3 = require("@luauforge/bundled/dVl")

local module4 = require("@luauforge/bundled/iqf")
require("@luauforge/bundled/dKT")
local module5 = require("@luauforge/bundled/fCe")
require("@luauforge/bundled/dPs")

local module6 = require("@luauforge/bundled/gZG")
local module7 = require("@luauforge/bundled/gZF")
local module8 = require("@luauforge/bundled/dSW")
local module9 = require("@luauforge/bundled/dPN")

local module10 = require("@luauforge/bundled/hag")

local defineFastInt = game:DefineFastInt("AXMaxThumbnailsToPrefetchPerWidgetLargeScreen", 4)

local defineFastInt2 = game:DefineFastInt("AXMaxThumbnailsToPrefetchPerWidgetSmallScreen", 3)

local function selectContextWidgetInfo(p2)
	return p2.AvatarExperience.Common.Widgets.ContextWidgetInfo
end

local function selectSearchesInCatalog(p2)
	return p2.Search.SearchesInCatalog
end

local function usePrefetchMarketplaceThumbnails()
	local v5, v6 = module6()
	local v7 = useSelector(selectContextWidgetInfo, tutils.deepEqual)

	local v8 = if v5 then module3.getContextForWidgetsById(avatarScreen.Catalog, v5, v6) else nil

	local v9 = if v8 then v7[v8] else nil
	local widgetContext

	if fFlagAXPrefetchSduiWidgetThumbnails then
		local v10 = module10()
		local v11 = useSignalState(module8.getCatalogCategoriesStore().getCategoriesMap)
		local v12 = module7()
		local v13 = module5.getCategoryInfoById(v11, v5 or module9.DefaultCatalogCategoryId, v6) or v12

		widgetContext = if v10 and v13 then v13.WidgetContext else nil
	else
		widgetContext = nil
	end

	local v10 = useSelector(selectSearchesInCatalog, tutils.deepEqual)

	local v11 = if v5 then module5.getCatalogCategoryInfoById(v5, v6) else nil

	local v12 = if v11 then module2.getSearchUuidAndAssetTypes(v11, nil, nil) else nil

	local v13 = if v12 then v10[v12] else nil
	local items = if v13 then v13.items else nil

	local v14 = Responsive.useResponsive()
	local v15

	if v14 == Responsive.BreakpointConfig.Enum.Medium or v14 == Responsive.BreakpointConfig.Enum.Small then
		v15 = false
	else
		v15 = v14 ~= Responsive.BreakpointConfig.Enum.XSmall
	end

	local v16 = if v15 then defineFastInt else defineFastInt2
	local v17 = if v15 then defineFastInt else defineFastInt2
	local v18 = if v15 then defineFastInt else defineFastInt2

	local function fn()
		local result = {}
		local count = 0
		local count2 = 0

		if fFlagAXPrefetchSduiWidgetThumbnails and widgetContext then
			for k, v19 in getCatalogPageThumbnailPrefetchItems(widgetContext, v17, v16) do
				table.insert(result, { id = tostring(v19.id), type = v19.type })
			end
		elseif v9 and v9.Details then
			local function addWidgetThumbnails(p2): boolean
				if v17 and v17 <= count then
					return false
				end

				if not p2 then
					return true
				end

				if p2.content and #p2.content > 0 then
					for i = 1, math.min(v16, #p2.content) do
						local v19 = p2.content[i]
						table.insert(result, { id = tostring(v19.id), type = v19.type })
					end

					count += 1
				end

				return true
			end

			local v19 = {}

			for k, detail in v9.Details do
				if tonumber(k) ~= nil then
					table.insert(v19, (tonumber(k)))
				end
			end

			table.sort(v19)

			for k, v21 in v19 do
				if not addWidgetThumbnails(v9.Details[tostring(v21)]) then
					break
				end
			end
		end

		if items and #items > 0 then
			for i = 1, math.min(v18, #items) do
				local item = items[i]

				if not (item.id and item.type) then
					continue
				end

				table.insert(result, { id = tostring(item.id), type = item.type })

				count2 += 1
			end
		end

		if #result > 0 then
			module4(result)
		end

		return result
	end

	return (React.useCallback(fn, {
		v9,
		items,
		v16,
		v17,
		v18,
		if fFlagAXPrefetchSduiWidgetThumbnails then widgetContext else nil
	}))
end

return usePrefetchMarketplaceThumbnails
