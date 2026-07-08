local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Promise = require(AuthCommonParent.Promise)
local GetAuthMetaData = require(AuthCommon.Http.Requests.GetAuthMetaData)

return function(p1) -- line: 6
	-- upvalues: GetAuthMetaData (copy), Promise (copy)
	return GetAuthMetaData(p1):andThen(function(p2) -- line: 7
		-- upvalues: Promise (copy)
		if p2 and p2.responseBody then
			return Promise.resolve(p2.responseBody)
		end

		return Promise.reject()
	end, function(p3) -- line: 13
		-- upvalues: Promise (copy)
		return Promise.reject({ p3.StatusCode })
	end)
end
