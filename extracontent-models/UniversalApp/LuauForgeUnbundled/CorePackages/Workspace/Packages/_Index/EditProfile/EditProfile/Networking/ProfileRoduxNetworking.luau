local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/LuaSocialLibrariesDeps")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RoduxNetworking")
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Constants").RODUX_KEY

local defineFastInt = game:DefineFastInt("EditProfileMaxHttpRetries", 5)

local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		return httpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end,
	maxRetryCount = defineFastInt
})

return (RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
}))
