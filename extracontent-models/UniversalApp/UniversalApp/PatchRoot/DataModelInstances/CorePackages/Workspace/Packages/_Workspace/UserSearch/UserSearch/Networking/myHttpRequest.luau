local Parent = script:FindFirstAncestor("UserSearch").Parent
local httpRequest = require(Parent.LuaSocialLibrariesDeps).httpRequest
local v3 = game:DefineFastInt("UserSearchHttpRetryCount", 3)
local v4 = game:DefineFastFlag("MigrateUserSearchHttpRequestToRequestInternal", false)

return (httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 10
		-- upvalues: v4 (copy), httpRequest (copy)
		if v4 then
			return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
		end

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = v3
}))
