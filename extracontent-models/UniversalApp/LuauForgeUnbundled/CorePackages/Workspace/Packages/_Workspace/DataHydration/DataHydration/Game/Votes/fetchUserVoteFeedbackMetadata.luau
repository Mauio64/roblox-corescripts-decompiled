local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")

local UserVoteFeedbackMetdataUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/UserVoteFeedbackMetdataUrlBuilder")

local function fetchUserVoteFeedbackMetadata(p2)
	local userVoteFeedbackMetadataUrl = UserVoteFeedbackMetdataUrlBuilder.buildUserVoteFeedbackMetadataUrl(p2)

	return HttpRequest.config({
		requestFunction = function(p3, p4, p5)
			return HttpRequest.requestFunctions.HttpRbxApi(p3, p4, p5)
		end
	})(userVoteFeedbackMetadataUrl, "GET")
end

return fetchUserVoteFeedbackMetadata
