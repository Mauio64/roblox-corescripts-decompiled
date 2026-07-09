local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local LuaSocialLibrariesDeps = require(scriptParentParent.LuaSocialLibrariesDeps)
local ReactRoblox = require(scriptParentParent.ReactRoblox)
local JestGlobals = require(scriptParentParent.Dev.JestGlobals)
local expect = JestGlobals.expect
local MessageBus = require(scriptParentParent.Dev.MessageBus).MessageBus
local createTreeWithProviders = require(scriptParent.TestHelpers.createTreeWithProviders)

expect.extend(LuaSocialLibrariesDeps.CollisionMatchers.Jest)

return {
	Mock = LuaSocialLibrariesDeps.Mock,
	UnitTestHelpers = require(scriptParentParent.Dev.SocialTestHelpers).TestHelpers,
	CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers,
	Rhodium = require(scriptParentParent.Dev.Rhodium),
	RhodiumHelpers = function() -- line: 20
		-- upvalues: scriptParentParent (copy)
		return require(scriptParentParent.Dev.RhodiumHelpers)
	end,
	JestGlobals = JestGlobals,
	jestExpect = expect,
	jest = JestGlobals.jest,
	act = ReactRoblox.act,
	UIBloxUniversalAppConfig = require(scriptParentParent.Dev.RobloxAppUIBloxConfig),
	createTreeWithProviders = createTreeWithProviders,
	MessageBus = MessageBus,
	findImageSet = require(scriptParentParent.Dev.SocialTestHelpers).TestHelpers.findImageSet,
	DeferredLuaHelpers = require(scriptParentParent.Dev.TestUtils).DeferredLuaHelpers,
	MockAppStorageService = require(scriptParentParent.Dev.SocialTestHelpers).TestHelpers.MockAppStorageService
}
