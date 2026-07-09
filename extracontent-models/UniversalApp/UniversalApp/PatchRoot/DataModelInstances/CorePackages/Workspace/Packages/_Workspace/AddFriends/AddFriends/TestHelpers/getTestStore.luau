local Parent = script:FindFirstAncestor("AddFriends").Parent
local Rodux = require(Parent.Rodux)
local llama = require(Parent.llama)
local getBaseTestStates = require(Parent.Dev.SocialTestHelpers).TestHelpers.getBaseTestStates
local RODUX_KEY = require(Parent.AddFriendsState).RODUX_KEY

return function(p1, b1: boolean?, p2, n1: number?) -- line: 11
	-- upvalues: getBaseTestStates (copy), RODUX_KEY (copy), llama (copy), Rodux (copy)
	local v10 = if not b1 or p1 then if not b1 or not p1 then getBaseTestStates({
		roduxKey = RODUX_KEY
	}).smallNumbersOfFriends else getBaseTestStates({
		roduxKey = RODUX_KEY
	}).friendsAndRecommendations else getBaseTestStates({
		roduxKey = RODUX_KEY
	}).recommendationsOnly
	local v11 = v10[RODUX_KEY]
	local t1 = {}

	for i = 1, 40 do
		t1[tostring(i)] = i
	end

	local t2 = {}
	local n2 = 0
	local s1 = nil
	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local t7 = {}
	local t8 = {}

	if p1 then
		t2 = v11.Users.byUserId
		n2 = n1 or #llama.Dictionary.keys(v11.Users.byUserId)
		s1 = "next"
		t6 = {
			["36"] = "game_universe_id_36",
			["37"] = "game_universe_id_37",
			["38"] = "game_universe_id_39"
		}
		t4 = {
			["36"] = {
				isFollowing = true,
				isFollowed = true
			},
			["37"] = {
				isFollowing = false,
				isFollowed = true
			},
			["38"] = {
				isFollowing = true,
				isFollowed = false
			},
			["39"] = {
				isFollowing = true,
				isFollowed = true
			}
		}
		t5 = {
			game_universe_id_36 = {
				name = "test game"
			},
			game_universe_id_37 = {
				name = "test game"
			},
			game_universe_id_38 = {
				name = "test game"
			}
		}
		t7 = {
			["1"] = {
				"Bob",
				"Corey",
				"Andrew"
			},
			["2"] = {},
			["3"] = {}
		}
	end

	if b1 then
		t8 = getBaseTestStates({
			roduxKey = RODUX_KEY
		}).recommendationsOnly[RODUX_KEY].Friends.recommendations
	end

	return Rodux.Store.new(function() -- line: 78
		-- upvalues: v10 (copy), llama (copy), v11 (copy), RODUX_KEY (copy), t1 (copy), t2 (ref), n2 (ref), s1 (ref), t6 (ref), t7 (ref), t8 (ref), t3 (copy), t4 (ref), t5 (ref), p2 (copy)
		return {
			ScreenSize = Vector2.new(540, 960),
			TopBar = {
				topBarHeight = 60
			},
			GlobalGuiInset = {
				top = 20,
				bottom = 20,
				left = 20,
				right = 20
			},
			LocalUserId = v10.LocalUserId,
			FriendStatuses = llama.Dictionary.map(v11.Users.byUserId, function() -- line: 84
				return Enum.FriendStatus.FriendRequestReceived
			end),
			[RODUX_KEY] = llama.Dictionary.join({
				Friends = {
					requests = {
						order = {
							requestsById = t1
						},
						byUserId = t2,
						receivedCount = n2,
						nextPageCursor = s1,
						sourceUniverseIds = t6,
						mutualFriends = t7
					},
					recommendations = t8
				},
				Users = v11.Users,
				Presence = v11.Presence,
				NetworkStatus = v11.NetworkStatus,
				UserFollowers = t3,
				IsUserFollowing = t4,
				Games = {
					byGameId = t5
				}
			}, p2 or {})
		}
	end, {}, { Rodux.thunkMiddleware })
end
