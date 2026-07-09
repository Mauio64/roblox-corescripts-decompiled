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

local function getSortedEntries(n1: number?) -- line: 36
	-- upvalues: DataHydration (copy)
	local getLastReceivedSorts = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).getLastReceivedSorts

	if not getLastReceivedSorts then
		return nil
	end

	local v14 = getLastReceivedSorts(false)

	if not v14 or not next(v14) then
		return nil
	end

	local t1 = {}

	for v16, v17 in v14 do
		table.insert(t1, {
			id = v16,
			data = v17
		})
	end

	table.sort(t1, function(t2: {[any]: any}, t3: {[any]: any}) -- line: 54
		return (t2.data.hydrationPriority or 0) < (t3.data.hydrationPriority or 0)
	end)

	if n1 then
		local t4 = {}

		for i = 1, math.min(#t1, n1) do
			table.insert(t4, t1[i])
		end

		t1 = t4
	end

	return t1
end
local function collectContent(t5: {[any]: any}) -- line: 76
	-- upvalues: collectDedupedHydrationContent (copy)
	local t6 = {}

	for _, v23 in t5 do
		local content = v23.data.content

		if content then
			collectDedupedHydrationContent(content, t6, {}, v23.data.hydrationCount)
		end
	end

	return t6
end
local function groupContentByType(t7: {[any]: any}) -- line: 95
	local t8 = {}

	for _, v28 in t7 do
		local str = tostring(v28.type)

		if not t8[str] then
			t8[str] = {}
		end

		table.insert(t8[str], v28)
	end

	return t8
end
local function hydrateCatalogSortEntities(p1: ((...any) -> ...any), p2, p3: ((...any) -> ...any), t9: {[any]: any}, n2: number?) -- line: 107
	-- upvalues: getSortedEntries (copy), Promise (copy), collectContent (copy), groupContentByType (copy), buildHydrationReduxPayload (copy), Logging (copy)
	local v35 = getSortedEntries(n2)

	if not v35 then
		return Promise.resolve()
	end

	local v36 = collectContent(v35)

	if #v36 == 0 then
		return Promise.resolve()
	end

	local t10 = {}

	for _, v39 in groupContentByType(v36) do
		table.insert(t10, (t9.HydrateWidgetContent(p2, v39):andThen(function(p4) -- line: 134
			-- upvalues: buildHydrationReduxPayload (copy), v39 (copy), p1 (copy), p3 (copy)
			local v43 = if not p4 then nil else p4.responseBody
			local v44 = if not v43 then nil else v43.hydratedContent

			if v44 == nil then
				return
			end

			local v45 = buildHydrationReduxPayload(v44, v39)

			p1(p3(v45))
		end):catch(function(p5) -- line: 144
			-- upvalues: Logging (copy)
			Logging.warn("hydrateCatalogSortEntities: HydrateWidgetContent failed: " .. tostring(p5))
		end)))
	end

	return Promise.allSettled(t10)
end

return hydrateCatalogSortEntities
