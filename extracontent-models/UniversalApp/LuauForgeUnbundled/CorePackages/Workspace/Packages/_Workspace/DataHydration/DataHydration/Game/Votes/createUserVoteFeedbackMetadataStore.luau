local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local UserVoteFeedbackMetadataStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/UserVoteFeedbackMetadataStoreTypes")
local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/fetchUserVoteFeedbackMetadata")
local UserVoteFeedbackMetdataUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/UserVoteFeedbackMetdataUrlBuilder")
local UserVoteFeedbackMetadataDerivedFields = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/UserVoteFeedbackMetadataDerivedFields")

local function createUserVoteFeedbackMetadataStore()
	local v5 = createDataCache()

	local v6 = createDataResolver({
		cache = v5,
		supportsMultiGet = false,
		logError = function(p2)
			logResponseError(UserVoteFeedbackMetdataUrlBuilder.USER_VOTE_FEEDBACK_METADATA_URL, p2)
		end,
		fetchFn = function(p2, p3)
			return module5(p2):andThen(function(p4)
				local responseBody = p4.responseBody

				if not UserVoteFeedbackMetadataStoreTypes.userVoteFeedbackMetadataResponseValidator(responseBody) then
					discoveryEventErrorLogger.reportError(
						"createUserVoteFeedbackMetadataStore",
						"Invalid user vote feedback metadata response",
						{ rootPlaceId = p2, responseBody = responseBody }
					)

					error({ StatusCode = p4.responseCode })
				end

				return {
					rootPlaceId = p2,
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
		fetchUserVoteFeedbackMetadata = v6.fetchItem,
		fetchUserVoteFeedbackMetadatas = v6.fetchItems,
		getUserVoteFeedbackMetadata = v6.getCachedItem,
		getUserVoteFeedbackMetadatas = v6.getCachedItems,
		getAndFetchUserVoteFeedbackMetadata = v6.getAndFetchItem,
		getAndFetchUserVoteFeedbackMetadatas = v6.getAndFetchItems,
		clearItem = function(p2)
			v5.replaceItem(p2, nil)
		end,
		calculateDerivedField = UserVoteFeedbackMetadataDerivedFields.calculateDerivedField,
		clear = function()
			v5.clear()
			v6.clear()
		end,
		dispose = function()
			v6.dispose()
		end
	}
end

return createUserVoteFeedbackMetadataStore
