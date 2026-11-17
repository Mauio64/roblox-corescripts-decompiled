require(script.Parent.Parent.Parent.Parent.Parent.proto)
require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

v.DisplayLocation = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "DISPLAY_LOCATION_INVALID"
		elseif p == 1 then
			return "DISPLAY_LOCATION_GLOBAL"
		elseif p == 2 then
			return "DISPLAY_LOCATION_BADGE_SEE_ALL"
		elseif p == 3 then
			return "DISPLAY_LOCATION_BADGE_DETAILS"
		elseif p == 4 then
			return "DISPLAY_LOCATION_PROMPTS"
		elseif p == 5 then
			return "DISPLAY_LOCATION_EXPERIENCE_DETAILS"
		elseif p == 6 then
			return "DISPLAY_LOCATION_DEV_STORE_SEE_ALL"
		elseif p == 7 then
			return "DISPLAY_LOCATION_CHARTS"
		elseif p == 8 then
			return "DISPLAY_LOCATION_EVENT_DETAILS"
		elseif p == 9 then
			return "DISPLAY_LOCATION_MARKETPLACE_LANDING"
		elseif p == 10 then
			return "DISPLAY_LOCATION_SEARCH_RESULTS"
		elseif p == 11 then
			return "DISPLAY_LOCATION_SEARCH_LANDING"
		elseif p == 12 then
			return "DISPLAY_LOCATION_SPOTLIGHT"
		elseif p == 13 then
			return "DISPLAY_LOCATION_HOME"
		elseif p == 14 then
			return "DISPLAY_LOCATION_SPOTLIGHT_COLLECTION"
		elseif p == 15 then
			return "DISPLAY_LOCATION_PARTY_CHAT"
		elseif p == 16 then
			return "DISPLAY_LOCATION_MARKETPLACE_FAVORITES_SAVED"
		elseif p == 17 then
			return "DISPLAY_LOCATION_PRE_AUTH_LANDING"
		elseif p == 18 then
			return "DISPLAY_LOCATION_SETTINGS"
		elseif p == 19 then
			return "DISPLAY_LOCATION_BUILD"
		elseif p == 20 then
			return "DISPLAY_LOCATION_COMMUNITY_PROFILE"
		elseif p == 21 then
			return "DISPLAY_LOCATION_MARKETPLACE_ITEM_DETAILS"
		elseif p == 22 then
			return "DISPLAY_LOCATION_HOME_SORT_DETAIL"
		elseif p == 23 then
			return "DISPLAY_LOCATION_SANDBOX"
		elseif p == 24 then
			return "DISPLAY_LOCATION_GROUP_PROFILE"
		elseif p == 25 then
			return "DISPLAY_LOCATION_SEARCH_AUTOCOMPLETE"
		elseif p == 26 then
			return "DISPLAY_LOCATION_EXPERIENCE_LEADERBOARD_SEE_ALL"
		elseif p == 27 then
			return "DISPLAY_LOCATION_CREATOR_EXPERIENCE_SETTINGS"
		elseif p == 28 then
			return "DISPLAY_LOCATION_BUY_ROBUX"
		elseif p == 29 then
			return "DISPLAY_LOCATION_USER_LIBRARY"
		elseif p == 30 then
			return "DISPLAY_LOCATION_PERKS"
		elseif p == 31 then
			return "DISPLAY_LOCATION_NOTIFICATION_STREAM"
		elseif p == 32 then
			return "DISPLAY_LOCATION_USER_PROFILE_FRIEND_RECOMMENDATIONS"
		elseif p == 33 then
			return "DISPLAY_LOCATION_GAME_ITEM_DETAILS"
		elseif p == 34 then
			return "DISPLAY_LOCATION_CAMPAIGN"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "DISPLAY_LOCATION_INVALID" then
			return 0
		elseif p == "DISPLAY_LOCATION_GLOBAL" then
			return 1
		elseif p == "DISPLAY_LOCATION_BADGE_SEE_ALL" then
			return 2
		elseif p == "DISPLAY_LOCATION_BADGE_DETAILS" then
			return 3
		elseif p == "DISPLAY_LOCATION_PROMPTS" then
			return 4
		elseif p == "DISPLAY_LOCATION_EXPERIENCE_DETAILS" then
			return 5
		elseif p == "DISPLAY_LOCATION_DEV_STORE_SEE_ALL" then
			return 6
		elseif p == "DISPLAY_LOCATION_CHARTS" then
			return 7
		elseif p == "DISPLAY_LOCATION_EVENT_DETAILS" then
			return 8
		elseif p == "DISPLAY_LOCATION_MARKETPLACE_LANDING" then
			return 9
		elseif p == "DISPLAY_LOCATION_SEARCH_RESULTS" then
			return 10
		elseif p == "DISPLAY_LOCATION_SEARCH_LANDING" then
			return 11
		elseif p == "DISPLAY_LOCATION_SPOTLIGHT" then
			return 12
		elseif p == "DISPLAY_LOCATION_HOME" then
			return 13
		elseif p == "DISPLAY_LOCATION_SPOTLIGHT_COLLECTION" then
			return 14
		elseif p == "DISPLAY_LOCATION_PARTY_CHAT" then
			return 15
		elseif p == "DISPLAY_LOCATION_MARKETPLACE_FAVORITES_SAVED" then
			return 16
		elseif p == "DISPLAY_LOCATION_PRE_AUTH_LANDING" then
			return 17
		elseif p == "DISPLAY_LOCATION_SETTINGS" then
			return 18
		elseif p == "DISPLAY_LOCATION_BUILD" then
			return 19
		elseif p == "DISPLAY_LOCATION_COMMUNITY_PROFILE" then
			return 20
		elseif p == "DISPLAY_LOCATION_MARKETPLACE_ITEM_DETAILS" then
			return 21
		elseif p == "DISPLAY_LOCATION_HOME_SORT_DETAIL" then
			return 22
		elseif p == "DISPLAY_LOCATION_SANDBOX" then
			return 23
		elseif p == "DISPLAY_LOCATION_GROUP_PROFILE" then
			return 24
		elseif p == "DISPLAY_LOCATION_SEARCH_AUTOCOMPLETE" then
			return 25
		elseif p == "DISPLAY_LOCATION_EXPERIENCE_LEADERBOARD_SEE_ALL" then
			return 26
		elseif p == "DISPLAY_LOCATION_CREATOR_EXPERIENCE_SETTINGS" then
			return 27
		elseif p == "DISPLAY_LOCATION_BUY_ROBUX" then
			return 28
		elseif p == "DISPLAY_LOCATION_USER_LIBRARY" then
			return 29
		elseif p == "DISPLAY_LOCATION_PERKS" then
			return 30
		elseif p == "DISPLAY_LOCATION_NOTIFICATION_STREAM" then
			return 31
		elseif p == "DISPLAY_LOCATION_USER_PROFILE_FRIEND_RECOMMENDATIONS" then
			return 32
		elseif p == "DISPLAY_LOCATION_GAME_ITEM_DETAILS" then
			return 33
		elseif p == "DISPLAY_LOCATION_CAMPAIGN" then
			return 34
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "DISPLAY_LOCATION_INVALID" then
			return "DISPLAY_LOCATION_INVALID"
		elseif p == "DISPLAY_LOCATION_GLOBAL" then
			return "DISPLAY_LOCATION_GLOBAL"
		elseif p == "DISPLAY_LOCATION_BADGE_SEE_ALL" then
			return "DISPLAY_LOCATION_BADGE_SEE_ALL"
		elseif p == "DISPLAY_LOCATION_BADGE_DETAILS" then
			return "DISPLAY_LOCATION_BADGE_DETAILS"
		elseif p == "DISPLAY_LOCATION_PROMPTS" then
			return "DISPLAY_LOCATION_PROMPTS"
		elseif p == "DISPLAY_LOCATION_EXPERIENCE_DETAILS" then
			return "DISPLAY_LOCATION_EXPERIENCE_DETAILS"
		elseif p == "DISPLAY_LOCATION_DEV_STORE_SEE_ALL" then
			return "DISPLAY_LOCATION_DEV_STORE_SEE_ALL"
		elseif p == "DISPLAY_LOCATION_CHARTS" then
			return "DISPLAY_LOCATION_CHARTS"
		elseif p == "DISPLAY_LOCATION_EVENT_DETAILS" then
			return "DISPLAY_LOCATION_EVENT_DETAILS"
		elseif p == "DISPLAY_LOCATION_MARKETPLACE_LANDING" then
			return "DISPLAY_LOCATION_MARKETPLACE_LANDING"
		elseif p == "DISPLAY_LOCATION_SEARCH_RESULTS" then
			return "DISPLAY_LOCATION_SEARCH_RESULTS"
		elseif p == "DISPLAY_LOCATION_SEARCH_LANDING" then
			return "DISPLAY_LOCATION_SEARCH_LANDING"
		elseif p == "DISPLAY_LOCATION_SPOTLIGHT" then
			return "DISPLAY_LOCATION_SPOTLIGHT"
		elseif p == "DISPLAY_LOCATION_HOME" then
			return "DISPLAY_LOCATION_HOME"
		elseif p == "DISPLAY_LOCATION_SPOTLIGHT_COLLECTION" then
			return "DISPLAY_LOCATION_SPOTLIGHT_COLLECTION"
		elseif p == "DISPLAY_LOCATION_PARTY_CHAT" then
			return "DISPLAY_LOCATION_PARTY_CHAT"
		elseif p == "DISPLAY_LOCATION_MARKETPLACE_FAVORITES_SAVED" then
			return "DISPLAY_LOCATION_MARKETPLACE_FAVORITES_SAVED"
		elseif p == "DISPLAY_LOCATION_PRE_AUTH_LANDING" then
			return "DISPLAY_LOCATION_PRE_AUTH_LANDING"
		elseif p == "DISPLAY_LOCATION_SETTINGS" then
			return "DISPLAY_LOCATION_SETTINGS"
		elseif p == "DISPLAY_LOCATION_BUILD" then
			return "DISPLAY_LOCATION_BUILD"
		elseif p == "DISPLAY_LOCATION_COMMUNITY_PROFILE" then
			return "DISPLAY_LOCATION_COMMUNITY_PROFILE"
		elseif p == "DISPLAY_LOCATION_MARKETPLACE_ITEM_DETAILS" then
			return "DISPLAY_LOCATION_MARKETPLACE_ITEM_DETAILS"
		elseif p == "DISPLAY_LOCATION_HOME_SORT_DETAIL" then
			return "DISPLAY_LOCATION_HOME_SORT_DETAIL"
		elseif p == "DISPLAY_LOCATION_SANDBOX" then
			return "DISPLAY_LOCATION_SANDBOX"
		elseif p == "DISPLAY_LOCATION_GROUP_PROFILE" then
			return "DISPLAY_LOCATION_GROUP_PROFILE"
		elseif p == "DISPLAY_LOCATION_SEARCH_AUTOCOMPLETE" then
			return "DISPLAY_LOCATION_SEARCH_AUTOCOMPLETE"
		elseif p == "DISPLAY_LOCATION_EXPERIENCE_LEADERBOARD_SEE_ALL" then
			return "DISPLAY_LOCATION_EXPERIENCE_LEADERBOARD_SEE_ALL"
		elseif p == "DISPLAY_LOCATION_CREATOR_EXPERIENCE_SETTINGS" then
			return "DISPLAY_LOCATION_CREATOR_EXPERIENCE_SETTINGS"
		elseif p == "DISPLAY_LOCATION_BUY_ROBUX" then
			return "DISPLAY_LOCATION_BUY_ROBUX"
		elseif p == "DISPLAY_LOCATION_USER_LIBRARY" then
			return "DISPLAY_LOCATION_USER_LIBRARY"
		elseif p == "DISPLAY_LOCATION_PERKS" then
			return "DISPLAY_LOCATION_PERKS"
		elseif p == "DISPLAY_LOCATION_NOTIFICATION_STREAM" then
			return "DISPLAY_LOCATION_NOTIFICATION_STREAM"
		elseif p == "DISPLAY_LOCATION_USER_PROFILE_FRIEND_RECOMMENDATIONS" then
			return "DISPLAY_LOCATION_USER_PROFILE_FRIEND_RECOMMENDATIONS"
		elseif p == "DISPLAY_LOCATION_GAME_ITEM_DETAILS" then
			return "DISPLAY_LOCATION_GAME_ITEM_DETAILS"
		elseif p == "DISPLAY_LOCATION_CAMPAIGN" then
			return "DISPLAY_LOCATION_CAMPAIGN"
		end

		return nil
	end
}

return { DisplayLocation = v.DisplayLocation }
