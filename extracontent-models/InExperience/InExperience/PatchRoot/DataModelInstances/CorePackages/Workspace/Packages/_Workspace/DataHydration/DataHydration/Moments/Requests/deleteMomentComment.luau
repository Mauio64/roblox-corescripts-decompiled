local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
require(DataHydration.Moments.MomentsStoreTypes)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)

local function commentPath(p: string, p2: string) -- 1 equivalent call inferred from this helper
	return `moment-comments-api/v1/moments/{p}/comments/{p2}`
end

local function deleteMomentComment(p: string, p2: string, network)
	local url, headers = constructApiUrl(commentPath(p, p2)) -- inferred equivalent call

	return HttpClient.fetch({
		method = "DELETE",
		url = url,
		headers = headers,
		analyticsKey = "moments.delete-comment",
		network = network,
		decode = function(_): nil
			return nil
		end
	})
end

return deleteMomentComment
