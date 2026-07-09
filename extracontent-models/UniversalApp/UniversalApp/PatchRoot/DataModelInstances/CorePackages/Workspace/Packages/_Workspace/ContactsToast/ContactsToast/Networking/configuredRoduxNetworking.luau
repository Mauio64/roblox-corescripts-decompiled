local ContactsToast = script:FindFirstAncestor("ContactsToast")
local ContactsToastParent = ContactsToast.Parent
local LuaSocialLibrariesDeps = require(ContactsToastParent.LuaSocialLibrariesDeps)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local RODUX_KEY = require(ContactsToast.Common.Constants).RODUX_KEY
local v6 = require(ContactsToastParent.Lumberyak).Logger.new(nil, "ContactsToast"):new("ContactsToast Networking")
local v7 = game:DefineFastInt("ContactsToastHttpRetryCount", 3)
local v8 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 13
		-- upvalues: v6 (copy), httpRequest (copy)
		v6:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 17
		-- upvalues: v6 (copy)
		v6:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v7
})

return (LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = v8
}))
