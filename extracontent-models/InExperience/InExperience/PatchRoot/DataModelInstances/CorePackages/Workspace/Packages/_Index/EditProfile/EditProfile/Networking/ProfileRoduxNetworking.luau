local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local LuaSocialLibrariesDeps = require(EditProfileParent.LuaSocialLibrariesDeps)
local RoduxNetworking = require(EditProfileParent.RoduxNetworking)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local RODUX_KEY = require(EditProfile.Common.Constants).RODUX_KEY
local v7 = game:DefineFastInt("EditProfileMaxHttpRetries", 5)
local v8 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 11
		-- upvalues: httpRequest (copy)
		return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	maxRetryCount = v7
})

return (RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = v8
}))
