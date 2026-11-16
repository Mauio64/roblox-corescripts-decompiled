local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CollectibleItem/CollectibleItemStoreTypes")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")

local function normalizeCreator(creator)
	local creator2 = {
		id = creator.id,
		name = creator.name,
		type = creator.type,
		targetId = 0,
		hasVerifiedBadge = 0
	}
	local v5 = if creator.targetId == nil then creator.target_id else creator.targetId
	creator2.targetId = v5
	local v6 = if creator.hasVerifiedBadge == nil then creator.has_verified_badge else creator.hasVerifiedBadge
	creator2.hasVerifiedBadge = v6
	return creator2
end

local function normalizeExperiences(experiences)
	if not experiences then
		return nil
	end

	local result = table.create(#experiences)

	for k, item in experiences do
		local v5 = { id = item.id, name = item.name, detailPageLink = 0 }
		local v6 = if item.detailPageLink == nil then item.detail_page_link else item.detailPageLink
		v5.detailPageLink = v6
		table.insert(result, v5)
	end

	return result
end

local function normalizeCollectibleItem(p2)
	if not (p2.creator or p2.experiences) then
		return p2
	end

	local clone = table.clone(p2)

	if p2.creator then
		clone.creator = normalizeCreator(p2.creator)
	end

	if p2.experiences then
		clone.experiences = normalizeExperiences(p2.experiences)
	end

	return clone
end

local function createCollectibleItemStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end
	})

	local function getNormalizedCollectibleItemInfo(p2)
		local cachedItem = v6.getCachedItem(p2)
		return {
			data = function(p3)
				local data = cachedItem.data(p3)

				if not data then
					return nil
				end

				if not (data.creator or data.experiences) then
					return data
				end

				local clone = table.clone(data)

				if data.creator then
					clone.creator = normalizeCreator(data.creator)
				end

				if data.experiences then
					clone.experiences = normalizeExperiences(data.experiences)
				end

				return clone
			end,
			status = cachedItem.status
		}
	end

	return {
		getCollectibleItemInfo = v6.getCachedItem,
		getCollectibleItemInfos = v6.getCachedItems,
		getNormalizedCollectibleItemInfo = getNormalizedCollectibleItemInfo,
		updateCollectibleItemInfo = v5.updateItem,
		updateCollectibleItemInfos = v5.updateItems,
		clear = v5.clear,
		dispose = v5.dispose
	}
end

return createCollectibleItemStore
