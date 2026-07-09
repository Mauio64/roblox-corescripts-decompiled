local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local UserVoteFeedbackMetadataStoreTypes = require(script.Parent.UserVoteFeedbackMetadataStoreTypes)
local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local fetchUserVoteFeedbackMetadata = require(script.Parent.fetchUserVoteFeedbackMetadata)
local UserVoteFeedbackMetdataUrlBuilder = require(script.Parent.UserVoteFeedbackMetdataUrlBuilder)
local UserVoteFeedbackMetadataDerivedFields = require(script.Parent.UserVoteFeedbackMetadataDerivedFields)

local function createUserVoteFeedbackMetadataStore() -- line: 17
	-- upvalues: createDataCache (copy), createDataResolver (copy), logResponseError (copy), UserVoteFeedbackMetdataUrlBuilder (copy), fetchUserVoteFeedbackMetadata (copy), UserVoteFeedbackMetadataStoreTypes (copy), DiscoveryEventErrorLogger (copy), UserVoteFeedbackMetadataDerivedFields (copy)
	local v13 = createDataCache()
	local v14 = createDataResolver({
		supportsMultiGet = false,
		cache = v13,
		logError = function(p1) -- line: 24
			-- upvalues: logResponseError (copy), UserVoteFeedbackMetdataUrlBuilder (copy)
			logResponseError(UserVoteFeedbackMetdataUrlBuilder.USER_VOTE_FEEDBACK_METADATA_URL, p1)
		end,
		fetchFn = function(s1: string, _) -- line: 27
			-- upvalues: fetchUserVoteFeedbackMetadata (copy), UserVoteFeedbackMetadataStoreTypes (copy), DiscoveryEventErrorLogger (copy)
			return fetchUserVoteFeedbackMetadata(s1):andThen(function(p3) -- line: 33
				-- upvalues: UserVoteFeedbackMetadataStoreTypes (copy), DiscoveryEventErrorLogger (copy), s1 (copy)
				local responseBody = p3.responseBody

				if not UserVoteFeedbackMetadataStoreTypes.userVoteFeedbackMetadataResponseValidator(responseBody) then
					DiscoveryEventErrorLogger.reportError("createUserVoteFeedbackMetadataStore", "Invalid user vote feedback metadata response", {
						rootPlaceId = s1,
						responseBody = responseBody
					})
					error({
						StatusCode = p3.responseCode
					})
				end

				return {
					rootPlaceId = s1,
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
		fetchUserVoteFeedbackMetadata = v14.fetchItem,
		fetchUserVoteFeedbackMetadatas = v14.fetchItems,
		getUserVoteFeedbackMetadata = v14.getCachedItem,
		getUserVoteFeedbackMetadatas = v14.getCachedItems,
		getAndFetchUserVoteFeedbackMetadata = v14.getAndFetchItem,
		getAndFetchUserVoteFeedbackMetadatas = v14.getAndFetchItems,
		clearItem = function(s2: string) -- line: 80
			-- upvalues: v13 (copy)
			v13.replaceItem(s2, nil)
		end,
		calculateDerivedField = UserVoteFeedbackMetadataDerivedFields.calculateDerivedField,
		clear = function() -- line: 63
			-- upvalues: v13 (copy), v14 (copy)
			v13.clear()
			v14.clear()
		end,
		dispose = function() -- line: 68
			-- upvalues: v14 (copy)
			v14.dispose()
		end
	}
end

return createUserVoteFeedbackMetadataStore
