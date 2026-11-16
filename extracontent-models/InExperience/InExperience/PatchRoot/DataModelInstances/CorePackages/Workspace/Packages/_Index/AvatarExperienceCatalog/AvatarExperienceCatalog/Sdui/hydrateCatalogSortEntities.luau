local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
require(parent.AvatarExperienceRodux)
local DataHydration = require(parent.DataHydration)
local Promise = require(parent.Promise)
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging
require(parent.Http)
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)
local collectDedupedHydrationContent = require(AvatarExperienceCatalog.Sdui.Utils.collectDedupedHydrationContent)
local buildHydrationReduxPayload = require(AvatarExperienceCatalog.Sdui.Utils.buildHydrationReduxPayload)

local function getSortedEntries(p: number?)
	local getLastReceivedSorts = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).getLastReceivedSorts

	if not getLastReceivedSorts then
		return nil
	end

	local lastReceivedSorts = getLastReceivedSorts(false)

	if not (lastReceivedSorts and next(lastReceivedSorts)) then
		return nil
	end

	local result = {}

	for k, lastReceivedSort in lastReceivedSorts do
		table.insert(result, { id = k, data = lastReceivedSort })
	end

	table.sort(result, function(a, b): boolean
		return (a.data.hydrationPriority or 0) < (b.data.hydrationPriority or 0)
	end)

	if not p then
		return result
	end

	local v = {}

	for i = 1, math.min(#result, p) do
		table.insert(v, result[i])
	end

	result = v
	return result
end

local function collectContent(sortedEntries)
	local content = {}
	local v = {}

	for _, item in sortedEntries do
		local content2 = item.data.content

		if content2 then
			collectDedupedHydrationContent(content2, content, v, item.data.hydrationCount)
		end
	end

	return content
end

local function groupContentByType(items)
	local result = {}

	for _, item in items do
		local kind = tostring(item.type)

		if not result[kind] then
			result[kind] = {}
		end

		table.insert(result[kind], item)
	end

	return result
end

local function hydrateCatalogSortEntities(callback, p, callback2, p2, p3: number?)
	local sortedEntries = getSortedEntries(p3)

	if not sortedEntries then
		return Promise.resolve()
	end

	local v = collectContent(sortedEntries)

	if #v == 0 then
		return Promise.resolve()
	end

	local v2 = {}

	for _, v3 in groupContentByType(v) do
		table.insert(v2, (p2.HydrateWidgetContent(p, v3):andThen(function(p4)
			local responseBody

			if p4 then
				responseBody = p4.responseBody
			end

			local hydratedContent

			if responseBody then
				hydratedContent = responseBody.hydratedContent
			end

			if hydratedContent == nil then
				return
			end

			callback(callback2((buildHydrationReduxPayload(hydratedContent, v3))))
		end):catch(function(p4)
			Logging.warn("hydrateCatalogSortEntities: HydrateWidgetContent failed: " .. tostring(p4))
		end)))
	end

	return Promise.allSettled(v2)
end

return hydrateCatalogSortEntities
