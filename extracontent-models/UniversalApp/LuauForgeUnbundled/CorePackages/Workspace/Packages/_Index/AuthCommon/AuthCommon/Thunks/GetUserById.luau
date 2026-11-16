local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local GetUserByIdRequest = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/GetUserByIdRequest")

return function(p2, p3)
	return GetUserByIdRequest(p2, p3):andThen(function(p4)
		if not (p4 and p4.responseBody) then
			return Promise.reject()
		end

		local responseBody = p4.responseBody

		if responseBody == nil then
			return Promise.reject()
		end

		return Promise.resolve(responseBody)
	end)
end
