local ParentParent = script.Parent.Parent
local ReactRoblox = require(ParentParent.ReactRoblox)
local JestGlobals = require(ParentParent.Dev.JestGlobals)
local expect = JestGlobals.expect

return {
	Rhodium = require(ParentParent.Dev.Rhodium),
	RhodiumHelpers = function() -- line: 11
		-- upvalues: ParentParent (copy)
		return require(ParentParent.Dev.RhodiumHelpers)
	end,
	JestGlobals = JestGlobals,
	jestExpect = expect,
	jest = JestGlobals.jest,
	act = ReactRoblox.act,
	UIBloxUniversalAppConfig = require(ParentParent.Dev.RobloxAppUIBloxConfig),
	DeferredLuaHelpers = require(ParentParent.Dev.TestUtils).DeferredLuaHelpers
}
