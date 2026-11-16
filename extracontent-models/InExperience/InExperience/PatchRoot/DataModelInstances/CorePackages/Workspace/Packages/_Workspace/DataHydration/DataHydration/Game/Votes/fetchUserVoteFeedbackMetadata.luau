local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpRequest = require(parent.HttpRequest)
require(parent.Http)

local UserVoteFeedbackMetdataUrlBuilder = require(script.Parent.UserVoteFeedbackMetdataUrlBuilder)

local function fetchUserVoteFeedbackMetadata(p: string)
	local userVoteFeedbackMetadataUrl = UserVoteFeedbackMetdataUrlBuilder.buildUserVoteFeedbackMetadataUrl(p)

	return HttpRequest.config({
		requestFunction = function(p2: string, p3: string, p4)
			return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
		end
	})(userVoteFeedbackMetadataUrl, "GET")
end

return fetchUserVoteFeedbackMetadata
