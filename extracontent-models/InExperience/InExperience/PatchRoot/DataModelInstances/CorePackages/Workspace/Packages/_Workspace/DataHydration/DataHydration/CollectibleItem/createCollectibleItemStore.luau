local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Promise = require(parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
require(script.Parent.CollectibleItemStoreTypes)
local createDataResolver = require(DataHydration.createDataResolver)

local function normalizeCreator(creator)
	local creator2 = {
		id = creator.id,
		name = creator.name,
		type = creator.type,
		targetId = 0,
		hasVerifiedBadge = 0
	}
	local targetId

	if creator.targetId == nil then
		targetId = creator.target_id
	else
		targetId = creator.targetId
	end

	creator2.targetId = targetId
	local hasVerifiedBadge

	if creator.hasVerifiedBadge == nil then
		hasVerifiedBadge = creator.has_verified_badge
	else
		hasVerifiedBadge = creator.hasVerifiedBadge
	end

	creator2.hasVerifiedBadge = hasVerifiedBadge
	return creator2
end

local function normalizeExperiences(experiences)
	if not experiences then
		return nil
	end

	local result = table.create(#experiences)

	for _, item in experiences do
		local v = { id = item.id, name = item.name, detailPageLink = 0 }
		local detailPageLink

		if item.detailPageLink == nil then
			detailPageLink = item.detail_page_link
		else
			detailPageLink = item.detailPageLink
		end

		v.detailPageLink = detailPageLink
		table.insert(result, v)
	end

	return result
end

local function normalizeCollectibleItem(data) -- 1 equivalent call inferred from this helper
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
end

local function createCollectibleItemStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end
	})

	local function getNormalizedCollectibleItemInfo(p: string)
		local cachedItem = dataResolver.getCachedItem(p)
		return {
			data = function(p2)
				local data = cachedItem.data(p2)

				if not data then
					return nil
				end

				return normalizeCollectibleItem(data) -- inferred equivalent call
			end,
			status = cachedItem.status
		}
	end

	return {
		getCollectibleItemInfo = dataResolver.getCachedItem,
		getCollectibleItemInfos = dataResolver.getCachedItems,
		getNormalizedCollectibleItemInfo = getNormalizedCollectibleItemInfo,
		updateCollectibleItemInfo = dataCache.updateItem,
		updateCollectibleItemInfos = dataCache.updateItems,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createCollectibleItemStore
