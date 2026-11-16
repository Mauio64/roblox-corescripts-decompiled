local module = require("@luauforge/bundled/efq")
local challengeRequestWrapper = require("@luauforge/bundled/efr").Middleware.ChallengeRequestWrapper

local module2 = require("@luauforge/bundled/efs")

local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/UserRelationshipModals/Networking/myRoduxNetworking")

return (module.config({
	keyPath = `{module2}.NetworkStatus`,
	networkImpl = challengeRequestWrapper(myRoduxNetworking)
}))
