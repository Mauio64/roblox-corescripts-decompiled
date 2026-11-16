local parent = script.Parent
local parent2 = parent.Parent

local AppCommonLib = require(parent2.AppCommonLib)
local Signal = AppCommonLib.Signal

require(parent.PlatformLeaderboardTypes)

local defineFastInt = game:DefineFastInt("PlatformLeaderboardGlobalIntervalSeconds", 180)
local defineFastInt2 = game:DefineFastInt("PlatformLeaderboardGlobalJitterSeconds", 30)

local defineFastInt3 = game:DefineFastInt("PlatformLeaderboardFriendsIntervalSeconds", 180)
local defineFastInt4 = game:DefineFastInt("PlatformLeaderboardFriendsJitterSeconds", 30)

local PlatformLeaderboardCache = {}
PlatformLeaderboardCache.__index = PlatformLeaderboardCache

local task = task

function PlatformLeaderboardCache.new(fetcher, config, p)
	return (setmetatable({
		_fetcher = fetcher,
		_config = config,
		_globalData = nil,
		_globalEntriesByUserId = {},
		_friendsData = {},
		_userScoreEntries = {},
		_globalTimer = nil,
		_currentlyActiveGlobalLeaderboardViewersByUserId = {},
		_friendsTimer = nil,
		_currentFriendsLeaderboardViewersById = {},
		_scheduler = p or task,
		_globalUpdated = Signal.new(),
		_friendsUpdated = Signal.new(),
		_userScoreUpdated = Signal.new()
	}, PlatformLeaderboardCache))
end

function PlatformLeaderboardCache:onGlobalUpdated(callback)
	return self._globalUpdated:connect(callback)
end

function PlatformLeaderboardCache:onFriendsUpdated(callback)
	return self._friendsUpdated:connect(callback)
end

function PlatformLeaderboardCache:onUserScoreUpdated(callback)
	return self._userScoreUpdated:connect(callback)
end

function PlatformLeaderboardCache:getGlobalData()
	return self._globalData
end

function PlatformLeaderboardCache:getFriendsData(p: number)
	return self._friendsData[p]
end

function PlatformLeaderboardCache:getUserScore(p: number)
	return self._userScoreEntries[p]
end

function PlatformLeaderboardCache:_rebuildGlobalIndex()
	table.clear(self._globalEntriesByUserId)

	if not self._globalData then
		return
	end

	for _, entry in self._globalData.entries do
		self._globalEntriesByUserId[entry.userId] = entry
	end
end

function PlatformLeaderboardCache:resolveRankFromCache(p: number)
	local globalEntry = self._globalEntriesByUserId[p]
	return if globalEntry then globalEntry.rank else nil
end

function PlatformLeaderboardCache:_resolveEntryFromGlobalLeaderboard(p: number)
	return self._globalEntriesByUserId[p]
end

function PlatformLeaderboardCache:_fetchUserScoreForUser(p: number)
	if self._userScoreEntries[p] then
		self._userScoreUpdated:fire(p, self._userScoreEntries[p])
		return
	end

	local entryFromGlobalLeaderboard = self:_resolveEntryFromGlobalLeaderboard(p)

	if entryFromGlobalLeaderboard then
		self._userScoreEntries[p] = entryFromGlobalLeaderboard
		self._userScoreUpdated:fire(p, entryFromGlobalLeaderboard)
	else
		local success, result, v = pcall(self._fetcher.fetchUserScore, self._config.leaderboardId, p)

		if success and result then
			self._userScoreEntries[p] = v
			self._userScoreUpdated:fire(p, v)
		end
	end
end

function PlatformLeaderboardCache:_resolveUserScoresParallel()
	table.clear(self._userScoreEntries)

	for k in self._currentlyActiveGlobalLeaderboardViewersByUserId do
		self._scheduler.spawn(function()
			self:_fetchUserScoreForUser(k)
		end)
	end
end

function PlatformLeaderboardCache:_fetchFriendsLeaderboardForUser(p: number)
	local success, result, v = pcall(self._fetcher.fetchFriendsLeaderboard, self._config.leaderboardId, p)

	if success and result and v then
		local v2 = { entries = v.entries, lastRefreshedAt = os.time() }
		self._friendsData[p] = v2
		self._friendsUpdated:fire(p, v2, v.config)
	end
end

function PlatformLeaderboardCache:startGlobalRefresh(p: number)
	local currentlyActiveGlobalLeaderboardViewer = self._currentlyActiveGlobalLeaderboardViewersByUserId[p]
	self._currentlyActiveGlobalLeaderboardViewersByUserId[p] = true

	if self._globalTimer then
		if not currentlyActiveGlobalLeaderboardViewer then
			self:_fetchUserScoreForUser(p)
		end
	else
		local globalTimer = nil
		local function loop()
			repeat
				local success, result, v = pcall(self._fetcher.fetchGlobalLeaderboard, self._config.leaderboardId)

				if success and result and v then
					local globalData = { entries = v.entries, lastRefreshedAt = os.time() }
					self._globalData = globalData
					self:_rebuildGlobalIndex()
					self._globalUpdated:fire(globalData, v.config)
				end

				self:_resolveUserScoresParallel()

				local v2 = math.random(-defineFastInt2, defineFastInt2)
				self._scheduler.wait((math.max(1, defineFastInt + v2)))
			until self._globalTimer ~= globalTimer
		end

		globalTimer = self._scheduler.defer(function()
			if not pcall(loop) and self._globalTimer == globalTimer then
				self._globalTimer = nil
			end
		end)
		self._globalTimer = globalTimer
	end
end

function PlatformLeaderboardCache:stopGlobalRefresh(p: number)
	self._currentlyActiveGlobalLeaderboardViewersByUserId[p] = nil
	self._userScoreEntries[p] = nil

	if next(self._currentlyActiveGlobalLeaderboardViewersByUserId) then
		return
	end

	if self._globalTimer then
		pcall(self._scheduler.cancel, self._globalTimer)
		self._globalTimer = nil
	end

	self._globalData = nil
	table.clear(self._globalEntriesByUserId)
end

function PlatformLeaderboardCache:startFriendsRefresh(p: number)
	self._currentFriendsLeaderboardViewersById[p] = true

	if self._friendsTimer then
		if not self._friendsData[p] then
			self:_fetchFriendsLeaderboardForUser(p)
		end
	else
		local friendsTimer = nil

		local v = true
		local function loop()
			repeat
				table.clear(self._friendsData)

				for k in self._currentFriendsLeaderboardViewersById do
					local v2 = v and 0 or math.random(0, defineFastInt4)
					local v3 = k
					self._scheduler.spawn(function()
						self._scheduler.wait(v2)

						if self._currentFriendsLeaderboardViewersById[v3] then
							self:_fetchFriendsLeaderboardForUser(v3)
						end
					end)
				end

				v = false

				self._scheduler.wait((math.max(1, defineFastInt3)))
			until self._friendsTimer ~= friendsTimer
		end

		friendsTimer = self._scheduler.defer(function()
			if not pcall(loop) and self._friendsTimer == friendsTimer then
				self._friendsTimer = nil
			end
		end)
		self._friendsTimer = friendsTimer
	end
end

function PlatformLeaderboardCache:stopFriendsRefresh(p: number)
	self._currentFriendsLeaderboardViewersById[p] = nil

	if next(self._currentFriendsLeaderboardViewersById) then
		return
	end

	if self._friendsTimer then
		pcall(self._scheduler.cancel, self._friendsTimer)
		self._friendsTimer = nil
	end
end

function PlatformLeaderboardCache:forceRefresh(config, flag: boolean)
	self._config = config

	if flag then
		self._globalData = nil
		table.clear(self._globalEntriesByUserId)
		table.clear(self._friendsData)
		table.clear(self._userScoreEntries)
	end

	local v = next(self._currentlyActiveGlobalLeaderboardViewersByUserId)

	if self._globalTimer and v then
		pcall(self._scheduler.cancel, self._globalTimer)
		self._globalTimer = nil
		self:startGlobalRefresh(v)
	end

	if self._friendsTimer then
		pcall(self._scheduler.cancel, self._friendsTimer)
		self._friendsTimer = nil

		local v2 = {}

		for k in self._currentFriendsLeaderboardViewersById do
			table.insert(v2, k)
		end

		table.clear(self._currentFriendsLeaderboardViewersById)

		for _, v3 in v2 do
			self:startFriendsRefresh(v3)
		end
	end
end

function PlatformLeaderboardCache:cleanupForUserId(p: number)
	self:stopGlobalRefresh(p)
	self:stopFriendsRefresh(p)
end

function PlatformLeaderboardCache:teardown()
	if self._globalTimer then
		pcall(self._scheduler.cancel, self._globalTimer)
	end

	self._globalTimer = nil
	self._globalData = nil
	table.clear(self._globalEntriesByUserId)
	table.clear(self._currentlyActiveGlobalLeaderboardViewersByUserId)

	if self._friendsTimer then
		pcall(self._scheduler.cancel, self._friendsTimer)
	end

	self._friendsTimer = nil
	table.clear(self._currentFriendsLeaderboardViewersById)
	table.clear(self._friendsData)
	table.clear(self._userScoreEntries)
end

function PlatformLeaderboardCache:destroy()
	self:teardown()
end

return PlatformLeaderboardCache
