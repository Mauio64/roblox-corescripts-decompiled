local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local IXPService = game:GetService("IXPService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local v7 = game:DefineFastInt("PlatformLeaderboardPushWaitTimeoutSeconds", 30)
local v8 = game:DefineFastFlag("PlatformLeaderboardsExposure2Enabled_V2", false)
local v9 = game:DefineFastString("PlatformLeaderboardsExposure2Layer", "Social.PlatformLeaderboardsExposure2")
local v10 = game:DefineFastFlag("PlatformLeaderboardLocalizedUnitEnabled", false)
local v11 = game:DefineFastFlag("PlatformLeaderboardsIXPNoLeaderboardsShown_V3", false)
local ParentParent = script.Parent.Parent
local Signals = require(ParentParent.Signals)
local Url = require(ParentParent.CoreScriptsCommon).Url
local createSignalMap = require(ParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap

local function getPlayerPermissionsModule() -- line: 79
	-- upvalues: CoreGui (copy)
	local ok, result = pcall(function() -- line: 80
		-- upvalues: CoreGui (copy)
		local RobloxGui = CoreGui:WaitForChild("RobloxGui")

		return require(RobloxGui.Modules.PlayerPermissionsModule)
	end)

	if ok then
		return result
	end

	return nil
end
local function resolveIsLocalPlayerCreator() -- line: 87
	-- upvalues: Players (copy), CoreGui (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return false
	end

	local ok, result = pcall(function() -- line: 80
		-- upvalues: CoreGui (copy)
		local RobloxGui = CoreGui:WaitForChild("RobloxGui")

		return require(RobloxGui.Modules.PlayerPermissionsModule)
	end)
	local v24 = if not ok then nil else result

	if not v24 then
		return false
	end

	local ok2, result2 = pcall(function() -- line: 96
		-- upvalues: v24 (copy), LocalPlayer (copy)
		return v24.CanPlayerManagePlaceAsync(LocalPlayer)
	end)

	return ok2 and result2 == true
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 132
	-- upvalues: Signals (copy), createSignalMap (copy), t1 (copy), RobloxReplicatedStorage (copy), v7 (copy)
	local v27, v28 = Signals.createSignal(false)
	local v29, v30 = Signals.createSignal(nil)
	local v31, v32 = Signals.createSignal(nil)
	local v33, v34 = Signals.createSignal(nil)
	local v35, v36 = Signals.createSignal(nil)
	local v37, v38 = Signals.createSignal(nil)
	local v39, v40 = Signals.createSignal(nil)
	local v41, v42 = Signals.createSignal(nil)
	local v43 = setmetatable({
		_conn = nil,
		getHasActiveLeaderboard = v27,
		globalEntries = createSignalMap(),
		friendsEntries = createSignalMap(),
		getGlobalLastRefreshedAt = v29,
		getFriendsLastRefreshedAt = v31,
		getUserScore = v33,
		getUserRank = v35,
		getUnit = v37,
		getUserFriendRank = v39,
		getUserFriendScore = v41,
		_setHasActiveLeaderboard = v28,
		_setGlobalLastRefreshedAt = v30,
		_setFriendsLastRefreshedAt = v32,
		_setUserScore = v34,
		_setUserRank = v36,
		_setUnit = v38,
		_setUserFriendRank = v40,
		_setUserFriendScore = v42,
		_globalEntrySetters = {},
		_friendsEntrySetters = {}
	}, t1)

	task.spawn(function() -- line: 166
		-- upvalues: RobloxReplicatedStorage (copy), v7 (copy), v43 (copy)
		local PlatformLeaderboardPush = RobloxReplicatedStorage:WaitForChild("PlatformLeaderboardPush", v7)

		if not PlatformLeaderboardPush then
			return
		end

		v43._conn = PlatformLeaderboardPush.OnClientEvent:Connect(function(t2: {[any]: any}) -- line: 174
			-- upvalues: v43 (copy)
			v43:_handleEvent(t2)
		end)
	end)

	return v43
end
function t1._updateEntries(_: {[any]: any}, p1, t4: {[any]: any}, t5: {[any]: any}) -- line: 182
	-- upvalues: Signals (copy)
	local t6 = {}

	for _, v in ipairs(t5) do
		local userId = v.userId

		t6[userId] = true

		local v52 = t4[userId]

		if v52 then
			v52.setScore(v.score)
			v52.setRank(v.rank)

			local v53 = p1.getData(userId, false)

			if v53 and v53.displayName ~= v.displayName then
				p1.setData(userId, {
					getScore = v53.getScore,
					getRank = v53.getRank,
					displayName = v.displayName
				}, false)
			end
		else
			local v54, v55 = Signals.createSignal(v.score)
			local v56, v57 = Signals.createSignal(v.rank)

			t4[userId] = {
				setScore = v55,
				setRank = v57
			}
			p1.setData(userId, {
				getScore = v54,
				getRank = v56,
				displayName = v.displayName
			}, false)
		end
	end

	local v58 = p1.getAllData(false)

	for k, _ in pairs(v58) do
		if not t6[k] then
			p1.removeData(k, false)
			t4[k] = nil
		end
	end
end
function t1._handleEvent(t7: {[any]: any}, t8: {[any]: any}) -- line: 231
	-- upvalues: v8 (copy), IXPService (copy), v9 (copy), v11 (copy), Players (copy), CoreGui (copy), v10 (copy)
	if v8 and t8.config ~= nil then
		IXPService:LogFlagLinkedUserLayerExposure(v9)
	end

	if v11 then
		local LocalPlayer = Players.LocalPlayer
		local v64

		if not LocalPlayer then
			v64 = false
		else
			local ok, result = pcall(function() -- line: 80
				-- upvalues: CoreGui (copy)
				local RobloxGui = CoreGui:WaitForChild("RobloxGui")

				return require(RobloxGui.Modules.PlayerPermissionsModule)
			end)
			local v67 = if not ok then nil else result

			if not v67 then
				v64 = false
			else
				local ok3, result3 = pcall(function() -- line: 96
					-- upvalues: v67 (copy), LocalPlayer (copy)
					return v67.CanPlayerManagePlaceAsync(LocalPlayer)
				end)

				v64 = ok3 and result3 == true
			end
		end

		if not v64 then
			return
		end
	end

	if t8.type == "CONFIG_UPDATE" then
		t7._setHasActiveLeaderboard(t8.config ~= nil)
		t7._setUnit(if not t8.config then nil else t8.config.unit)

		if v10 and t8.config then
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

			if v10 then
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
function t1._updateUserFriendRankAndScore(t9: {[any]: any}, t10: {[any]: any}) -- line: 269
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
function t1._fetchLocalizedUnit(p2) -- line: 286
	-- upvalues: Url (copy), HttpRbxApiService (copy), HttpService (copy)
	task.spawn(function() -- line: 287
		-- upvalues: Url (copy), HttpRbxApiService (copy), HttpService (copy), p2 (copy)
		local GameId = game.GameId
		local v89 = `{ Url.APIS_URL }platform-leaderboards-api/v1/universes/{ GameId }/leaderboard/localized`
		local ok, result = pcall(function() -- line: 291
			-- upvalues: HttpRbxApiService (copy), v89 (copy)
			return HttpRbxApiService:GetAsyncFullUrl(v89)
		end)

		if not ok then
			warn("[PlatformLeaderboard] Failed to fetch localized unit:", (tostring(result)))

			return
		end

		local ok4, result4 = pcall(function() -- line: 299
			-- upvalues: HttpService (copy), result (copy)
			return HttpService:JSONDecode(result)
		end)

		if not ok4 or typeof(result4) ~= "table" then
			warn("[PlatformLeaderboard] Failed to decode localized unit response")

			return
		end

		local localizedUnit = result4.localizedUnit

		if typeof(localizedUnit) == "string" then
			p2._setUnit(localizedUnit)
		end
	end)
end
function t1.fireTabOpened(_: {[any]: any}, s1: string) -- line: 314
	-- upvalues: RobloxReplicatedStorage (copy)
	local PlatformLeaderboardTabOpened = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabOpened")

	if PlatformLeaderboardTabOpened then
		PlatformLeaderboardTabOpened:FireServer({
			tabType = s1
		})
	end
end
function t1.fireTabClosed(_: {[any]: any}, s2: string) -- line: 321
	-- upvalues: RobloxReplicatedStorage (copy)
	local PlatformLeaderboardTabClosed = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabClosed")

	if PlatformLeaderboardTabClosed then
		PlatformLeaderboardTabClosed:FireServer({
			tabType = s2
		})
	end
end
function t1.destroy(p3) -- line: 328
	if p3._conn then
		p3._conn:Disconnect()
		p3._conn = nil
	end
end

return t1
