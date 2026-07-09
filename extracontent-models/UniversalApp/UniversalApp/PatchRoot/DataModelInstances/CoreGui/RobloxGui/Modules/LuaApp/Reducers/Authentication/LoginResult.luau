local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetLoginResult = require(Modules.LuaApp.Actions.Authentication.SetLoginResult)
local LoginResult = require(Modules.LuaApp.Models.Authentication.LoginResult)

return require(CorePackages.Packages.Rodux).createReducer(LoginResult.new(), {
	[SetLoginResult.name] = function(_, p2) -- line: 9
		-- upvalues: LoginResult (copy)
		assert(LoginResult.is(p2.loginResult), "LoginResult must be a LoginResult model")

		return p2.loginResult
	end
})
