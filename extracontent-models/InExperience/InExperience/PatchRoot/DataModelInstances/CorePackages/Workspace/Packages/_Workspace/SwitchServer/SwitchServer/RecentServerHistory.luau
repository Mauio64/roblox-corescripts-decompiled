local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")

local SwitchServer = script:FindFirstAncestor("SwitchServer")

local FFlagUseMultipleServerIdsForSwitchServer = require(SwitchServer.Flags.FFlagUseMultipleServerIdsForSwitchServer)
local FIntSwitchServerMaxRecentServers = require(SwitchServer.Flags.FIntSwitchServerMaxRecentServers)
local FIntSwitchServerRecentServerWindowSeconds = require(SwitchServer.Flags.FIntSwitchServerRecentServerWindowSeconds)

local RecentServerHistory = {}
RecentServerHistory.__index = RecentServerHistory

local function isFresh(serverEntry, now: number): boolean -- 2 equivalent calls inferred from this helper
	return now - serverEntry.joinedAt <= FIntSwitchServerRecentServerWindowSeconds
end

function RecentServerHistory.new(historyKey: string?)
	local v = { _connections = {}, _historyKey = "", _history = {} }

	if historyKey == nil or historyKey == "" then
		return (setmetatable(v, RecentServerHistory))
	end

	v._historyKey = historyKey
	local object = setmetatable(v, RecentServerHistory)

	local function initHistory()
		local item = MemStorageService:GetItem(v._historyKey)

		if item and item ~= "" then
			local jsonDecode = HttpService:JSONDecode(item)

			if typeof(jsonDecode) == "table" then
				v._history = jsonDecode
			end
		end

		object:recordServer(tostring(game.PlaceId), (tostring(game.JobId)))
		object:writeHistory()
	end

	if game:IsLoaded() then
		initHistory()
		return object
	end

	table.insert(v._connections, game.Loaded:Connect(function()
		initHistory()
	end))

	return object
end

function RecentServerHistory:recordServer(placeId: string, serverId: string)
	local now = os.time()
	local serverEntries = {}
	local v = { serverId = serverId, joinedAt = now }

	if self._history.placeId ~= placeId then
		self._history = {
			placeId = placeId,
			serverEntries = { v }
		}

		return
	end

	table.insert(serverEntries, v)

	for _, serverEntry in self._history.serverEntries do
		if FIntSwitchServerMaxRecentServers <= #serverEntries then
			break
		end

		if isFresh(serverEntry, now) then -- inferred equivalent call
			table.insert(serverEntries, serverEntry)
		end
	end

	self._history.serverEntries = serverEntries
end

function RecentServerHistory:getRecentServerIds()
	local now = os.time()
	local recentServerIds = {}

	if self._history.serverEntries then
		for _, serverEntry in self._history.serverEntries do
			if isFresh(serverEntry, now) then -- inferred equivalent call
				table.insert(recentServerIds, serverEntry.serverId)
			end
		end
	end

	local jobId = tostring(game.JobId)

	if jobId ~= "" and table.find(recentServerIds, jobId) == nil then
		table.insert(recentServerIds, 1, jobId)
	end

	return recentServerIds
end

function RecentServerHistory:writeHistory()
	if self._historyKey == "" then
		return
	end

	MemStorageService:SetItem(self._historyKey, HttpService:JSONEncode(self._history))
end

function RecentServerHistory:disconnect()
	for _, connection in self._connections do
		connection:Disconnect()
	end

	self._connections = {}
end

if FFlagUseMultipleServerIdsForSwitchServer then
	RecentServerHistory.default = RecentServerHistory.new("RecentServerHistory")
	return RecentServerHistory
end

RecentServerHistory.default = RecentServerHistory.new("")

return RecentServerHistory
