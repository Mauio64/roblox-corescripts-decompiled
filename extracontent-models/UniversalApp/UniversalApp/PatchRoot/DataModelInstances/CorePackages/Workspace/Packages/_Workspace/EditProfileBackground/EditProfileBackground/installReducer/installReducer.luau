local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local EditProfileBackgroundParent = EditProfileBackground.Parent
local Rodux = require(EditProfileBackgroundParent.Rodux)
local ProfileRoduxNetworking = require(EditProfileBackground.Networking.ProfileRoduxNetworking)

return function() -- line: 6
	-- upvalues: Rodux (copy), ProfileRoduxNetworking (copy)
	return Rodux.combineReducers({
		NetworkStatus = ProfileRoduxNetworking.installReducer()
	})
end
