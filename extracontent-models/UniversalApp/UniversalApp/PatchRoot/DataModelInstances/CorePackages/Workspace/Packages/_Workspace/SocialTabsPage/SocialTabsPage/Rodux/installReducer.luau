local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local Rodux = require(SocialTabsPageParent.Rodux)
local myRoduxNetworking = require(SocialTabsPage.Networking.myRoduxNetworking)
local Presence = require(SocialTabsPage.Rodux.Presence)

return function() -- line: 8
	-- upvalues: Rodux (copy), Presence (copy), myRoduxNetworking (copy)
	return Rodux.combineReducers({
		Presence = Presence,
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
