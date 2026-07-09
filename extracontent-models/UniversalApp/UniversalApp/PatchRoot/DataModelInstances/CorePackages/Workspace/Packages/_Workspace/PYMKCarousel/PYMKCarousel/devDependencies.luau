local ParentParent = script.Parent.Parent
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)
local JestGlobals = require(ParentParent.Dev.JestGlobals)
local expect = JestGlobals.expect
local TestUtils = require(ParentParent.Dev.TestUtils)

expect.extend(LuaSocialLibrariesDeps.CollisionMatchers.Jest)

return {
	Mock = LuaSocialLibrariesDeps.Mock,
	CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers,
	UnitTestHelpers = require(ParentParent.Dev.SocialTestHelpers).TestHelpers,
	Rhodium = require(ParentParent.Dev.Rhodium),
	RhodiumHelpers = function() -- line: 16
		-- upvalues: ParentParent (copy)
		return require(ParentParent.Dev.RhodiumHelpers)
	end,
	JestGlobals = JestGlobals,
	jestExpect = expect,
	jest = JestGlobals.jest,
	findImageSet = require(ParentParent.Dev.SocialTestHelpers).TestHelpers.findImageSet,
	DeferredLuaHelpers = TestUtils.DeferredLuaHelpers,
	waitUntil = TestUtils.waitUntil
}
