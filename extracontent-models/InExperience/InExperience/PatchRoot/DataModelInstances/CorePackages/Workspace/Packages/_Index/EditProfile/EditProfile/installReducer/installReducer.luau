local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local Rodux = require(EditProfileParent.Rodux)
local ProfileRoduxNetworking = require(EditProfile.Networking.ProfileRoduxNetworking)

return function() -- line: 6
	-- upvalues: Rodux (copy), ProfileRoduxNetworking (copy)
	return Rodux.combineReducers({
		NetworkStatus = ProfileRoduxNetworking.installReducer()
	})
end
