local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local Rodux = require(SocialTabsPageParent.Rodux)
local myRoduxNetworking = require(SocialTabsPage.Networking.myRoduxNetworking)
local Presence = require(SocialTabsPage.Rodux.Presence)
local FFlagSocialTabsPagePresenceSignalsMigration = require(SocialTabsPage.Flags.FFlagSocialTabsPagePresenceSignalsMigration)

return function() -- line: 11
	-- upvalues: Rodux (copy), FFlagSocialTabsPagePresenceSignalsMigration (copy), Presence (copy), myRoduxNetworking (copy)
	return Rodux.combineReducers({
		Presence = if FFlagSocialTabsPagePresenceSignalsMigration then nil else Presence,
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
