local FriendsLanding = script:FindFirstAncestor("FriendsLanding")

if require(FriendsLanding.Flags.FFlagFriendsLandingDeprecateUnusedMapToUsers) then
	return nil
end

local RoduxUsers = require(FriendsLanding.dependencies).RoduxUsers
local convertActions = require(script.Parent.convertActions)
local usersActionAdaptor = require(script.Parent.usersActionAdaptor)
local t1 = {
	byUserId = {},
	byUsername = {}
}

return (convertActions(RoduxUsers.installReducer(), usersActionAdaptor, t1))
