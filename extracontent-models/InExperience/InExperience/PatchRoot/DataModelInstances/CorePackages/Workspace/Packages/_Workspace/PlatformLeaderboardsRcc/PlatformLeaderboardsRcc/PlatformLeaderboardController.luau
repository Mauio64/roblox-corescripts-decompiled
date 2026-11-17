local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local parent = script.Parent
local parent2 = parent.Parent

local PlatformLeaderboardTypes = require(parent.PlatformLeaderboardTypes)
local PlatformLeaderboardCache = require(parent.PlatformLeaderboardCache)
require(parent.PlatformLeaderboardConfigService)
local SharedFlags = require(parent2.SharedFlags)

local EventType = PlatformLeaderboardTypes.EventType
local LeaderboardType = PlatformLeaderboardTypes.LeaderboardType
local RemoteEventName = PlatformLeaderboardTypes.RemoteEventName

local defineFastInt = game:DefineFastInt("PlatformLeaderboardTabEventRateLimit", 20)

local defineFastInt2 = game:DefineFastInt("PlatformLeaderboardTabEventRateWindowSeconds", 10)
local FFlagPlatformLeaderboardDebugLogging = SharedFlags.FFlagPlatformLeaderboardDebugLogging

local PlatformLeaderboardController = {}
PlatformLeaderboardController.__index = PlatformLeaderboardController

function PlatformLeaderboardController.new(configService, fetcher)
	return (setmetatable({
		_configService = configService,
		_fetcher = fetcher,
		_cache = nil,
		_pushEvent = nil,
		_conns = {},
		_playerTabs = {},
		_rateLimits = {}
	}, PlatformLeaderboardController))
end

function PlatformLeaderboardController:_onConfigChanged(p, config)
	self:_pushToAll({ type = EventType.ConfigUpdate, config = config })

	if config then
		if not self._cache then
			self:_initializeCache(config)
		elseif p then
			local v = p.leaderboardId == config.leaderboardId
			self._cache:forceRefresh(config, not v)
		end
	else
		if self._cache then
			self._cache:teardown()
			self._cache = nil
		end

		table.clear(self._playerTabs)
	end
end

function PlatformLeaderboardController:_initializeCache(p)
	self._cache = PlatformLeaderboardCache.new(self._fetcher, p)
	local cache = self._cache

	table.insert(self._conns, cache:onGlobalUpdated(function(p2, p3)
		self:_pushToGlobalViewers({ type = EventType.GlobalLeaderboardData, data = p2 })

		if p3 then
			self._configService:updateConfig(p3)
		end
	end))

	table.insert(self._conns, cache:onFriendsUpdated(function(userId: number, p2, p3)
		local playerByUserId = Players:GetPlayerByUserId(userId)

		if playerByUserId then
			self:_pushToPlayer(playerByUserId, {
				type = EventType.FriendsLeaderboardData,
				userId = userId,
				data = p2
			})
		end

		if p3 then
			self._configService:updateConfig(p3)
		end
	end))

	table.insert(self._conns, cache:onUserScoreUpdated(function(userId: number, entry)
		local playerByUserId = Players:GetPlayerByUserId(userId)

		if playerByUserId then
			self:_pushToPlayer(playerByUserId, {
				type = EventType.UserScore,
				userId = userId,
				entry = entry
			})
		end
	end))
end

function PlatformLeaderboardController:initialize()
	self._pushEvent = Instance.new("RemoteEvent")
	self._pushEvent.Name = RemoteEventName.Push
	self._pushEvent.Parent = RobloxReplicatedStorage

	local remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Name = RemoteEventName.TabOpened
	remoteEvent.Parent = RobloxReplicatedStorage

	local remoteEvent2 = Instance.new("RemoteEvent")
	remoteEvent2.Name = RemoteEventName.TabClosed
	remoteEvent2.Parent = RobloxReplicatedStorage

	self._pushEvent.OnServerEvent:Connect(function() end)

	local config = self._configService:getConfig()

	if config then
		self:_initializeCache(config)
	end

	table.insert(self._conns, self._configService:onConfigChanged(function(p, p2)
		self:_onConfigChanged(p, p2)
	end))

	self:_pushToAll({
		type = EventType.ConfigUpdate,
		config = self._configService:getConfig()
	})

	table.insert(self._conns, remoteEvent.OnServerEvent:Connect(function(p, p2)
		if self:_isRateLimited(p.UserId) then
			return
		end

		local v = self:_validateTabPayload(p, p2)

		if v then
			self:_onTabOpened(p, v)
		end
	end))

	table.insert(self._conns, remoteEvent2.OnServerEvent:Connect(function(p, p2)
		if self:_isRateLimited(p.UserId) then
			return
		end

		local v = self:_validateTabPayload(p, p2)

		if v then
			self:_onTabClosed(p, v)
		end
	end))

	table.insert(self._conns, Players.PlayerAdded:Connect(function(player)
		task.defer(function()
			self:_pushToPlayer(player, {
				type = EventType.ConfigUpdate,
				config = self._configService:getConfig()
			})
		end)
	end))

	table.insert(self._conns, Players.PlayerRemoving:Connect(function(player)
		self:_removePlayerFromAllTabs(player.UserId)
	end))
end

function PlatformLeaderboardController:_isRateLimited(p: number): boolean
	local now = os.clock()
	local rateLimit = self._rateLimits[p]

	if rateLimit ~= nil and not (defineFastInt2 <= now - rateLimit.windowStart) then
		if defineFastInt <= rateLimit.count then
			return true
		end

		rateLimit.count += 1
		return false
	end

	self._rateLimits[p] = { windowStart = now, count = 1 }
	return false
end

function PlatformLeaderboardController:_validateTabPayload(p, p2)
	if typeof(p2) ~= "table" then
		return nil
	end

	local tabType = p2.tabType

	if typeof(tabType) ~= "string" then
		return nil
	end

	local userId = p2.userId

	if userId == nil or userId == p.UserId then
		return { tabType = tabType }
	end

	return nil
end

function PlatformLeaderboardController:_removePlayerFromAllTabs(p: number)
	if self._cache then
		self._cache:cleanupForUserId(p)
	end

	self._playerTabs[p] = nil
	self._rateLimits[p] = nil
end

function PlatformLeaderboardController:_onTabOpened(p, p2)
	local cache = self._cache

	if not cache then
		return
	end

	local v = self._playerTabs[p.UserId] or {}
	self._playerTabs[p.UserId] = v

	if p2.tabType == LeaderboardType.Global then
		if not v.global then
			v.global = true
			cache:startGlobalRefresh(p.UserId)
			local globalData = cache:getGlobalData()

			if globalData then
				self:_pushToPlayer(p, { type = EventType.GlobalLeaderboardData, data = globalData })
			end

			local userScore = cache:getUserScore(p.UserId)

			if userScore then
				self:_pushToPlayer(p, {
					type = EventType.UserScore,
					userId = p.UserId,
					entry = userScore
				})
			end
		end
	elseif p2.tabType == LeaderboardType.Friends then
		if not v.friends then
			v.friends = true
			cache:startFriendsRefresh(p.UserId)
			local friendsData = cache:getFriendsData(p.UserId)

			if friendsData then
				self:_pushToPlayer(p, {
					type = EventType.FriendsLeaderboardData,
					userId = p.UserId,
					data = friendsData
				})
			end
		end
	elseif FFlagPlatformLeaderboardDebugLogging then
		warn("[PlatformLeaderboard] Unknown tabType:", p2.tabType)
	end
end

function PlatformLeaderboardController:_onTabClosed(p, p2)
	if not self._cache then
		return
	end

	local cache = self._cache
	local playerTab = self._playerTabs[p.UserId]

	if p2.tabType == LeaderboardType.Global and playerTab and playerTab.global then
		playerTab.global = nil
		cache:stopGlobalRefresh(p.UserId)
	elseif p2.tabType == LeaderboardType.Friends and playerTab and playerTab.friends then
		playerTab.friends = nil
		cache:stopFriendsRefresh(p.UserId)
	end
end

function PlatformLeaderboardController:_pushToAll(p)
	if self._pushEvent then
		self._pushEvent:FireAllClients(p)
	end
end

function PlatformLeaderboardController:_pushToGlobalViewers(p)
	if not self._pushEvent then
		return
	end

	for _, player in Players:GetPlayers() do
		local playerTab = self._playerTabs[player.UserId]

		if playerTab and playerTab.global then
			self._pushEvent:FireClient(player, p)
		end
	end
end

function PlatformLeaderboardController:_pushToPlayer(player, p)
	if self._pushEvent then
		self._pushEvent:FireClient(player, p)
	end
end

function PlatformLeaderboardController:destroy()
	for _, conn in self._conns do
		if typeof(conn) == "table" and conn.disconnect then
			conn:disconnect()
		elseif typeof(conn) == "RBXScriptConnection" then
			conn:Disconnect()
		end
	end

	table.clear(self._conns)
	self._configService:teardown()

	if self._cache then
		self._cache:destroy()
	end

	if self._pushEvent then
		self._pushEvent:Destroy()
	end
end

return PlatformLeaderboardController
