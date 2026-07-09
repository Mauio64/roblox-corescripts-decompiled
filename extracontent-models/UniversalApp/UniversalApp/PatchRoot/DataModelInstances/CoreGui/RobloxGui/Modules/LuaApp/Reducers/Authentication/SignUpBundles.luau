local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local SetSignUpBundles = require(Modules.LuaApp.Actions.Authentication.SetSignUpBundles)

return Rodux.createReducer({}, {
	[SetSignUpBundles.name] = function(_, p2) -- line: 8
		return p2.bundles
	end
})
