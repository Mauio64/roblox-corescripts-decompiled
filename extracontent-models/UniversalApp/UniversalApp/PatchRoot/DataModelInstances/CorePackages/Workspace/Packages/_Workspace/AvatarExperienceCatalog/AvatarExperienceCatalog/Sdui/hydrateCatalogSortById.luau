local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent

require(AvatarExperienceCatalogParent.AvatarExperienceRodux)

local DataHydration = require(AvatarExperienceCatalogParent.DataHydration)
local Promise = require(AvatarExperienceCatalogParent.Promise)
local Logging = require(AvatarExperienceCatalogParent.AppCommonLib).Logging

require(AvatarExperienceCatalogParent.Http)
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local collectDedupedHydrationContent = require(AvatarExperienceCatalog.Sdui.Utils.collectDedupedHydrationContent)
local buildHydrationReduxPayload = require(AvatarExperienceCatalog.Sdui.Utils.buildHydrationReduxPayload)

local function hydrateCatalogSortById(p1: ((...any) -> ...any), p2, p3: ((...any) -> ...any), t1: {[any]: any}, s1: string, t2: {[any]: any}?) -- line: 31
	-- upvalues: DataHydration (copy), Promise (copy), collectDedupedHydrationContent (copy), buildHydrationReduxPayload (copy), Logging (copy)
	local v15 = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).getMarketplaceCatalogSort(s1)
	local v16 = if not v15 or not v15.data then nil else v15.data(false)

	if not v16 or not v16.content then
		return Promise.resolve()
	end

	local t3 = {}

	collectDedupedHydrationContent(v16.content, t3, {}, nil)

	local t4

	if t2 then
		t4 = {}

		for _, v20 in t3 do
			local v21 = t2[tostring(v20.type)]

			if not v21 or not v21[tostring(v20.id)] then
				table.insert(t4, v20)
			end
		end
	else
		t4 = t3
	end

	if #t4 == 0 then
		return Promise.resolve()
	end

	return t1.HydrateWidgetContent(p2, t4):andThen(function(p4) -- line: 76
		-- upvalues: buildHydrationReduxPayload (copy), t4 (ref), p1 (copy), p3 (copy)
		local v23 = if not p4 then nil else p4.responseBody
		local v24 = if not v23 then nil else v23.hydratedContent

		if v24 == nil then
			return
		end

		local v25 = buildHydrationReduxPayload(v24, t4)

		p1(p3(v25))
	end):catch(function(p5) -- line: 86
		-- upvalues: Logging (copy), s1 (copy)
		Logging.warn("hydrateCatalogSortById: HydrateWidgetContent failed for sort " .. s1 .. ": " .. tostring(p5))
	end)
end

return hydrateCatalogSortById
