local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpRequest = require(Parent.HttpRequest)

require(Parent.Http)

local UserVoteFeedbackMetdataUrlBuilder = require(script.Parent.UserVoteFeedbackMetdataUrlBuilder)

local function fetchUserVoteFeedbackMetadata(s1: string) -- line: 13
	-- upvalues: UserVoteFeedbackMetdataUrlBuilder (copy), HttpRequest (copy)
	local v6 = UserVoteFeedbackMetdataUrlBuilder.buildUserVoteFeedbackMetadataUrl(s1)

	return HttpRequest.config({
		requestFunction = function(s2: string, s3: string, p1) -- line: 17
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.HttpRbxApi(s2, s3, p1)
		end
	})(v6, "GET")
end

return fetchUserVoteFeedbackMetadata
