local makeOmniRecommendationsRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQlShared").MakeOmniRecommendationsRequest
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch")

local function makeNetworkImpl(callback)
	return function(p2, p3, p4)
		return callback(p2, {
			body = p4.postBody,
			method = "POST",
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		})
	end
end

return function(callback)
	local function fn(p2, p3, p4)
		return callback(p2, {
			body = p4.postBody,
			method = "POST",
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		})
	end

	return function(p2, p3, p4, p5)
		return makeOmniRecommendationsRequest(fn, p2, p3, p4, p5)
	end
end
