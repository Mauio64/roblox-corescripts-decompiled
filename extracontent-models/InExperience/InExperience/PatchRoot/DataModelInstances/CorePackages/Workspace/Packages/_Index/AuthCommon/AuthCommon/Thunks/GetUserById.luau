local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Promise = require(parent.Promise)
local GetUserByIdRequest = require(AuthCommon.Http.Requests.GetUserByIdRequest)

return function(p, p2: string)
	return GetUserByIdRequest(p, p2):andThen(function(p3)
		if not (p3 and p3.responseBody) then
			return Promise.reject()
		end

		local responseBody = p3.responseBody

		if responseBody == nil then
			return Promise.reject()
		end

		return Promise.resolve(responseBody)
	end)
end
