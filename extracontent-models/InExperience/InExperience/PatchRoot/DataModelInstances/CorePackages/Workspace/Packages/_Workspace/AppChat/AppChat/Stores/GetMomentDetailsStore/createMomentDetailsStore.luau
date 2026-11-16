local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
local MomentsTypes = require(parent.MomentsTypes)
require(parent.DataHydration.MomentsStoreTypes)
local MomentsGetMomentsStore = require(parent.DataHydration.MomentsGetMomentsStore)

local FFlagAppChatMomentShareCardEdgeCases = require(AppChat.Flags.FFlagAppChatMomentShareCardEdgeCases)

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local MomentStatus = MomentsTypes.Enums.MomentStatus
local ShareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType

local function createMomentDetailsStore(options)
	local v2 = options or {}

	local function createResolver(p)
		local dataCache = DataHydration.createDataCache(v2.ttlSeconds, v2.failedTtlSeconds)
		return DataHydration.createDataResolver({
			cache = dataCache,
			supportsMultiGet = true,
			queueProcessDelaySec = 0,
			replaceItems = true,
			logError = function(p2)
				v:warning(`Error resolving Moment details: {tostring(p2)}`)
			end,
			fetchFn = function(items)
				local v3 = {}

				for k in items do
					table.insert(v3, k)
				end

				return MomentsGetMomentsStore(false).getMomentsByIds(v3, p):andThen(function(p2)
					local moments = {}

					for _, moment in p2.moments do
						local v4

						if moment.isModerated == true then
							v4 = false
						else
							v4 = moment.status ~= MomentStatus.Deleted
						end

						if not (FFlagAppChatMomentShareCardEdgeCases or v4) then
							continue
						end

						local v5

						if p == ShareLinkTargetIdType.FeedItemId then
							v5 = moment.recommendationMetadata.feedItemId
						else
							v5 = moment.momentId
						end

						if v5 ~= nil and items[v5] ~= nil then
							moments[v5] = moment
						end
					end

					return moments
				end)
			end
		})
	end

	local resolver = createResolver(nil)
	local resolver2 = createResolver(ShareLinkTargetIdType.FeedItemId)

	local function getResolver(p) -- 3 equivalent calls inferred from this helper
		if p == ShareLinkTargetIdType.FeedItemId then
			return resolver2
		end

		return resolver
	end

	return {
		getCachedMomentDetails = function(p: string, p2)
			return getResolver(p2).getCachedItem(p) -- inferred equivalent call
		end,
		fetchMomentDetails = function(p: string, p2)
			return getResolver(p2).fetchItem(p) -- inferred equivalent call
		end,
		getAndFetchMomentDetails = function(p: string, p2)
			return getResolver(p2).getAndFetchItem(p) -- inferred equivalent call
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
