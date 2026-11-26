require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceRodux")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/DataHydration")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Promise")
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib").Logging
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")
local collectDedupedHydrationContent = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/collectDedupedHydrationContent")
local buildHydrationReduxPayload = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/buildHydrationReduxPayload")

local function getSortedEntries(p2)
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

	if not p2 then
		return result
	end

	local v5 = {}

	for i = 1, math.min(#result, p2) do
		table.insert(v5, result[i])
	end

	result = v5
	return result
end

local function collectContent(sortedEntries)
	local content = {}
	local v5 = {}

	for k, item in sortedEntries do
		local content2 = item.data.content

		if content2 then
			collectDedupedHydrationContent(content2, content, v5, item.data.hydrationCount)
		end
	end

	return content
end

local function groupContentByType(items)
	local result = {}

	for k, item in items do
		local kind = tostring(item.type)

		if not result[kind] then
			result[kind] = {}
		end

		table.insert(result[kind], item)
	end

	return result
end

local function hydrateCatalogSortEntities(callback, p2, callback2, p3, p4)
	local sortedEntries = getSortedEntries(p4)

	if not sortedEntries then
		return Promise.resolve()
	end

	local v5 = collectContent(sortedEntries)

	if #v5 == 0 then
		return Promise.resolve()
	end

	local v6 = {}

	for k, v7 in groupContentByType(v5) do
		table.insert(v6, (p3.HydrateWidgetContent(p2, v7):andThen(function(p5)
			local responseBody = if p5 then p5.responseBody else nil
			local hydratedContent = if responseBody then responseBody.hydratedContent else nil

			if hydratedContent == nil then
				return
			end

			callback(callback2((buildHydrationReduxPayload(hydratedContent, v7))))
		end):catch(function(p5)
			logging.warn("hydrateCatalogSortEntities: HydrateWidgetContent failed: " .. tostring(p5))
		end)))
	end

	return Promise.allSettled(v6)
end

return hydrateCatalogSortEntities
