local Parent = script:FindFirstAncestor("AddFriends").Parent
local Rodux = require(Parent.Rodux)
local llama = require(Parent.llama)
local AddFriendsState = require(Parent.AddFriendsState)
local PresenceType = AddFriendsState.RoduxPresence.Enums.PresenceType
local getBaseTestStates = require(Parent.Dev.SocialTestHelpers).TestHelpers.getBaseTestStates
local RODUX_KEY = AddFriendsState.RODUX_KEY
local smallNumbersOfFriends = getBaseTestStates({
	roduxKey = RODUX_KEY
}).smallNumbersOfFriends
local manyFriends = getBaseTestStates({
	roduxKey = RODUX_KEY
}).manyFriends
local t1 = {
	[Enum.FriendStatus.Friend] = "Friend",
	[Enum.FriendStatus.FriendRequestReceived] = "RequestReceived"
}
local v11 = llama.Dictionary.keys(t1)

local function v12(p1) -- line: 49
	-- upvalues: RODUX_KEY (copy), llama (copy), v11 (copy), t1 (copy), PresenceType (copy)
	local test = p1[RODUX_KEY].Friends.byUserId.test
	local t2 = {}

	llama.List.every(test, function(p2, p3) -- line: 53
		-- upvalues: v11 (copy), t2 (copy), t1 (copy), PresenceType (copy)
		local v22 = v11[1 + p3 % #v11]

		t2[p3] = {
			lastLocation = "Last Location",
			username = "",
			id = p2,
			displayName = t1[v22],
			userPresenceType = PresenceType.InGame
		}

		return true
	end)

	return t2
end

local v13 = v12(manyFriends)
local v14 = v12(smallNumbersOfFriends)

return {
	friendRequests = v13,
	manyFriendRequests = v13,
	smallNumbersOfFriendRequests = v14,
	createStore = function(p4) -- line: 28
		-- upvalues: Rodux (copy), llama (copy), v11 (copy), RODUX_KEY (copy)
		return Rodux.Store.new(function() -- line: 29
			-- upvalues: llama (copy), p4 (copy), v11 (copy), RODUX_KEY (copy)
			return {
				LocalUserId = "0",
				FriendStatuses = llama.Dictionary.map(p4, function(p5, p6) -- line: 32
					-- upvalues: v11 (copy)
					return v11[1 + p6 % #v11], p5.id
				end),
				ScreenSize = Vector2.new(360, 720),
				TopBar = {
					topBarHeight = 60
				},
				GlobalGuiInset = {
					top = 20,
					bottom = 20,
					left = 20,
					right = 20
				},
				[RODUX_KEY] = {
					Friends = {
						requests = {
							receivedCount = #p4
						}
					}
				}
			}
		end, { Rodux.thunkMiddleware })
	end
}
