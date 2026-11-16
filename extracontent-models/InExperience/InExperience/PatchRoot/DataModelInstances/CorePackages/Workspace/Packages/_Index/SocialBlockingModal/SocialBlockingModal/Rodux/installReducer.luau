local SocialBlockingModal = script:FindFirstAncestor("SocialBlockingModal")
local parent = SocialBlockingModal.Parent

local Rodux = require(parent.Rodux)

local myRoduxNetworking = require(SocialBlockingModal.Networking.myRoduxNetworking)

return function()
	return Rodux.combineReducers({
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
