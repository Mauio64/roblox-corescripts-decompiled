local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local parent = EditProfileBackground.Parent
local Rodux = require(parent.Rodux)
local ProfileRoduxNetworking = require(EditProfileBackground.Networking.ProfileRoduxNetworking)

return function()
	return Rodux.combineReducers({
		NetworkStatus = ProfileRoduxNetworking.installReducer()
	})
end
