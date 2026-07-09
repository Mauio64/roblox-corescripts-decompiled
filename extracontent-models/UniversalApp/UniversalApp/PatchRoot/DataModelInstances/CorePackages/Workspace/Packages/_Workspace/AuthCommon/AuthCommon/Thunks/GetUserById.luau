local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Promise = require(AuthCommonParent.Promise)
local GetUserByIdRequest = require(AuthCommon.Http.Requests.GetUserByIdRequest)

return function(p1, s1: string) -- line: 7
	-- upvalues: GetUserByIdRequest (copy), Promise (copy)
	return GetUserByIdRequest(p1, s1):andThen(function(p2) -- line: 8
		-- upvalues: Promise (copy)
		if p2 and p2.responseBody then
			local responseBody = p2.responseBody

			if responseBody == nil then
				return Promise.reject()
			end

			return Promise.resolve(responseBody)
		end

		return Promise.reject()
	end)
end
