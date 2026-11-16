local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local parent = script.Parent.Parent

local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)

local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local createSignalMap = CoreScriptsRoactCommon.Utilities.createSignalMap
local sortTableByValue = CoreScriptsRoactCommon.Utilities.sortTableByValue

local createPlayerStore = require(script.Parent.createPlayerStore)
local createTeamStore = require(script.Parent.createTeamStore)
require(script.Parent.LeaderboardStoreTypes)

local defineFastFlag = game:DefineFastFlag("FilterNewPlayerListValueStat", false)
local defineFastFlag2 = game:DefineFastFlag("PlayerListHideUnusedStats", false)
local FFlagPlayerListFixLeaderstatsStacking = SharedFlags.FFlagPlayerListFixLeaderstatsStacking
local defineFastFlag3 = game:DefineFastFlag("PlayerListSortByLowercaseUsername", false)

local LeaderboardStore = {}
LeaderboardStore.__index = LeaderboardStore

function LeaderboardStore.new(teamsService, playersService)
	local self = setmetatable({ _leaderboardConnections = {} }, LeaderboardStore)

	self._teamStores = {}
	self._playerStores = {}

	self._teamsService = teamsService
	self._playersService = playersService

	local signal, setServerAddOrder = Signals.createSignal({})
	self._getServerAddOrder = signal
	self._setServerAddOrder = setServerAddOrder
	self._serverAddOrderConnection = {}
	self._serverInstanceAddedConnection = nil
	self._serverAddOrderEffectCleanup = nil
	self._gameStatMetadata = {}

	self._topGameStatsOrder = createSignalMap()
	self._topGameStatsOrderSetter = {}
	self._topGameStatSortOrder = {}

	self._gameStatsUsage = {}

	self._virtualTeamList = createSignalMap()

	self._teamStores.Neutral = createTeamStore("Neutral", teamsService)

	local neutral = self._teamStores.Neutral
	self._virtualTeamList.setData("Neutral", {
		name = neutral.getName,
		color = neutral.getColor,
		order = neutral.getOrder,
		stats = neutral.getStats,
		players = neutral.getPlayers
	}, false)

	self:_connectPlayers()
	self:_connectTeams()
	self:_updateServerAddOrder()

	return self
end

function LeaderboardStore:destroy()
	for _, connection in pairs(self._serverAddOrderConnection) do
		if connection.Disconnect then
			connection:Disconnect()
		end
	end

	self._serverAddOrderConnection = {}

	if self._serverAddOrderEffectCleanup then
		self._serverAddOrderEffectCleanup()
	end

	if self._serverInstanceAddedConnection then
		self._serverInstanceAddedConnection:Disconnect()
	end

	self._serverInstanceAddedConnection = nil

	for _, leaderboardConnection in pairs(self._leaderboardConnections) do
		if leaderboardConnection.Disconnect then
			leaderboardConnection:Disconnect()
		end
	end

	self._leaderboardConnections = {}

	for _, teamStore in pairs(self._teamStores) do
		teamStore.destroy()
	end

	self._teamStores = {}

	for _, playerStore in pairs(self._playerStores) do
		playerStore.destroy()
	end

	self._playerStores = {}
end

function LeaderboardStore:getGameStatsList()
	return self._topGameStatsOrder
end

function LeaderboardStore:getTeamList()
	return self._virtualTeamList
end

function LeaderboardStore:getTeamPlayerList(p, _)
	local teamStore = self._teamStores[p]

	if teamStore then
		return teamStore.getPlayers
	end

	return createSignalMap()
end

function LeaderboardStore:getPlayerEntry(p, _)
	local playerStore = self._playerStores[p]

	if playerStore then
		return playerStore.getPlayerEntry()
	end

	return nil
end

function LeaderboardStore:_updateTeamStats(p, p2: string)
	local teamStore = self._teamStores[p]

	if teamStore then
		teamStore.updateStat(p2, function(p3, p4, p5)
			local playerStore = self._playerStores[p3]

			if playerStore then
				return playerStore.getStatValue(p4, p5)
			end

			return nil
		end)
	end
end

function LeaderboardStore:_removeTeamStats(p, p2: string)
	local teamStore = self._teamStores[p]

	if teamStore then
		teamStore.removeStat(p2)
	end
end

function LeaderboardStore:_updateAllTeamStats(p: string)
	for k, _ in pairs(self._teamStores) do
		self:_updateTeamStats(k, p)
	end
end

function LeaderboardStore:_removeAllTeamStats(p: string)
	for k, _ in pairs(self._teamStores) do
		self:_removeTeamStats(k, p)
	end
end

function LeaderboardStore:_shouldSortPlayers(_, p: string?): boolean
	if
		not p
		or p == self._topGameStatSortOrder[1] and self._gameStatMetadata[p] and self._gameStatMetadata[p].isNumber
		or self._gameStatMetadata[p] and self._gameStatMetadata[p].priority == 1e999
	then
		return true
	end

	if self._topGameStatSortOrder[1] or not (self._gameStatMetadata[p] and self._gameStatMetadata[p].isNumber) then
		return false
	end

	return true
end

function LeaderboardStore:_sortPlayers(p, p2: string?)
	if not self:_shouldSortPlayers(p, p2) then
		return
	end

	local teamStore = self._teamStores[p]

	if not teamStore then
		return
	end

	local v = sortTableByValue(
		teamStore.getPlayers.getAllData(false),
		self:_compareStatsValue(self._topGameStatSortOrder)
	)

	for i, v2 in ipairs(v) do
		local key = v2.key
		local playerStore = self._playerStores[key]

		if playerStore then
			playerStore.setOrder(i)
		end
	end
end

function LeaderboardStore:_compareStatsValue(list)
	return function(p, p2)
		local item = list[1]

		if item then
			local playerStore = self._playerStores[p.key]
			local playerStore2 = self._playerStores[p2.key]

			if not playerStore then
				return false
			end

			if not playerStore2 then
				return true
			end

			local data = playerStore.getPlayerEntry().stats.getData(item, false)

			if data == nil then
				return false
			end

			local data2 = playerStore2.getPlayerEntry().stats.getData(item, false)

			if data2 == nil then
				return true
			end

			local v = data(false)
			local v2 = data2(false)

			if typeof(v) == typeof(v2) and v ~= v2 then
				return self:_compareRawStatsValue(v, v2)
			end

			if not defineFastFlag3 then
				return p.key.Name < p2.key.Name
			end
		end

		return p.key.DisplayName:lower() < p2.key.DisplayName:lower()
	end
end

function LeaderboardStore._compareRawStatsValue(_, p, p2): boolean
	if p == nil or p2 == nil then
		return p2 ~= nil
	end

	return p2 < p
end

local function isGameStatValidNumber(instance) -- 1 equivalent call inferred from this helper
	return instance:IsA("NumberValue")
		or instance:IsA("IntValue")
		or instance:IsA("DoubleConstrainedValue")
		or instance:IsA("IntConstrainedValue")
end

local function compareGameStats(p, p2): boolean
	if p.value.priority == nil and p2.value.priority == nil then
		return true
	end

	if p.value.priority == nil then
		return p2.value.priority < 0
	end

	if p2.value.priority == nil then
		return p.value.priority > 0
	end

	return p.value.priority > p2.value.priority
end

function LeaderboardStore:_updateGameStatsToShow()
	local v = sortTableByValue(self._gameStatMetadata, compareGameStats)

	self._topGameStatSortOrder = {}
	local count = 0
	local v2 = {}

	for i, v3 in ipairs(v) do
		if count >= 4 then
			break
		end

		if not (not defineFastFlag2 or self._gameStatMetadata[v3.key].isUsed) then
			continue
		end

		local key = v3.key
		v2[key] = i

		if self._topGameStatsOrder.getData(key, false) == nil then
			local signal, v4 = Signals.createSignal(i)
			self._topGameStatsOrder.setData(key, { order = signal }, false)

			self._topGameStatsOrderSetter[key] = v4
		else
			self._topGameStatsOrderSetter[key](i)
		end

		table.insert(self._topGameStatSortOrder, key)

		count += 1
	end

	for k, _ in pairs(self._topGameStatsOrder.getAllData(false)) do
		if v2[k] then
			continue
		end

		self._topGameStatsOrder.removeData(k, false)
		self._topGameStatsOrderSetter[k] = nil
	end
end

function LeaderboardStore:_updateGameStatOrder(p, value: number?)
	local v = self._gameStatMetadata[p.Name]
	local priority = value or 0

	if v then
		if value == nil then
			self._gameStatMetadata[p.Name].hasPriority = false
		else
			self._gameStatMetadata[p.Name].hasPriority = true
		end
	end

	if v.priority ~= priority then
		self._gameStatMetadata[p.Name].priority = priority
		self:_updateGameStatsToShow()
	end
end

function LeaderboardStore:_updateServerAddOrder()
	local v = RobloxReplicatedStorage:GetAttribute("LeaderstatsOrder") or {}
	RobloxReplicatedStorage:GetAttributeChangedSignal("LeaderstatsOrder"):Connect(function()
		v = RobloxReplicatedStorage:GetAttribute("LeaderstatsOrder") or {}
		self._setServerAddOrder(v)
	end)

	local HttpService = game:GetService("HttpService")

	local function decodeJSON(json: string)
		return HttpService:JSONDecode(json)
	end

	local function decodeAddOrder(p: string) -- 2 equivalent calls inferred from this helper
		local success, result = pcall(decodeJSON, p)
		return success and result or {}
	end

	self._serverInstanceAddedConnection = nil

	local function childAdded(child)
		if child.Name ~= "LeaderstatsOrder" then
			return
		end

		if self._serverInstanceAddedConnection then
			self._serverInstanceAddedConnection:Disconnect()
		end

		v = decodeAddOrder(child.Value) -- inferred equivalent call
		self._serverAddOrderConnection[child] = child.Changed:Connect(function(p)
			v = decodeAddOrder(p) -- inferred equivalent call
			self._setServerAddOrder(v)
		end)
	end

	self._serverInstanceAddedConnection = RobloxReplicatedStorage.ChildAdded:Connect(childAdded)

	for _, child in ipairs(RobloxReplicatedStorage:GetChildren()) do
		childAdded(child)
	end

	self._serverAddOrderEffectCleanup = Signals.createEffect(function(p)
		local serverAddOrder = self._getServerAddOrder(p)
		local flag = false

		for k, v2 in pairs(serverAddOrder) do
			if not (not defineFastFlag or v2 ~= 0) then
				continue
			end

			if self._gameStatMetadata[k] then
				if self._gameStatMetadata[k].hasPriority ~= true then
					self._gameStatMetadata[k].priority = v2 * -1
					flag = true
				end
			elseif not defineFastFlag2 then
				self._gameStatMetadata[k] = {
					priority = v2 * -1,
					hasPriority = false
				}
			end
		end

		if flag then
			self:_updateGameStatsToShow()
		end
	end)
end

function LeaderboardStore:_updateGameStatPriority(instance)
	local priority = instance:FindFirstChild("Priority")
	local v

	if priority and (priority:IsA("IntValue") or priority:IsA("NumberValue")) then
		v = priority.Value
	end

	local isPrimary = instance:FindFirstChild("IsPrimary")

	if isPrimary then
		v = not isPrimary:IsA("BoolValue") and 1e999 or isPrimary.Value and 1e999 or v
	end

	self:_updateGameStatOrder(instance, v)
end

function LeaderboardStore:_addGameStat(instance)
	if self._gameStatMetadata[instance.Name] == nil then
		self._gameStatMetadata[instance.Name] = {}
	end

	self._gameStatMetadata[instance.Name].isNumber = isGameStatValidNumber(instance) -- inferred equivalent call
	self:_updateGameStatPriority(instance)

	if defineFastFlag2 and not self._gameStatMetadata[instance.Name].isUsed then
		self._gameStatMetadata[instance.Name].isUsed = true
		self:_updateGameStatsToShow()
	end

	self._gameStatsUsage[instance.Name] = not self._gameStatsUsage[instance.Name] and 1
		or self._gameStatsUsage[instance.Name] + 1

	self:_updateAllTeamStats(instance.Name)
end

function LeaderboardStore:_removeGameStat(p)
	self._gameStatsUsage[p.Name] = not self._gameStatsUsage[p.Name] and 0 or self._gameStatsUsage[p.Name] - 1

	if not (self._gameStatsUsage[p.Name] <= 0) then
		self:_updateGameStatPriority(p)

		return
	end

	self._gameStatsUsage[p.Name] = nil
	self._topGameStatsOrder.removeData(p.Name, false)
	self._topGameStatsOrderSetter[p.Name] = nil
	self._gameStatMetadata[p.Name] = nil
	self:_updateGameStatsToShow()

	self:_updateAllTeamStats(p.Name)
end

if FFlagPlayerListFixLeaderstatsStacking then
	function LeaderboardStore:_checkGameStatsExist()
		local v = {}

		for k, _ in self._gameStatMetadata do
			v[k] = false
		end

		for k, _ in self._playerStores do
			local leaderstats = k:FindFirstChild("leaderstats")

			if not leaderstats then
				continue
			end

			for childName, _ in v do
				if leaderstats:FindFirstChild(childName) then
					v[childName] = true
				end
			end
		end

		for k, v2 in v do
			if v2 then
				continue
			end

			self._gameStatsUsage[k] = nil
			self._topGameStatsOrder.removeData(k, false)
			self._topGameStatsOrderSetter[k] = nil
			self._gameStatMetadata[k] = nil
			self:_updateGameStatsToShow()
			self:_updateAllTeamStats(k)
		end
	end
end

function LeaderboardStore:_createPlayerStore(p)
	return createPlayerStore(p, function(p2)
		self:_addGameStat(p2)
	end, function(p2)
		self:_removeGameStat(p2)
	end, function(p2, p3)
		self:_updateTeamStats(p2, p3)
	end, function(p2, p3)
		self:_sortPlayers(p2, p3)
	end, FFlagPlayerListFixLeaderstatsStacking and function()
		self:_checkGameStatsExist()
	end or nil)
end

function LeaderboardStore:_createTeamStore(p)
	return createTeamStore(p, self._teamsService)
end

function LeaderboardStore:_getOrCreateTeamStore(p)
	local teamStore = self._teamStores[p]

	if teamStore then
		return teamStore
	end

	teamStore = self:_createTeamStore(p)
	self._teamStores[p] = teamStore

	if p ~= "Neutral" then
		self._virtualTeamList.setData(p, {
			name = teamStore.getName,
			color = teamStore.getColor,
			order = teamStore.getOrder,
			stats = teamStore.getStats,
			players = teamStore.getPlayers
		}, false)
	end

	return teamStore
end

function LeaderboardStore:_addPlayerStore(p)
	if self._playerStores[p] then
		return
	end

	local v = not p.Team and "Neutral" or p.Team
	self:_getOrCreateTeamStore(v).addPlayer(p)

	local playerStore = self:_createPlayerStore(p)
	self._playerStores[p] = playerStore

	self:_connectPlayerTeamChange(p)

	self:_sortPlayers(v)
end

function LeaderboardStore:_removePlayerStore(p)
	local playerStore = self._playerStores[p]

	if not playerStore then
		return
	end

	local team = playerStore.getTeam()
	local teamStore = self._teamStores[team]

	if teamStore then
		teamStore.removePlayer(p)
	end

	local v = "PlayerTeamChanged_" .. p.Name
	local leaderboardConnection = self._leaderboardConnections[v]

	if leaderboardConnection and leaderboardConnection.Disconnect then
		leaderboardConnection:Disconnect()
		self._leaderboardConnections[v] = nil
	end

	playerStore.destroy()
	self._playerStores[p] = nil

	self:_sortPlayers(team)
end

function LeaderboardStore:_connectPlayerTeamChange(data)
	local changedConnection = data.Changed:Connect(function(p: string)
		if p == "Team" then
			local playerStore = self._playerStores[data]

			if not playerStore then
				return
			end

			local team = playerStore.getTeam()
			local v = not data.Team and "Neutral" or data.Team

			local teamStore = self._teamStores[team]

			if teamStore then
				teamStore.removePlayer(data)
			end

			self:_getOrCreateTeamStore(v).addPlayer(data)

			playerStore.setTeam(v)

			self:_sortPlayers(team)
			self:_sortPlayers(v)
		end
	end)

	self._leaderboardConnections["PlayerTeamChanged_" .. data.Name] = changedConnection
end

function LeaderboardStore:_addTeamStore(p)
	if self._teamStores[p] then
		return
	end

	local teamStore = self:_createTeamStore(p)
	self._teamStores[p] = teamStore

	self._virtualTeamList.setData(p, {
		name = teamStore.getName,
		color = teamStore.getColor,
		order = teamStore.getOrder,
		stats = teamStore.getStats,
		players = teamStore.getPlayers
	}, false)
end

function LeaderboardStore:_removeTeamStore(p)
	local teamStore = self._teamStores[p]

	if not teamStore then
		return
	end

	local teamStore2 = self:_getOrCreateTeamStore("Neutral")
	local allData = teamStore.getPlayers.getAllData(false)

	for k, _ in pairs(allData) do
		teamStore.removePlayer(k)
		teamStore2.addPlayer(k)

		local playerStore = self._playerStores[k]

		if playerStore then
			playerStore.setTeam("Neutral")
		end
	end

	teamStore.destroy()
	self._teamStores[p] = nil

	self._virtualTeamList.removeData(p, false)
end

function LeaderboardStore:_connectTeams()
	local childAddedConnection = self._teamsService.ChildAdded:Connect(function(team)
		if team:IsA("Team") then
			self:_addTeamStore(team)
		end
	end)
	self._leaderboardConnections.TeamAdded = childAddedConnection

	local childRemovedConnection = self._teamsService.ChildRemoved:Connect(function(team)
		if team:IsA("Team") then
			self:_removeTeamStore(team)
		end
	end)
	self._leaderboardConnections.TeamRemoved = childRemovedConnection

	for _, v in pairs(self._teamsService:GetTeams()) do
		self:_addTeamStore(v)
	end
end

function LeaderboardStore:_connectPlayers()
	local playerAddedConnection = self._playersService.PlayerAdded:Connect(function(player)
		self:_addPlayerStore(player)
	end)
	self._leaderboardConnections.PlayerAdded = playerAddedConnection

	local playerRemovingConnection = self._playersService.PlayerRemoving:Connect(function(player)
		self:_removePlayerStore(player)
	end)
	self._leaderboardConnections.PlayerRemoving = playerRemovingConnection

	for _, v in pairs(self._playersService:GetPlayers()) do
		self:_addPlayerStore(v)
	end
end

return LeaderboardStore
