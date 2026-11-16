local parent = script:FindFirstAncestor("UserSearch").Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local defineFastInt = game:DefineFastInt("UserSearchHttpRetryCount", 3)

local defineFastFlag = game:DefineFastFlag("MigrateUserSearchHttpRequestToRequestInternal", false)

return (httpRequest.config({
	requestFunction = function(p, p2, p3)
		if defineFastFlag then
			return httpRequest.requestFunctions.RequestInternal(p, p2, p3)
		end

		return httpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	maxRetryCount = defineFastInt
}))
