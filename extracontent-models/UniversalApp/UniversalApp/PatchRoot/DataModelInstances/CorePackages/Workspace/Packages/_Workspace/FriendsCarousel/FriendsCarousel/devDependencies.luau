local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local LuaSocialLibrariesDeps = require(scriptParentParent.LuaSocialLibrariesDeps)
local JestGlobals = require(scriptParentParent.Dev.JestGlobals)
local expect = JestGlobals.expect
local RODUX_KEY = require(scriptParent.Common.Constants).RODUX_KEY

expect.extend(LuaSocialLibrariesDeps.CollisionMatchers.Jest)

local TestHelpers = require(scriptParentParent.Dev.SocialTestHelpers).TestHelpers
local getBaseTestStates = TestHelpers.getBaseTestStates

return {
	Mock = LuaSocialLibrariesDeps.Mock,
	UnitTestHelpers = TestHelpers,
	CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers,
	Rhodium = require(scriptParentParent.Dev.Rhodium),
	RhodiumHelpers = function() -- line: 19
		-- upvalues: scriptParentParent (copy)
		return require(scriptParentParent.Dev.RhodiumHelpers)
	end,
	JestGlobals = JestGlobals,
	jestExpect = expect,
	jest = JestGlobals.jest,
	UIBloxUniversalAppConfig = require(scriptParentParent.Dev.RobloxAppUIBloxConfig),
	baseTestStates = getBaseTestStates({
		roduxKey = RODUX_KEY
	}),
	mockLocale = function() -- line: 29
		-- upvalues: scriptParentParent (copy)
		return require(scriptParentParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
	end,
	findImageSet = require(scriptParentParent.Dev.SocialTestHelpers).TestHelpers.findImageSet,
	MockAppStorageService = require(scriptParentParent.Dev.SocialTestHelpers).TestHelpers.MockAppStorageService
}
