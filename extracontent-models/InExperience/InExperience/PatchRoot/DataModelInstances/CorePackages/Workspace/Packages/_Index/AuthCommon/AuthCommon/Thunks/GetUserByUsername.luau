local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Promise = require(parent.Promise)
local PostGetUserByUsername = require(AuthCommon.Http.Requests.PostGetUserByUsername)

return function(p, p2: string)
	return function()
		return PostGetUserByUsername(p, p2):andThen(function(p3)
			if not (p3 and p3.responseBody) then
				return Promise.reject()
			end

			local data = p3.responseBody.data

			if data == nil or #data == 0 then
				return Promise.reject()
			end

			local v = data[1]
			return Promise.resolve(v)
		end)
	end
end
