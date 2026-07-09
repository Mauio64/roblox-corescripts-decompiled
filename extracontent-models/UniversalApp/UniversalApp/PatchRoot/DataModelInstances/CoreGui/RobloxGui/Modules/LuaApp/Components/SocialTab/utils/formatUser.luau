local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama
local PresenceType = LuaSocialLibrariesDeps.RoduxPresence.config({}).Enums.PresenceType
local UserModel = require(CorePackages.Workspace.Packages.UserLib).Models.UserModel
local t1 = {
	[PresenceType.InGame] = UserModel.PresenceType.IN_GAME,
	[PresenceType.Online] = UserModel.PresenceType.ONLINE,
	[PresenceType.InStudio] = UserModel.PresenceType.IN_STUDIO,
	[PresenceType.Offline] = UserModel.PresenceType.OFFLINE
}

return function(p1) -- line: 16
	-- upvalues: t (copy), llama (copy), t1 (copy), PresenceType (copy)
	assert(t.table(p1), "formatUser: user should be a table")

	return llama.Dictionary.join(p1, {
		name = p1.username,
		gameInstanceId = p1.gameId,
		presence = t1[p1.userPresenceType] or t1[PresenceType.Offline]
	})
end
