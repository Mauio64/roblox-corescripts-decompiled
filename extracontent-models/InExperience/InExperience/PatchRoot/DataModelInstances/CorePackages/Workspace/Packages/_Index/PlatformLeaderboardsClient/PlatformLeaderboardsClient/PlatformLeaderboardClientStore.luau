local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local v2 = game:DefineFastInt("PlatformLeaderboardPushWaitTimeoutSeconds", 30)
local ParentParent = script.Parent.Parent
local Signals = require(ParentParent.Signals)
local createSignalMap = require(ParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap
local t1 = {}

t1.__index = t1

function t1.new() -- line: 91
	-- upvalues: Signals (copy), createSignalMap (copy), t1 (copy), RobloxReplicatedStorage (copy), v2 (copy)
	local v7, v8 = Signals.createSignal(false)
	local v9, v10 = Signals.createSignal(nil)
	local v11, v12 = Signals.createSignal(nil)
	local v13, v14 = Signals.createSignal(nil)
	local v15, v16 = Signals.createSignal(nil)
	local v17, v18 = Signals.createSignal(nil)
	local v19 = setmetatable({
		_conn = nil,
		getHasActiveLeaderboard = v7,
		globalEntries = createSignalMap(),
		friendsEntries = createSignalMap(),
		getGlobalLastRefreshedAt = v9,
		getFriendsLastRefreshedAt = v11,
		getUserScore = v13,
		getUserRank = v15,
		getUnit = v17,
		_setHasActiveLeaderboard = v8,
		_setGlobalLastRefreshedAt = v10,
		_setFriendsLastRefreshedAt = v12,
		_setUserScore = v14,
		_setUserRank = v16,
		_setUnit = v18,
		_globalEntrySetters = {},
		_friendsEntrySetters = {}
	}, t1)

	task.spawn(function() -- line: 119
		-- upvalues: RobloxReplicatedStorage (copy), v2 (copy), v19 (copy)
		local PlatformLeaderboardPush = RobloxReplicatedStorage:WaitForChild("PlatformLeaderboardPush", v2)

		if not PlatformLeaderboardPush then
			return
		end

		v19._conn = PlatformLeaderboardPush.OnClientEvent:Connect(function(t2: {[any]: any}) -- line: 127
			-- upvalues: v19 (copy)
			v19:_handleEvent(t2)
		end)
	end)

	return v19
end
function t1._updateEntries(_: {[any]: any}, p1, t4: {[any]: any}, t5: {[any]: any}) -- line: 135
	-- upvalues: Signals (copy)
	local t6 = {}

	for _, v in ipairs(t5) do
		local userId = v.userId

		t6[userId] = true

		local v28 = t4[userId]

		if v28 then
			v28.setScore(v.score)
			v28.setRank(v.rank)

			local v29 = p1.getData(userId, false)

			if v29 and v29.displayName ~= v.displayName then
				p1.setData(userId, {
					getScore = v29.getScore,
					getRank = v29.getRank,
					displayName = v.displayName
				}, false)
			end
		else
			local v30, v31 = Signals.createSignal(v.score)
			local v32, v33 = Signals.createSignal(v.rank)

			t4[userId] = {
				setScore = v31,
				setRank = v33
			}
			p1.setData(userId, {
				getScore = v30,
				getRank = v32,
				displayName = v.displayName
			}, false)
		end
	end

	local v34 = p1.getAllData(false)

	for k, _ in pairs(v34) do
		if not t6[k] then
			p1.removeData(k, false)
			t4[k] = nil
		end
	end
end
function t1._handleEvent(t7: {[any]: any}, t8: {[any]: any}) -- line: 184
	if t8.type == "CONFIG_UPDATE" then
		t7._setHasActiveLeaderboard(t8.config ~= nil)
		t7._setUnit(if not t8.config then nil else t8.config.unit)

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
function t1.fireTabOpened(_: {[any]: any}, s1: string) -- line: 209
	-- upvalues: RobloxReplicatedStorage (copy)
	local PlatformLeaderboardTabOpened = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabOpened")

	if PlatformLeaderboardTabOpened then
		PlatformLeaderboardTabOpened:FireServer({
			tabType = s1
		})
	end
end
function t1.fireTabClosed(_: {[any]: any}, s2: string) -- line: 216
	-- upvalues: RobloxReplicatedStorage (copy)
	local PlatformLeaderboardTabClosed = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabClosed")

	if PlatformLeaderboardTabClosed then
		PlatformLeaderboardTabClosed:FireServer({
			tabType = s2
		})
	end
end
function t1.destroy(p2) -- line: 223
	if p2._conn then
		p2._conn:Disconnect()
		p2._conn = nil
	end
end

return t1
