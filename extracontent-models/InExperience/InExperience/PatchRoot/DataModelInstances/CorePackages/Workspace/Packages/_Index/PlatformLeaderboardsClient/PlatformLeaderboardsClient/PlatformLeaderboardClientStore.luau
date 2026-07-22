local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local IXPService = game:GetService("IXPService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local v6 = game:DefineFastInt("PlatformLeaderboardPushWaitTimeoutSeconds", 30)
local v7 = game:DefineFastFlag("PlatformLeaderboardsExposure2Enabled", false)
local v8 = game:DefineFastString("PlatformLeaderboardsExposure2Layer", "Social.PlatformLeaderboardsExposure2")
local v9 = game:DefineFastFlag("PlatformLeaderboardLocalizedUnitEnabled", false)
local ParentParent = script.Parent.Parent
local Signals = require(ParentParent.Signals)
local Url = require(ParentParent.CoreScriptsCommon).Url
local createSignalMap = require(ParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap
local t1 = {}

t1.__index = t1

function t1.new() -- line: 106
	-- upvalues: Signals (copy), createSignalMap (copy), t1 (copy), RobloxReplicatedStorage (copy), v6 (copy)
	local v15, v16 = Signals.createSignal(false)
	local v17, v18 = Signals.createSignal(nil)
	local v19, v20 = Signals.createSignal(nil)
	local v21, v22 = Signals.createSignal(nil)
	local v23, v24 = Signals.createSignal(nil)
	local v25, v26 = Signals.createSignal(nil)
	local v27, v28 = Signals.createSignal(nil)
	local v29, v30 = Signals.createSignal(nil)
	local v31 = setmetatable({
		_conn = nil,
		getHasActiveLeaderboard = v15,
		globalEntries = createSignalMap(),
		friendsEntries = createSignalMap(),
		getGlobalLastRefreshedAt = v17,
		getFriendsLastRefreshedAt = v19,
		getUserScore = v21,
		getUserRank = v23,
		getUnit = v25,
		getUserFriendRank = v27,
		getUserFriendScore = v29,
		_setHasActiveLeaderboard = v16,
		_setGlobalLastRefreshedAt = v18,
		_setFriendsLastRefreshedAt = v20,
		_setUserScore = v22,
		_setUserRank = v24,
		_setUnit = v26,
		_setUserFriendRank = v28,
		_setUserFriendScore = v30,
		_globalEntrySetters = {},
		_friendsEntrySetters = {}
	}, t1)

	task.spawn(function() -- line: 140
		-- upvalues: RobloxReplicatedStorage (copy), v6 (copy), v31 (copy)
		local PlatformLeaderboardPush = RobloxReplicatedStorage:WaitForChild("PlatformLeaderboardPush", v6)

		if not PlatformLeaderboardPush then
			return
		end

		v31._conn = PlatformLeaderboardPush.OnClientEvent:Connect(function(t2: {[any]: any}) -- line: 148
			-- upvalues: v31 (copy)
			v31:_handleEvent(t2)
		end)
	end)

	return v31
end
function t1._updateEntries(_: {[any]: any}, p1, t4: {[any]: any}, t5: {[any]: any}) -- line: 156
	-- upvalues: Signals (copy)
	local t6 = {}

	for _, v in ipairs(t5) do
		local userId = v.userId

		t6[userId] = true

		local v40 = t4[userId]

		if v40 then
			v40.setScore(v.score)
			v40.setRank(v.rank)

			local v41 = p1.getData(userId, false)

			if v41 and v41.displayName ~= v.displayName then
				p1.setData(userId, {
					getScore = v41.getScore,
					getRank = v41.getRank,
					displayName = v.displayName
				}, false)
			end
		else
			local v42, v43 = Signals.createSignal(v.score)
			local v44, v45 = Signals.createSignal(v.rank)

			t4[userId] = {
				setScore = v43,
				setRank = v45
			}
			p1.setData(userId, {
				getScore = v42,
				getRank = v44,
				displayName = v.displayName
			}, false)
		end
	end

	local v46 = p1.getAllData(false)

	for k, _ in pairs(v46) do
		if not t6[k] then
			p1.removeData(k, false)
			t4[k] = nil
		end
	end
end
function t1._handleEvent(t7: {[any]: any}, t8: {[any]: any}) -- line: 205
	-- upvalues: v7 (copy), IXPService (copy), v8 (copy), v9 (copy)
	if t8.type == "CONFIG_UPDATE" then
		t7._setHasActiveLeaderboard(t8.config ~= nil)
		t7._setUnit(if not t8.config then nil else t8.config.unit)

		if v7 and t8.config ~= nil then
			IXPService:LogFlagLinkedUserLayerExposure(v8)
		end

		if v9 and t8.config then
			t7:_fetchLocalizedUnit()

			return
		end
	elseif t8.type == "GLOBAL_LEADERBOARD_DATA" then
		if t8.data then
			t7:_updateEntries(t7.globalEntries, t7._globalEntrySetters, t8.data.entries)
			t7._setGlobalLastRefreshedAt(t8.data.lastRefreshedAt)

			return
		end
	elseif t8.type == "FRIENDS_LEADERBOARD_DATA" then
		if t8.data then
			t7:_updateEntries(t7.friendsEntries, t7._friendsEntrySetters, t8.data.entries)
			t7._setFriendsLastRefreshedAt(t8.data.lastRefreshedAt)

			if v9 then
				t7:_updateUserFriendRankAndScore(t8.data.entries)

				return
			end
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
function t1._updateUserFriendRankAndScore(t9: {[any]: any}, t10: {[any]: any}) -- line: 239
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return
	end

	local UserId = LocalPlayer.UserId

	for _, v in ipairs(t10) do
		if UserId == v.userId then
			t9._setUserFriendRank(v.rank)
			t9._setUserFriendScore(v.score)

			return
		end
	end

	t9._setUserFriendRank(nil)
	t9._setUserFriendScore(nil)
end
function t1._fetchLocalizedUnit(p2) -- line: 256
	-- upvalues: Url (copy), HttpRbxApiService (copy), HttpService (copy)
	task.spawn(function() -- line: 257
		-- upvalues: Url (copy), HttpRbxApiService (copy), HttpService (copy), p2 (copy)
		local GameId = game.GameId
		local v67 = `{ Url.APIS_URL }platform-leaderboards-api/v1/universes/{ GameId }/leaderboard/localized`
		local ok, result = pcall(function() -- line: 261
			-- upvalues: HttpRbxApiService (copy), v67 (copy)
			return HttpRbxApiService:GetAsyncFullUrl(v67)
		end)

		if not ok then
			warn("[PlatformLeaderboard] Failed to fetch localized unit:", (tostring(result)))

			return
		end

		local ok2, result2 = pcall(function() -- line: 269
			-- upvalues: HttpService (copy), result (copy)
			return HttpService:JSONDecode(result)
		end)

		if not ok2 or typeof(result2) ~= "table" then
			warn("[PlatformLeaderboard] Failed to decode localized unit response")

			return
		end

		local localizedUnit = result2.localizedUnit

		if typeof(localizedUnit) == "string" then
			p2._setUnit(localizedUnit)
		end
	end)
end
function t1.fireTabOpened(_: {[any]: any}, s1: string) -- line: 284
	-- upvalues: RobloxReplicatedStorage (copy)
	local PlatformLeaderboardTabOpened = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabOpened")

	if PlatformLeaderboardTabOpened then
		PlatformLeaderboardTabOpened:FireServer({
			tabType = s1
		})
	end
end
function t1.fireTabClosed(_: {[any]: any}, s2: string) -- line: 291
	-- upvalues: RobloxReplicatedStorage (copy)
	local PlatformLeaderboardTabClosed = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabClosed")

	if PlatformLeaderboardTabClosed then
		PlatformLeaderboardTabClosed:FireServer({
			tabType = s2
		})
	end
end
function t1.destroy(p3) -- line: 298
	if p3._conn then
		p3._conn:Disconnect()
		p3._conn = nil
	end
end

return t1
