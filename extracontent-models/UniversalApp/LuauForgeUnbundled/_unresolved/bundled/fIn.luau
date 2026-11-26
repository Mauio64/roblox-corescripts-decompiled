local fFlagLuaAppSortDeeplinkFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSortDeeplinkFix

local defineFastString = game:DefineFastString("FStringDeeplinkOmniSortIdMap", [[
	        Curated = 100000008,
	        Continue = 100000003,
	        Sponsored = 400000000,
	        Favorites = 100000001,
	    ]])

local defineFastString2 = game:DefineFastString("FStringDeeplinkSortIdMap", [[
	        Continue_Playing = 100000003,
	        Sponsored = 400000000,
	        Top_Earning = Top_Earning_L7RS_V4,
	        Up_And_Coming = Up_And_Coming_V4,
	        Top_Revisited = Top_Revisited_Existing_Users_V4,
	        Top_Trending = Top_Trending_V4,
	        Fun_With_Friends = Fun_With_Friends_V4,
	        Top_Rated = Top_Rated_V4,
	        Most_Engaging = Most_engaging_V4,
	        Top_Paid = Top_Paid_V4,
	        Trending_in_Roleplay = Trending_in_Roleplay_V4,
	        Trending_in_Simulator = Trending_in_Simulator_V4,
	        Trending_in_Fighting = Trending_in_Fighting_V4,
	        Trending_in_Action = Trending_in_Action_V4,
	        Trending_in_Tycoon = Trending_in_Tycoon_V4,
	        Trending_in_Survival = Trending_in_Survival_V4,
	        Trending_in_Obby = Trending_in_Obby_V4,
	        Trending_in_Strategy = Trending_in_Strategy_V4,
	        Trending_in_Racing = Trending_in_Racing_V4,
	        Trending_in_Sports = Trending_in_Sports_V4,
	        Trending_in_Shooting = Trending_in_Shooting_V4,
	        Trending_in_Hangout = Trending_in_Hangout_V4,
	        Only_17_Plus = Only_17_Plus_V4,
	        Learn_And_Explore = Learn_And_Explore_V4,
	        More_When_You_Subscribe = More_When_You_Subscribe_V4,
	    ]])

local defineFastString3 = game:DefineFastString("FStringOmniSortsList", "100000003, 400000000")

local v5 = {}
local v6 = not fFlagLuaAppSortDeeplinkFix and {} or nil
local v7 = false

return function(value)
	if fFlagLuaAppSortDeeplinkFix then
		if not v7 then
			for k, v8 in defineFastString:gmatch("([_%w]+) ?= ?([_%w]+)") do
				v5[k:lower()] = v8
			end

			v7 = true
		end

		local v8 = v5[value:lower()]
		return v8 or value:lower(), v8 ~= nil
	else
		if not v7 then
			for k, v8 in defineFastString2:gmatch("([_%w]+) ?= ?([_%w]+)") do
				v5[k:lower()] = v8
			end

			for k in defineFastString3:gmatch("(%w+)") do
				v6[k] = true
			end

			v7 = true
		end

		local v8 = v5[value:lower()]

		if v8 then
			return v8, v6[v8] or false
		end

		return value, v6[value] or false
	end
end
