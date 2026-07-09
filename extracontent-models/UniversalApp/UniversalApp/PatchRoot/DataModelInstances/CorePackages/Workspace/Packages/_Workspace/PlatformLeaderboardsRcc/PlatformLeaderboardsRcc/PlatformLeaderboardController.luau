local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local scriptParent = script.Parent
local PlatformLeaderboardTypes = require(scriptParent.PlatformLeaderboardTypes)
local PlatformLeaderboardCache = require(scriptParent.PlatformLeaderboardCache)

require(scriptParent.PlatformLeaderboardConfigService)

local EventType = PlatformLeaderboardTypes.EventType
local LeaderboardType = PlatformLeaderboardTypes.LeaderboardType
local RemoteEventName = PlatformLeaderboardTypes.RemoteEventName
local v9 = game:DefineFastInt("PlatformLeaderboardTabEventRateLimit", 20)
local v10 = game:DefineFastInt("PlatformLeaderboardTabEventRateWindowSeconds", 10)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 48
	-- upvalues: t1 (copy)
	return (setmetatable({
		_cache = nil,
		_pushEvent = nil,
		_configService = p1,
		_fetcher = p2,
		_conns = {},
		_playerTabs = {},
		_rateLimits = {}
	}, t1))
end
function t1._onConfigChanged(p3, p4, p5) -- line: 63
	-- upvalues: EventType (copy)
	p3:_pushToAll({
		type = EventType.ConfigUpdate,
		config = p5
	})

	if not p5 then
		if p3._cache then
			p3._cache:teardown()
			p3._cache = nil
		end

		table.clear(p3._playerTabs)

		return
	end

	if not p3._cache then
		p3:_initializeCache(p5)

		return
	end

	if p4 then
		local v17 = p4.leaderboardId == p5.leaderboardId

		p3._cache:forceRefresh(p5, not v17)
	end
end
function t1._initializeCache(p6, p7) -- line: 83
	-- upvalues: PlatformLeaderboardCache (copy), EventType (copy), Players (copy)
	p6._cache = PlatformLeaderboardCache.new(p6._fetcher, p7)

	local _cache = p6._cache

	table.insert(p6._conns, _cache:onGlobalUpdated(function(p8, p9) -- line: 89
		-- upvalues: p6 (copy), EventType (copy)
		p6:_pushToGlobalViewers({
			type = EventType.GlobalLeaderboardData,
			data = p8
		})

		if p9 then
			p6._configService:updateConfig(p9)
		end
	end))
	table.insert(p6._conns, _cache:onFriendsUpdated(function(n1: number, p10, p11) -- line: 99
		-- upvalues: Players (copy), p6 (copy), EventType (copy)
		local PlayerByUserId = Players:GetPlayerByUserId(n1)

		if PlayerByUserId then
			p6:_pushToPlayer(PlayerByUserId, {
				type = EventType.FriendsLeaderboardData,
				userId = n1,
				data = p10
			})
		end

		if p11 then
			p6._configService:updateConfig(p11)
		end
	end))
	table.insert(p6._conns, _cache:onUserScoreUpdated(function(n2: number, p12) -- line: 115
		-- upvalues: Players (copy), p6 (copy), EventType (copy)
		local PlayerByUserId = Players:GetPlayerByUserId(n2)

		if PlayerByUserId then
			p6:_pushToPlayer(PlayerByUserId, {
				type = EventType.UserScore,
				userId = n2,
				entry = p12
			})
		end
	end))
end
function t1.initialize(p13) -- line: 124
	-- upvalues: RemoteEventName (copy), RobloxReplicatedStorage (copy), EventType (copy), Players (copy)
	p13._pushEvent = Instance.new("RemoteEvent")
	p13._pushEvent.Name = RemoteEventName.Push
	p13._pushEvent.Parent = RobloxReplicatedStorage

	local RemoteEvent = Instance.new("RemoteEvent")

	RemoteEvent.Name = RemoteEventName.TabOpened
	RemoteEvent.Parent = RobloxReplicatedStorage

	local RemoteEvent2 = Instance.new("RemoteEvent")

	RemoteEvent2.Name = RemoteEventName.TabClosed
	RemoteEvent2.Parent = RobloxReplicatedStorage
	p13._pushEvent.OnServerEvent:Connect(function() -- line: 140
	end)

	local v24 = p13._configService:getConfig()

	if v24 then
		p13:_initializeCache(v24)
	end

	table.insert(p13._conns, p13._configService:onConfigChanged(function(p14, p15) -- line: 152
		-- upvalues: p13 (copy)
		p13:_onConfigChanged(p14, p15)
	end))
	p13:_pushToAll({
		type = EventType.ConfigUpdate,
		config = p13._configService:getConfig()
	})
	table.insert(p13._conns, RemoteEvent.OnServerEvent:Connect(function(player, p16) -- line: 164
		-- upvalues: p13 (copy)
		if p13:_isRateLimited(player.UserId) then
			return
		end

		local v75 = p13:_validateTabPayload(player, p16)

		if v75 then
			p13:_onTabOpened(player, v75)
		end
	end))
	table.insert(p13._conns, RemoteEvent2.OnServerEvent:Connect(function(player, p17) -- line: 176
		-- upvalues: p13 (copy)
		if p13:_isRateLimited(player.UserId) then
			return
		end

		local v78 = p13:_validateTabPayload(player, p17)

		if v78 then
			p13:_onTabClosed(player, v78)
		end
	end))
	table.insert(p13._conns, Players.PlayerAdded:Connect(function(player) -- line: 189
		-- upvalues: p13 (copy), EventType (copy)
		task.defer(function() -- line: 190
			-- upvalues: p13 (copy), player (copy), EventType (copy)
			p13:_pushToPlayer(player, {
				type = EventType.ConfigUpdate,
				config = p13._configService:getConfig()
			})
		end)
	end))
	table.insert(p13._conns, Players.PlayerRemoving:Connect(function(player) -- line: 201
		-- upvalues: p13 (copy)
		p13:_removePlayerFromAllTabs(player.UserId)
	end))
end
function t1._isRateLimited(t2: {[any]: any}, n3: number) -- line: 212
	-- upvalues: v10 (copy), v9 (copy)
	local elapsed = os.clock()
	local v28 = t2._rateLimits[n3]

	if v28 == nil or elapsed - v28.windowStart >= v10 then
		t2._rateLimits[n3] = {
			count = 1,
			windowStart = elapsed
		}

		return false
	end

	if v28.count >= v9 then
		return true
	end

	v28.count = v28.count + 1

	return false
end
function t1._validateTabPayload(_: {[any]: any}, p18, p19) -- line: 229
	if typeof(p19) ~= "table" then
		return nil
	end

	local tabType = p19.tabType

	if typeof(tabType) ~= "string" then
		return nil
	end

	local userId = p19.userId

	if userId ~= nil and userId ~= p18.UserId then
		return nil
	end

	return {
		tabType = tabType
	}
end
function t1._removePlayerFromAllTabs(t4: {[any]: any}, n4: number) -- line: 244
	if t4._cache then
		t4._cache:cleanupForUserId(n4)
	end

	t4._playerTabs[n4] = nil
	t4._rateLimits[n4] = nil
end
function t1._onTabOpened(t5: {[any]: any}, p20, t6: {[any]: any}) -- line: 252
	-- upvalues: LeaderboardType (copy), EventType (copy)
	local _cache = t5._cache

	if not _cache then
		return
	end

	local v40 = t5._playerTabs[p20.UserId] or {}

	t5._playerTabs[p20.UserId] = v40

	if t6.tabType == LeaderboardType.Global then
		if not v40.global then
			v40.global = true
			_cache:startGlobalRefresh(p20.UserId)

			local v41 = _cache:getGlobalData()

			if v41 then
				t5:_pushToPlayer(p20, {
					type = EventType.GlobalLeaderboardData,
					data = v41
				})
			end

			local v42 = _cache:getUserScore(p20.UserId)

			if v42 then
				t5:_pushToPlayer(p20, {
					type = EventType.UserScore,
					userId = p20.UserId,
					entry = v42
				})

				return
			end
		end
	elseif t6.tabType == LeaderboardType.Friends then
		if not v40.friends then
			v40.friends = true
			_cache:startFriendsRefresh(p20.UserId)

			local v43 = _cache:getFriendsData(p20.UserId)

			if v43 then
				t5:_pushToPlayer(p20, {
					type = EventType.FriendsLeaderboardData,
					userId = p20.UserId,
					data = v43
				})

				return
			end
		end
	else
		warn("[PlatformLeaderboard] Unknown tabType:", t6.tabType)
	end
end
function t1._onTabClosed(t7: {[any]: any}, p21, t8: {[any]: any}) -- line: 291
	-- upvalues: LeaderboardType (copy)
	if not t7._cache then
		return
	end

	local _cache = t7._cache
	local v48 = t7._playerTabs[p21.UserId]

	if t8.tabType == LeaderboardType.Global and v48 and v48.global then
		v48.global = nil
		_cache:stopGlobalRefresh(p21.UserId)

		return
	end

	if t8.tabType == LeaderboardType.Friends and v48 and v48.friends then
		v48.friends = nil
		_cache:stopFriendsRefresh(p21.UserId)
	end
end
function t1._pushToAll(p22, p23) -- line: 307
	if p22._pushEvent then
		p22._pushEvent:FireAllClients(p23)
	end
end
function t1._pushToGlobalViewers(p24, p25) -- line: 313
	-- upvalues: Players (copy)
	if not p24._pushEvent then
		return
	end

	for _, player in Players:GetPlayers() do
		local v55 = p24._playerTabs[player.UserId]

		if v55 and v55.global then
			p24._pushEvent:FireClient(player, p25)
		end
	end
end
function t1._pushToPlayer(t9: {[any]: any}, p26, p27) -- line: 325
	if t9._pushEvent then
		t9._pushEvent:FireClient(p26, p27)
	end
end
function t1.destroy(p28) -- line: 331
	for _, v61 in p28._conns do
		if typeof(v61) == "table" and v61.disconnect then
			v61:disconnect()
		elseif typeof(v61) == "RBXScriptConnection" then
			v61:Disconnect()
		end
	end

	table.clear(p28._conns)
	p28._configService:teardown()

	if p28._cache then
		p28._cache:destroy()
	end

	if p28._pushEvent then
		p28._pushEvent:Destroy()
	end
end

return t1
