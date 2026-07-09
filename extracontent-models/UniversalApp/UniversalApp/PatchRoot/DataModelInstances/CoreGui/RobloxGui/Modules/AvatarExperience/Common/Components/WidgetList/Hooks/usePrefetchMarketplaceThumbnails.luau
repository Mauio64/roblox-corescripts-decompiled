local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local tutils = require(CorePackages.Packages.tutils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local fetchCatalogItemThumbnails = require(Modules.AvatarExperience.Common.Components.WidgetList.Utils.fetchCatalogItemThumbnails)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Utils2 = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.Types)

local useGetSelectedCategoryAndSubcategoryId = require(Modules.AvatarExperience.Catalog.Hooks.useGetSelectedCategoryAndSubcategoryId)
local v13 = game:DefineFastInt("AXMaxThumbnailsToPrefetchPerWidgetLargeScreen", 4)
local v14 = game:DefineFastInt("AXMaxThumbnailsToPrefetchPerWidgetSmallScreen", 3)

local function selectContextWidgetInfo(p1) -- line: 43
	return p1.AvatarExperience.Common.Widgets.ContextWidgetInfo
end
local function selectSearchesInCatalog(p2) -- line: 47
	return p2.Search.SearchesInCatalog
end
local function usePrefetchMarketplaceThumbnails() -- line: 51
	-- upvalues: useGetSelectedCategoryAndSubcategoryId (copy), useSelector (copy), selectContextWidgetInfo (copy), tutils (copy), CatalogUtils (copy), AvatarScreen (copy), selectSearchesInCatalog (copy), Utils2 (copy), Utils (copy), Responsive (copy), v13 (copy), v14 (copy), React (copy), fetchCatalogItemThumbnails (copy)
	local v20, v21 = useGetSelectedCategoryAndSubcategoryId()
	local v22 = useSelector(selectContextWidgetInfo, tutils.deepEqual)
	local v23 = nil

	if v20 then
		v23 = CatalogUtils.getContextForWidgetsById(AvatarScreen.Catalog, v20, v21)
	end

	local v24 = if not v23 then nil else v22[v23]
	local v25 = useSelector(selectSearchesInCatalog, tutils.deepEqual)
	local v26 = if not v20 then nil else Utils2.getCatalogCategoryInfoById(v20, v21)
	local v27 = if not v26 then nil else Utils.getSearchUuidAndAssetTypes(v26, nil, nil)
	local v28 = if not v27 then nil else v25[v27]
	local v29 = if not v28 then nil else v28.items
	local v30 = Responsive.useResponsive()
	local v31 = v30 ~= Responsive.BreakpointConfig.Enum.Medium and (v30 ~= Responsive.BreakpointConfig.Enum.Small and v30 ~= Responsive.BreakpointConfig.Enum.XSmall)
	local v32 = if not v31 then v14 else v13
	local v33 = if not v31 then v14 else v13
	local v34 = if not v31 then v14 else v13

	return (React.useCallback(function() -- line: 87
		-- upvalues: v24 (copy), v33 (copy), v32 (copy), v29 (copy), v34 (copy), fetchCatalogItemThumbnails (copy)
		local t1 = {}
		local n1 = 0
		local n2 = 0

		if v24 and v24.Details then
			local function addWidgetThumbnails(p3) -- line: 94
				-- upvalues: v33 (copy), n1 (ref), v32 (copy), t1 (copy)
				if v33 and n1 >= v33 then
					return false
				end

				if not p3 then
					return true
				end

				if p3.content and #p3.content > 0 then
					for i = 1, math.min(v32, #p3.content) do
						local v48 = p3.content[i]

						table.insert(t1, {
							id = tostring(v48.id),
							type = v48.type
						})
					end

					n1 += 1
				end

				return true
			end

			local t2 = {}

			for v40, _ in v24.Details do
				if tonumber(v40) ~= nil then
					table.insert(t2, (tonumber(v40)))
				end
			end

			table.sort(t2)

			for _, v43 in t2 do
				if not addWidgetThumbnails(v24.Details[tostring(v43)]) then
					break
				end
			end
		end

		if v29 and #v29 > 0 then
			for i = 1, math.min(v34, #v29) do
				local v45 = v29[i]

				if v45.id and v45.type then
					table.insert(t1, {
						id = tostring(v45.id),
						type = v45.type
					})
					n2 += 1
				end
			end
		end

		if #t1 > 0 then
			fetchCatalogItemThumbnails(t1)
		end

		return t1
	end, {
		v24,
		v29,
		v32,
		v33,
		v34
	}))
end

return usePrefetchMarketplaceThumbnails
