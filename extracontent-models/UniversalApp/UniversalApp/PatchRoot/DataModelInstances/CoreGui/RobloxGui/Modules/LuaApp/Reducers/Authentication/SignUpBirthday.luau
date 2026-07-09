local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetSignUpBirthday = require(Modules.LuaApp.Actions.Authentication.SetSignUpBirthday)
local Birthday = require(CorePackages.Workspace.Packages.AuthCommon).Models.Birthday

return require(CorePackages.Packages.Rodux).createReducer(Birthday.new(), {
	[SetSignUpBirthday.name] = function(_, p2) -- line: 9
		-- upvalues: Birthday (copy)
		assert(Birthday.is(p2.birthday), "SignUpBirthday must be a Birthday model")

		return p2.birthday
	end
})
