local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Promise = require(AuthCommonParent.Promise)
local PostGetUserByUsername = require(AuthCommon.Http.Requests.PostGetUserByUsername)

return function(p1, s1: string) -- line: 7
	-- upvalues: PostGetUserByUsername (copy), Promise (copy)
	return function() -- line: 8
		-- upvalues: PostGetUserByUsername (copy), p1 (copy), s1 (copy), Promise (copy)
		return PostGetUserByUsername(p1, s1):andThen(function(p2) -- line: 9
			-- upvalues: Promise (copy)
			if p2 and p2.responseBody then
				local data = p2.responseBody.data

				if data == nil or #data == 0 then
					return Promise.reject()
				end

				local v9 = data[1]

				return Promise.resolve(v9)
			end

			return Promise.reject()
		end)
	end
end
