local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local v2 = game:DefineFastInt("PlatformLeaderboardPushWaitTimeoutSeconds", 30)
local ParentParent = script.Parent.Parent
local Signals = require(ParentParent.Signals)
local createSignalMap = require(ParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap
local t1 = {}

t1.__index = t1

function t1.new() -- line: 88
	-- upvalues: Signals (copy), createSignalMap (copy), t1 (copy), RobloxReplicatedStorage (copy), v2 (copy)
	local v7, v8 = Signals.createSignal(false)
	local v9, v10 = Signals.createSignal(nil)
	local v11, v12 = Signals.createSignal(nil)
	local v13, v14 = Signals.createSignal(nil)
	local v15, v16 = Signals.createSignal(nil)
	local v17 = setmetatable({
		_conn = nil,
		getHasActiveLeaderboard = v7,
		globalEntries = createSignalMap(),
		friendsEntries = createSignalMap(),
		getGlobalLastRefreshedAt = v9,
		getFriendsLastRefreshedAt = v11,
		getUserScore = v13,
		getUserRank = v15,
		_setHasActiveLeaderboard = v8,
		_setGlobalLastRefreshedAt = v10,
		_setFriendsLastRefreshedAt = v12,
		_setUserScore = v14,
		_setUserRank = v16,
		_globalEntrySetters = {},
		_friendsEntrySetters = {}
	}, t1)

	task.spawn(function() -- line: 113
		-- upvalues: RobloxReplicatedStorage (copy), v2 (copy), v17 (copy)
		local PlatformLeaderboardPush = RobloxReplicatedStorage:WaitForChild("PlatformLeaderboardPush", v2)

		if not PlatformLeaderboardPush then
			return
		end

		v17._conn = PlatformLeaderboardPush.OnClientEvent:Connect(function(t2: {[any]: any}) -- line: 121
			-- upvalues: v17 (copy)
			v17:_handleEvent(t2)
		end)
	end)

	return v17
end
function t1._updateEntries(_: {[any]: any}, p1, t4: {[any]: any}, t5: {[any]: any}) -- line: 129
	-- upvalues: Signals (copy)
	local t6 = {}

	for _, v in ipairs(t5) do
		local userId = v.userId

		t6[userId] = true

		local v26 = t4[userId]

		if v26 then
			v26.setScore(v.score)
			v26.setRank(v.rank)
		else
			local v27, v28 = Signals.createSignal(v.score)
			local v29, v30 = Signals.createSignal(v.rank)

			t4[userId] = {
				setScore = v28,
				setRank = v30
			}
			p1.setData(userId, {
				getScore = v27,
				getRank = v29
			}, false)
		end
	end

	local v31 = p1.getAllData(false)

	for k, _ in pairs(v31) do
		if not t6[k] then
			p1.removeData(k, false)
			t4[k] = nil
		end
	end
end
function t1._handleEvent(t7: {[any]: any}, t8: {[any]: any}) -- line: 169
	if t8.type == "CONFIG_UPDATE" then
		t7._setHasActiveLeaderboard(t8.config ~= nil)

		return
	end

	if t8.type == "GLOBAL_LEADERBOARD_DATA" then
		if t8.data then
			t7:_updateEntries(t7.globalEntries, t7._globalEntrySetters, t8.data.entries)
			t7._setGlobalLastRefreshedAt(t8.data.lastRefreshedAt)

			return
		end
	elseif t8.type == "FRIENDS_LEADERBOARD_DATA" then
		if t8.data then
			t7:_updateEntries(t7.friendsEntries, t7._friendsEntrySetters, t8.data.entries)
			t7._setFriendsLastRefreshedAt(t8.data.lastRefreshedAt)

			return
		end
	elseif t8.type == "USER_SCORE" then
		if t8.entry then
			t7._setUserScore(t8.entry.score)
			t7._setUserRank(t8.entry.rank)

			return
		end

		t7._setUserScore(nil)
		t7._setUserRank(nil)
	end
end
function t1.fireTabOpened(_: {[any]: any}, s1: string) -- line: 193
	-- upvalues: RobloxReplicatedStorage (copy)
	local PlatformLeaderboardTabOpened = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabOpened")

	if PlatformLeaderboardTabOpened then
		PlatformLeaderboardTabOpened:FireServer({
			tabType = s1
		})
	end
end
function t1.fireTabClosed(_: {[any]: any}, s2: string) -- line: 200
	-- upvalues: RobloxReplicatedStorage (copy)
	local PlatformLeaderboardTabClosed = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabClosed")

	if PlatformLeaderboardTabClosed then
		PlatformLeaderboardTabClosed:FireServer({
			tabType = s2
		})
	end
end
function t1.destroy(p2) -- line: 207
	if p2._conn then
		p2._conn:Disconnect()
		p2._conn = nil
	end
end

return t1
