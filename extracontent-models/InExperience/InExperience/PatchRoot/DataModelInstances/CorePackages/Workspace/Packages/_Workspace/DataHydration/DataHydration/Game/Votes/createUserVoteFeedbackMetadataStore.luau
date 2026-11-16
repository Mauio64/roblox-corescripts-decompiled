local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local UserVoteFeedbackMetadataStoreTypes = require(script.Parent.UserVoteFeedbackMetadataStoreTypes)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local fetchUserVoteFeedbackMetadata = require(script.Parent.fetchUserVoteFeedbackMetadata)
local UserVoteFeedbackMetdataUrlBuilder = require(script.Parent.UserVoteFeedbackMetdataUrlBuilder)
local UserVoteFeedbackMetadataDerivedFields = require(script.Parent.UserVoteFeedbackMetadataDerivedFields)

local function createUserVoteFeedbackMetadataStore()
	local dataCache = createDataCache()

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		logError = function(p)
			logResponseError(UserVoteFeedbackMetdataUrlBuilder.USER_VOTE_FEEDBACK_METADATA_URL, p)
		end,
		fetchFn = function(rootPlaceId: string, _)
			return fetchUserVoteFeedbackMetadata(rootPlaceId):andThen(function(p)
				local responseBody = p.responseBody

				if not UserVoteFeedbackMetadataStoreTypes.userVoteFeedbackMetadataResponseValidator(responseBody) then
					DiscoveryEventErrorLogger.reportError(
						"createUserVoteFeedbackMetadataStore",
						"Invalid user vote feedback metadata response",
						{ rootPlaceId = rootPlaceId, responseBody = responseBody }
					)

					error({ StatusCode = p.responseCode })
				end

				return {
					rootPlaceId = rootPlaceId,
					canSubmitReview = responseBody.capabilities and responseBody.capabilities.can_submit_review,
					canSubmitComment = responseBody.capabilities and responseBody.capabilities.can_submit_comment,
					categories = responseBody.categories or {},
					comment = responseBody.comment or {},
					metadata = responseBody.metadata or {}
				}
			end)
		end
	})

	return {
		fetchUserVoteFeedbackMetadata = dataResolver.fetchItem,
		fetchUserVoteFeedbackMetadatas = dataResolver.fetchItems,
		getUserVoteFeedbackMetadata = dataResolver.getCachedItem,
		getUserVoteFeedbackMetadatas = dataResolver.getCachedItems,
		getAndFetchUserVoteFeedbackMetadata = dataResolver.getAndFetchItem,
		getAndFetchUserVoteFeedbackMetadatas = dataResolver.getAndFetchItems,
		clearItem = function(p: string)
			dataCache.replaceItem(p, nil)
		end,
		calculateDerivedField = UserVoteFeedbackMetadataDerivedFields.calculateDerivedField,
		clear = function()
			dataCache.clear()
			dataResolver.clear()
		end,
		dispose = function()
			dataResolver.dispose()
		end
	}
end

return createUserVoteFeedbackMetadataStore
