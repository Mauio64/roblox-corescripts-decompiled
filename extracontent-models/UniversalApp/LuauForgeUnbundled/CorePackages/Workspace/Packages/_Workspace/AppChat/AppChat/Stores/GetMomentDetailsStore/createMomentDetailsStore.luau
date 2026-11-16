local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration/MomentsStoreTypes")
local MomentsGetMomentsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration/MomentsGetMomentsStore")

local FFlagAppChatMomentShareCardEdgeCases = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardEdgeCases")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("createMomentDetailsStore")

local momentStatus = MomentsTypes.Enums.MomentStatus
local shareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType

local function createMomentDetailsStore(options)
	local v6 = options or {}

	local function createResolver(p2)
		local dataCache = DataHydration.createDataCache(v6.ttlSeconds, v6.failedTtlSeconds)
		return DataHydration.createDataResolver({
			cache = dataCache,
			supportsMultiGet = true,
			queueProcessDelaySec = 0,
			replaceItems = true,
			logError = function(p3)
				v5:warning(`Error resolving Moment details: {tostring(p3)}`)
			end,
			fetchFn = function(items)
				local v7 = {}

				for k in items do
					table.insert(v7, k)
				end

				return MomentsGetMomentsStore(false).getMomentsByIds(v7, p2):andThen(function(p3)
					local moments = {}

					for k, moment in p3.moments do
						local v8 = not (moment.isModerated == true)
							and moment.status ~= momentStatus.Deleted

						if not (FFlagAppChatMomentShareCardEdgeCases or v8) then
							continue
						end

						local v9

						if p2 == shareLinkTargetIdType.FeedItemId then
							v9 = moment.recommendationMetadata.feedItemId
						else
							v9 = moment.momentId
						end

						if v9 ~= nil and items[v9] ~= nil then
							moments[v9] = moment
						end
					end

					return moments
				end)
			end
		})
	end

	local resolver = createResolver(nil)
	local resolver2 = createResolver(shareLinkTargetIdType.FeedItemId)

	local function getResolver(p2)
		if p2 == shareLinkTargetIdType.FeedItemId then
			return resolver2
		end

		return resolver
	end

	return {
		getCachedMomentDetails = function(p2, p3)
			local v7 = if p3 == shareLinkTargetIdType.FeedItemId then resolver2 else resolver

			return v7.getCachedItem(p2)
		end,
		fetchMomentDetails = function(p2, p3)
			local v7 = if p3 == shareLinkTargetIdType.FeedItemId then resolver2 else resolver

			return v7.fetchItem(p2)
		end,
		getAndFetchMomentDetails = function(p2, p3)
			local v7 = if p3 == shareLinkTargetIdType.FeedItemId then resolver2 else resolver

			return v7.getAndFetchItem(p2)
		end,
		clear = function()
			resolver.clear()
			resolver2.clear()
		end,
		dispose = function()
			resolver.dispose()
			resolver2.dispose()
		end
	}
end

return createMomentDetailsStore
