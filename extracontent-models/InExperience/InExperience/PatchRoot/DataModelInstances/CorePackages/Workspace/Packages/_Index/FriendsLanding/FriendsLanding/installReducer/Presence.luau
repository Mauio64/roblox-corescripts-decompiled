local FriendsLanding = script:FindFirstAncestor("FriendsLanding")

if require(FriendsLanding.Flags.FFlagFriendsLandingDeprecateUnusedMapToUsers) then
	return nil
end

local RoduxPresence = require(FriendsLanding.dependencies).RoduxPresence
local convertActions = require(script.Parent.convertActions)
local presenceActionAdaptor = require(script.Parent.presenceActionAdaptor)
local t1 = {
	byUserId = {},
	byGameId = {},
	byGameInstanceId = {},
	byPlaceId = {}
}

return (convertActions(RoduxPresence.installReducer(), presenceActionAdaptor, t1))
