local Parent = script:FindFirstAncestor("FriendsMenu").Parent
local UniversalAppPolicy = require(Parent.UniversalAppPolicy)

local function getRenameFriendsToConnectionsEnabledFriendsMenu() -- line: 6
	-- upvalues: UniversalAppPolicy (copy)
	return UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()
end

return getRenameFriendsToConnectionsEnabledFriendsMenu
