local ParentParent = script.Parent.Parent
local JestGlobals = require(ParentParent.Dev.JestGlobals)
local LuaSocialLibrariesDeps = require(ParentParent.Dev.LuaSocialLibrariesDeps)

JestGlobals.expect.extend(LuaSocialLibrariesDeps.CollisionMatchers.Jest)

return {
	JestGlobals = JestGlobals,
	UnitTestHelpers = require(ParentParent.Dev.SocialTestHelpers).TestHelpers,
	Rhodium = require(ParentParent.Dev.Rhodium),
	RhodiumHelpers = function() -- line: 13
		-- upvalues: ParentParent (copy)
		return require(ParentParent.Dev.RhodiumHelpers)
	end,
	createTreeWithProviders = require(ParentParent.Dev.SocialTestHelpers).TestHelpers.createTreeWithProviders
}
