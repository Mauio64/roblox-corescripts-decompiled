local parent = script:FindFirstAncestor("FriendsMenu").Parent

local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local function getRenameFriendsToConnectionsEnabledFriendsMenu()
	return UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()
end

return getRenameFriendsToConnectionsEnabledFriendsMenu
