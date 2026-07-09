local Parent = script:FindFirstAncestor("InviteLinkExpiredModal").Parent
local LuaSocialLibrariesDeps = require(Parent.LuaSocialLibrariesDeps)
local JestGlobals = require(Parent.Dev.JestGlobals)

JestGlobals.expect.extend(LuaSocialLibrariesDeps.CollisionMatchers.Jest)

return {
	JestGlobals = JestGlobals,
	ReactRoblox = require(Parent.Dev.ReactRoblox),
	Mock = LuaSocialLibrariesDeps.Mock,
	UnitTestHelpers = require(Parent.Dev.SocialTestHelpers).TestHelpers,
	Rhodium = require(Parent.Dev.Rhodium),
	RhodiumHelpers = function() -- line: 15
		-- upvalues: Parent (copy)
		return require(Parent.Dev.RhodiumHelpers)
	end,
	createTreeWithProviders = require(Parent.Dev.SocialTestHelpers).TestHelpers.createTreeWithProviders,
	DeferredLuaHelpers = require(Parent.Dev.TestUtils).DeferredLuaHelpers
}
