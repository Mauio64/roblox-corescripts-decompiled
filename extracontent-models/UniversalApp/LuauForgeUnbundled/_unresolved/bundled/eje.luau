local module = require("@luauforge/bundled/ejf")
local challengeRequestWrapper = require("@luauforge/bundled/ejg").Middleware.ChallengeRequestWrapper

local module2 = require("@luauforge/bundled/ejh")

local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/UserRelationshipModals/Networking/myRoduxNetworking")

return (module.config({
	keyPath = `{module2}.NetworkStatus`,
	networkImpl = challengeRequestWrapper(myRoduxNetworking)
}))
