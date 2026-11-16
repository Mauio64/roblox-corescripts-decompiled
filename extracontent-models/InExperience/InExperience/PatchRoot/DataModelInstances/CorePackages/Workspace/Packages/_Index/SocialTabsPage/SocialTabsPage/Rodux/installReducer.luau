local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local Rodux = require(parent.Rodux)
local myRoduxNetworking = require(SocialTabsPage.Networking.myRoduxNetworking)

return function()
	return Rodux.combineReducers({
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
