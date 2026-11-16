local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local PostGetUserByUsername = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/PostGetUserByUsername")

return function(p2, p3)
	return function()
		return PostGetUserByUsername(p2, p3):andThen(function(p4)
			if not (p4 and p4.responseBody) then
				return Promise.reject()
			end

			local data = p4.responseBody.data

			if data == nil or #data == 0 then
				return Promise.reject()
			end

			local v5 = data[1]
			return Promise.resolve(v5)
		end)
	end
end
