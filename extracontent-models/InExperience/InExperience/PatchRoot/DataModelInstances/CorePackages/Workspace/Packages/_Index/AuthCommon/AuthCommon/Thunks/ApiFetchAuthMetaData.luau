local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local Promise = require(parent.Promise)
local GetAuthMetaData = require(AuthCommon.Http.Requests.GetAuthMetaData)

return function(p)
	return GetAuthMetaData(p):andThen(function(p2)
		if p2 and p2.responseBody then
			return Promise.resolve(p2.responseBody)
		end

		return Promise.reject()
	end, function(p2)
		return Promise.reject({ p2.StatusCode })
	end)
end
