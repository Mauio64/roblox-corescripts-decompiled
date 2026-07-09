local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local SetSignUpSelectedBundleId = require(Modules.LuaApp.Actions.Authentication.SetSignUpSelectedBundleId)

return Rodux.createReducer("", {
	[SetSignUpSelectedBundleId.name] = function(_, p2) -- line: 9
		-- upvalues: ArgCheck (copy)
		local bundleId = p2.bundleId

		ArgCheck.isTypeOrNil(bundleId, "string", "action.bundleId from SetSignUpSelectedBundleId")

		return bundleId
	end
})
