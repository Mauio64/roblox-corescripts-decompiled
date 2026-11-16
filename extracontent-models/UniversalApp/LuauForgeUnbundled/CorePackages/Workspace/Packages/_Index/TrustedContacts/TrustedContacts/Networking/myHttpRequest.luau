local httpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/LuaSocialLibrariesDeps").httpRequest
local defineFastInt = game:DefineFastInt("TrustedContactsHttpRetryCount", 3)

return (httpRequest.config({
	requestFunction = function(p2, p3, p4)
		return httpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end,
	maxRetryCount = defineFastInt
}))
