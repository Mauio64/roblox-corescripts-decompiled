local parent = script.Parent
local Action = require(parent.Action)

return function(value)
	if type(value) ~= "string" then
		value = value.Name
	end

	return {
		Succeeded = Action(value .. "_Succeeded", function(ids, responseBody, namedIds, p, additionalData)
			local postBody

			if p then
				postBody = p.postBody or nil
			end

			return {
				ids = ids,
				responseBody = responseBody,
				namedIds = namedIds,
				postBody = postBody,
				queryArgs = p and p.queryArgs,
				additionalData = additionalData
			}
		end),
		Failed = Action(value .. "_Failed", function(ids, err, namedIds, p, additionalData)
			local postBody

			if p then
				postBody = p.postBody or nil
			end

			return {
				ids = ids,
				error = err,
				namedIds = namedIds,
				postBody = postBody,
				queryArgs = p and p.queryArgs or nil,
				additionalData = additionalData
			}
		end)
	}
end
