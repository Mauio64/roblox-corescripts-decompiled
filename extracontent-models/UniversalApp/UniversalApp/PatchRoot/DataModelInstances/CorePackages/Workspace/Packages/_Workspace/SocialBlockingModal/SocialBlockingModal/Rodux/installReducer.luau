local SocialBlockingModal = script:FindFirstAncestor("SocialBlockingModal")
local SocialBlockingModalParent = SocialBlockingModal.Parent
local Rodux = require(SocialBlockingModalParent.Rodux)
local myRoduxNetworking = require(SocialBlockingModal.Networking.myRoduxNetworking)

return function() -- line: 8
	-- upvalues: Rodux (copy), myRoduxNetworking (copy)
	return Rodux.combineReducers({
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
