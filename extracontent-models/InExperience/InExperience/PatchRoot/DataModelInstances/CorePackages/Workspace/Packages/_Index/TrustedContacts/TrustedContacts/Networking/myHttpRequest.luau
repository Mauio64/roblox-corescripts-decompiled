local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local httpRequest = require(Parent.LuaSocialLibrariesDeps).httpRequest
local v3 = game:DefineFastInt("TrustedContactsHttpRetryCount", 3)

return (httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 8
		-- upvalues: httpRequest (copy)
		return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	maxRetryCount = v3
}))
