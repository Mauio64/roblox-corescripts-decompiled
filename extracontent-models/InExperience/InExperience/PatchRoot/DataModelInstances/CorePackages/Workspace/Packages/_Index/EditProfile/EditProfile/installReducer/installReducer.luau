local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local Rodux = require(parent.Rodux)
local ProfileRoduxNetworking = require(EditProfile.Networking.ProfileRoduxNetworking)

return function()
	return Rodux.combineReducers({
		NetworkStatus = ProfileRoduxNetworking.installReducer()
	})
end
