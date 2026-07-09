local ParentParent = script.Parent.Parent
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)
local JestGlobals = require(ParentParent.Dev.JestGlobals)

JestGlobals.expect.extend(LuaSocialLibrariesDeps.CollisionMatchers.Jest)

return {
	JestGlobals = JestGlobals,
	ReactRoblox = require(ParentParent.Dev.ReactRoblox),
	Mock = LuaSocialLibrariesDeps.Mock,
	UnitTestHelpers = require(ParentParent.Dev.SocialTestHelpers).TestHelpers,
	Rhodium = require(ParentParent.Dev.Rhodium),
	RhodiumHelpers = function() -- line: 15
		-- upvalues: ParentParent (copy)
		return require(ParentParent.Dev.RhodiumHelpers)
	end,
	createTreeWithProviders = require(ParentParent.Dev.SocialTestHelpers).TestHelpers.createTreeWithProviders,
	DeferredLuaHelpers = require(ParentParent.Dev.TestUtils).DeferredLuaHelpers
}
