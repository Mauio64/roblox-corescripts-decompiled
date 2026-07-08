local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local MakeOmniRecommendationsRequest = require(Parent.GraphQlShared).MakeOmniRecommendationsRequest

require(Parent.LuauPolyfill)
require(Parent.Fetch)

local function makeNetworkImpl(p1: ((...any) -> ...any)) -- line: 11
	return function(s1: string, _: string, t1: {[any]: any}) -- line: 12
		-- upvalues: p1 (copy)
		return p1(s1, {
			method = "POST",
			body = t1.postBody,
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		})
	end
end

return function(p2) -- line: 24
	-- upvalues: MakeOmniRecommendationsRequest (copy)
	local function v6(s3: string, _: string, t2: {[any]: any}) -- line: 12
		-- upvalues: p2 (copy)
		return p2(s3, {
			method = "POST",
			body = t2.postBody,
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		})
	end

	return function(p3, p4, p5, p6) -- line: 26
		-- upvalues: MakeOmniRecommendationsRequest (copy), v6 (copy)
		return MakeOmniRecommendationsRequest(v6, p3, p4, p5, p6)
	end
end
