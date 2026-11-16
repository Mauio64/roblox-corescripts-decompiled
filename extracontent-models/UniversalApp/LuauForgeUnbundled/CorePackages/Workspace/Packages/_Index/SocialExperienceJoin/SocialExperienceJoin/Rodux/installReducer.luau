local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/Rodux")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Networking/myRoduxNetworking")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Rodux/Games")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Rodux/Presence")

local FFlagSocialExperienceJoinPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Flags/FFlagSocialExperienceJoinPresenceStoreMigration")

return function()
	local combineReducers = Rodux.combineReducers
	local v5 = {
		NetworkStatus = myRoduxNetworking.installReducer(),
		Games = module3.installReducer(),
		Presence = 0
	}
	local v6 = if not FFlagSocialExperienceJoinPresenceStoreMigration then module4.installReducer() else nil
	v5.Presence = v6
	return combineReducers(v5)
end
