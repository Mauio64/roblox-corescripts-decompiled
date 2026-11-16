local parent = script:FindFirstAncestor("GraphQLServer").Parent
local GraphQlShared = require(parent.GraphQlShared)
local MakeOmniRecommendationsRequest = GraphQlShared.MakeOmniRecommendationsRequest
require(parent.LuauPolyfill)

require(parent.Fetch)

local function makeNetworkImpl(callback) -- 1 equivalent call inferred from this helper
	return function(p: string, _: string, p2)
		return callback(p, {
			body = p2.postBody,
			method = "POST",
			headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
		})
	end
end

return function(callback)
	local networkImpl = makeNetworkImpl(callback) -- inferred equivalent call
	return function(p, p2, p3, p4)
		return MakeOmniRecommendationsRequest(networkImpl, p, p2, p3, p4)
	end
end
