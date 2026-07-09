local ParentParent = script.Parent.Parent

return {
	JestGlobals = require(ParentParent.Dev.JestGlobals),
	ReactRoblox = require(ParentParent.Dev.ReactRoblox),
	Mock = require(ParentParent.LuaSocialLibrariesDeps).Mock,
	UnitTestHelpers = require(ParentParent.Dev.SocialTestHelpers).TestHelpers,
	RhodiumHelpers = function() -- line: 9
		-- upvalues: ParentParent (copy)
		return require(ParentParent.Dev.RhodiumHelpers)
	end,
	DeferredLuaHelpers = require(ParentParent.Dev.TestUtils).DeferredLuaHelpers
}
