local scriptParent = script.Parent
local Action = require(scriptParent.Action)

return function(p1) -- line: 5
	-- upvalues: Action (copy)
	local v4 = if type(p1) ~= "string" then p1.Name else p1

	return {
		Succeeded = Action(v4 .. "_Succeeded", function(p2, p3, p4, p5, p6) -- line: 14
			return {
				ids = p2,
				responseBody = p3,
				namedIds = p4,
				postBody = p5 and p5.postBody or nil,
				queryArgs = p5 and p5.queryArgs,
				additionalData = p6
			}
		end),
		Failed = Action(v4 .. "_Failed", function(p7, p8, p9, p10, p11) -- line: 24
			return {
				ids = p7,
				error = p8,
				namedIds = p9,
				postBody = p10 and p10.postBody or nil,
				queryArgs = p10 and p10.queryArgs or nil,
				additionalData = p11
			}
		end)
	}
end
