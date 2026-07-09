local ParentParent = script.Parent.Parent
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)
local JestGlobals = require(ParentParent.Dev.JestGlobals)
local expect = JestGlobals.expect
local TestUtils = require(ParentParent.Dev.TestUtils)

return {
	ReactRoblox = require(ParentParent.Dev.ReactRoblox),
	Rhodium = require(ParentParent.Dev.Rhodium),
	Mock = LuaSocialLibrariesDeps.Mock,
	UnitTestHelpers = require(ParentParent.Dev.SocialTestHelpers).TestHelpers,
	jestExpect = expect,
	jest = JestGlobals.jest,
	describe = JestGlobals.describe,
	it = JestGlobals.it,
	beforeAll = JestGlobals.beforeAll,
	afterAll = JestGlobals.afterAll,
	expect = JestGlobals.expect,
	RhodiumHelpers = function() -- line: 20
		-- upvalues: ParentParent (copy)
		return require(ParentParent.Dev.RhodiumHelpers)
	end,
	waitUntil = TestUtils.waitUntil,
	DeferredLuaHelpers = TestUtils.DeferredLuaHelpers
}
