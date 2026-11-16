local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama
local presenceType = LuaSocialLibrariesDeps.RoduxPresence.config({}).Enums.PresenceType
local userModel = require("@luauforge/bundled/cgr").Models.UserModel

local v5 = {
	[presenceType.InGame] = userModel.PresenceType.IN_GAME,
	[presenceType.Online] = userModel.PresenceType.ONLINE,
	[presenceType.InStudio] = userModel.PresenceType.IN_STUDIO,
	[presenceType.Offline] = userModel.PresenceType.OFFLINE
}

return function(data)
	assert(t.table(data), "formatUser: user should be a table")

	return llama.Dictionary.join(data, {
		name = data.username,
		gameInstanceId = data.gameId,
		presence = v5[data.userPresenceType] or v5[presenceType.Offline]
	})
end
