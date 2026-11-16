local parent = script:FindFirstAncestor("TrustedContacts").Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local defineFastInt = game:DefineFastInt("TrustedContactsHttpRetryCount", 3)

return (httpRequest.config({
	requestFunction = function(p, p2, p3)
		return httpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end,
	maxRetryCount = defineFastInt
}))
