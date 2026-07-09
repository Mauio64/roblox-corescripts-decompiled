local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SignUpUsername = require(Modules.LuaApp.Reducers.Authentication.SignUpUsername)
local SignUpPassword = require(Modules.LuaApp.Reducers.Authentication.SignUpPassword)
local SignUpBundles = require(Modules.LuaApp.Reducers.Authentication.SignUpBundles)
local SignUpBirthday = require(Modules.LuaApp.Reducers.Authentication.SignUpBirthday)
local SignUpSelectedBundleId = require(Modules.LuaApp.Reducers.Authentication.SignUpSelectedBundleId)
local ClearSignUpInfo = require(Modules.LuaApp.Actions.Authentication.ClearSignUpInfo)
local HumanoidDescriptionProperties = require(Modules.LuaApp.Reducers.Authentication.HumanoidDescriptionProperties)

return function(p1, p2) -- line: 11
	-- upvalues: ClearSignUpInfo (copy), SignUpBirthday (copy), SignUpUsername (copy), SignUpPassword (copy), SignUpSelectedBundleId (copy), SignUpBundles (copy), HumanoidDescriptionProperties (copy)
	local v11 = p1 or {}

	if p2.type == ClearSignUpInfo.name then
		v11 = {}
	end

	return {
		SignUpBirthday = SignUpBirthday(v11.SignUpBirthday, p2),
		SignUpUsername = SignUpUsername(v11.SignUpUsername, p2),
		SignUpPassword = SignUpPassword(v11.SignUpPassword, p2),
		SignUpSelectedBundleId = SignUpSelectedBundleId(v11.SignUpSelectedBundleId, p2),
		SignUpBundles = SignUpBundles(v11.SignUpBundles, p2),
		HumanoidDescriptionProperties = HumanoidDescriptionProperties(v11.HumanoidDescriptionProperties, p2)
	}
end
