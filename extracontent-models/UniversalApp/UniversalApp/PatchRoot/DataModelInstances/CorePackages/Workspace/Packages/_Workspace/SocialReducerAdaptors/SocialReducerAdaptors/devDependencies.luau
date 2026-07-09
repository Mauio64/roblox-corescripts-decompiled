local ParentParent = script.Parent.Parent
local JestGlobals = require(ParentParent.Dev.JestGlobals)
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)

JestGlobals.expect.extend(LuaSocialLibrariesDeps.CollisionMatchers.Jest)

local FriendsRodux = require(ParentParent.FriendsRodux)

return {
	JestGlobals = JestGlobals,
	RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers.config({
		keyPath = "SharedTest.Users"
	}),
	RoduxFriends = FriendsRodux.config({
		keyPath = "SharedTest.Friends"
	}),
	RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence.config({
		keyPath = "SharedTest.Presence"
	})
}
