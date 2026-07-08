local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local Rodux = require(SocialExperienceJoinParent.Rodux)
local myRoduxNetworking = require(SocialExperienceJoin.Networking.myRoduxNetworking)
local Games = require(SocialExperienceJoin.Rodux.Games)
local Presence = require(SocialExperienceJoin.Rodux.Presence)

return function() -- line: 14
	-- upvalues: Rodux (copy), myRoduxNetworking (copy), Games (copy), Presence (copy)
	return Rodux.combineReducers({
		NetworkStatus = myRoduxNetworking.installReducer(),
		Games = Games.installReducer(),
		Presence = Presence.installReducer()
	})
end
