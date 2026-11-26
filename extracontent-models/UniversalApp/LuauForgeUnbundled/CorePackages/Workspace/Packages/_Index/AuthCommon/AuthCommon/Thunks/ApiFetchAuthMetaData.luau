local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local GetAuthMetaData = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/GetAuthMetaData")

return function(p2)
	return GetAuthMetaData(p2):andThen(function(p3)
		if p3 and p3.responseBody then
			return Promise.resolve(p3.responseBody)
		end

		return Promise.reject()
	end, function(p3)
		return Promise.reject({ p3.StatusCode })
	end)
end
