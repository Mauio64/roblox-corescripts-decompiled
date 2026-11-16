local httpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/LuaSocialLibrariesDeps").httpRequest
local defineFastInt = game:DefineFastInt("UserSearchHttpRetryCount", 3)

local defineFastFlag = game:DefineFastFlag("MigrateUserSearchHttpRequestToRequestInternal", false)

return (httpRequest.config({
	requestFunction = function(p2, p3, p4)
		if defineFastFlag then
			return httpRequest.requestFunctions.RequestInternal(p2, p3, p4)
		end

		return httpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	maxRetryCount = defineFastInt
}))
