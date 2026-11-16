local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent
local Rodux = require(parent.Rodux)
local myRoduxNetworking = require(SocialExperienceJoin.Networking.myRoduxNetworking)
local Games = require(SocialExperienceJoin.Rodux.Games)
local Presence = require(SocialExperienceJoin.Rodux.Presence)

local FFlagSocialExperienceJoinPresenceStoreMigration = require(SocialExperienceJoin.Flags.FFlagSocialExperienceJoinPresenceStoreMigration)

return function()
	local combineReducers = Rodux.combineReducers
	local v = {
		NetworkStatus = myRoduxNetworking.installReducer(),
		Games = Games.installReducer(),
		Presence = 0
	}
	local presence

	if not FFlagSocialExperienceJoinPresenceStoreMigration then
		presence = Presence.installReducer()
	end

	v.Presence = presence
	return combineReducers(v)
end
