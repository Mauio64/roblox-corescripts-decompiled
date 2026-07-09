local CorePackages = game:GetService("CorePackages")
local FFlagLuaAppSortDeeplinkFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSortDeeplinkFix
local v3 = game:DefineFastString("FStringDeeplinkOmniSortIdMap", "        Curated = 100000008,\n        Continue = 100000003,\n        Sponsored = 400000000,\n        Favorites = 100000001,\n    ")
local v4 = game:DefineFastString("FStringDeeplinkSortIdMap", "        Continue_Playing = 100000003,\n        Sponsored = 400000000,\n        Top_Earning = Top_Earning_L7RS_V4,\n        Up_And_Coming = Up_And_Coming_V4,\n        Top_Revisited = Top_Revisited_Existing_Users_V4,\n        Top_Trending = Top_Trending_V4,\n        Fun_With_Friends = Fun_With_Friends_V4,\n        Top_Rated = Top_Rated_V4,\n        Most_Engaging = Most_engaging_V4,\n        Top_Paid = Top_Paid_V4,\n        Trending_in_Roleplay = Trending_in_Roleplay_V4,\n        Trending_in_Simulator = Trending_in_Simulator_V4,\n        Trending_in_Fighting = Trending_in_Fighting_V4,\n        Trending_in_Action = Trending_in_Action_V4,\n        Trending_in_Tycoon = Trending_in_Tycoon_V4,\n        Trending_in_Survival = Trending_in_Survival_V4,\n        Trending_in_Obby = Trending_in_Obby_V4,\n        Trending_in_Strategy = Trending_in_Strategy_V4,\n        Trending_in_Racing = Trending_in_Racing_V4,\n        Trending_in_Sports = Trending_in_Sports_V4,\n        Trending_in_Shooting = Trending_in_Shooting_V4,\n        Trending_in_Hangout = Trending_in_Hangout_V4,\n        Only_17_Plus = Only_17_Plus_V4,\n        Learn_And_Explore = Learn_And_Explore_V4,\n        More_When_You_Subscribe = More_When_You_Subscribe_V4,\n    ")
local v5 = game:DefineFastString("FStringOmniSortsList", "100000003, 400000000")
local t1 = {}
local v7 = if not FFlagLuaAppSortDeeplinkFix then {} else nil
local u8 = false

return function(s1: string) -- line: 61
	-- upvalues: FFlagLuaAppSortDeeplinkFix (copy), u8 (ref), v3 (copy), t1 (copy), v4 (copy), v5 (copy), v7 (copy)
	if FFlagLuaAppSortDeeplinkFix then
		if not u8 then
			for match, v11 in v3:gmatch("([_%w]+) ?= ?([_%w]+)") do
				t1[match:lower()] = v11
			end

			u8 = true
		end

		local v12 = t1[s1:lower()]

		return v12 or s1:lower(), v12 ~= nil
	end

	if not u8 then
		for match, v14 in v4:gmatch("([_%w]+) ?= ?([_%w]+)") do
			t1[match:lower()] = v14
		end

		for match in v5:gmatch("(%w+)") do
			v7[match] = true
		end

		u8 = true
	end

	local v16 = t1[s1:lower()]

	if v16 then
		return v16, v7[v16] or false
	end

	return s1, v7[s1] or false
end
