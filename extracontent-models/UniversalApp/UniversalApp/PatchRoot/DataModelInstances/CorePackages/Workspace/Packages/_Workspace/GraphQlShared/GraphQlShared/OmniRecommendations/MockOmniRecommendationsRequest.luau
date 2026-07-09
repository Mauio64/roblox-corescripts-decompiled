local Parent = script:FindFirstAncestor("GraphQlShared").Parent
local Promise = require(Parent.Promise)

return {
	SuccessfulRequest = function(p1) -- line: 5
		-- upvalues: Promise (copy)
		return function(_, _, _, _, _) -- line: 6
			-- upvalues: p1 (copy), Promise (copy)
			local t1 = {
				responseCode = 200,
				responseTimeMs = 480,
				isJSONValid = true,
				p1,
				responseBody = p1
			}

			return Promise.resolve(t1)
		end
	end
}
