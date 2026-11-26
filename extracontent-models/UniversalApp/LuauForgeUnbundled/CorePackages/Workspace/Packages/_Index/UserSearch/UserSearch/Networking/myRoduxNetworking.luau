local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/LuaSocialLibrariesDeps")
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/Constants").RODUX_KEY
local roduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Networking/myHttpRequest")
local challengeRequestWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/GenericChallenges").Middleware.ChallengeRequestWrapper
local defineFastFlag = game:DefineFastFlag("EnableUserSearchChallengeInterceptor", false)

local config = roduxNetworking.config
local v5 = {
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = 0
}

if defineFastFlag then
	myHttpRequest = challengeRequestWrapper(myHttpRequest)
end

v5.networkImpl = myHttpRequest
return (config(v5))
