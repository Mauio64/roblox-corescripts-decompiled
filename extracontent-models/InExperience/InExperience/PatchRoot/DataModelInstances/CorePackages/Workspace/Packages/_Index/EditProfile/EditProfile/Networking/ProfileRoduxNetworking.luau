local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local RoduxNetworking = require(parent.RoduxNetworking)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local Constants = require(EditProfile.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

local defineFastInt = game:DefineFastInt("EditProfileMaxHttpRetries", 5)

local config = httpRequest.config({
	requestFunction = function(p, p2, p3)
		return httpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end,
	maxRetryCount = defineFastInt
})

return (RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
}))
