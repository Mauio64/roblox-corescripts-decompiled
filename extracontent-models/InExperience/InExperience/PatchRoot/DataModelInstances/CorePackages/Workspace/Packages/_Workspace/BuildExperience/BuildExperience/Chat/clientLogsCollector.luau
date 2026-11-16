local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local MemStorageService = game:GetService("MemStorageService")
local Players = game:GetService("Players")

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

local FFlagBuildExperienceAskForLogsSeverityRetention = require(BuildExperience.Flags.FFlagBuildExperienceAskForLogsSeverityRetention)

local StudioClientLogsTool = CreatorAgentChat.StudioClientLogsTool

game:DefineFastInt("MyStatsExperienceAskForLogsMaxEntries", 100)

local function getDefaultMaxEntriesPerSource() -- 6 equivalent calls inferred from this helper
	return (math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries")))
end

local v = {
	[Enum.MessageType.MessageOutput.Value] = "Output",
	[Enum.MessageType.MessageInfo.Value] = "Information",
	[Enum.MessageType.MessageWarning.Value] = "Warning",
	[Enum.MessageType.MessageError.Value] = "Error"
}

local v2 = {
	[Enum.MessageType.MessageOutput.Value] = 0,
	[Enum.MessageType.MessageInfo.Value] = 1,
	[Enum.MessageType.MessageWarning.Value] = 2,
	[Enum.MessageType.MessageError.Value] = 3
}

local function getMessageTypeValue(value) -- 2 equivalent calls inferred from this helper
	if typeof(value) == "EnumItem" then
		return value.Value
	end

	return if typeof(value) == "number" then value else nil
end

local function getMessageTypeLabel(messageTypeValue) -- 1 equivalent call inferred from this helper
	local messageTypeValue2 = getMessageTypeValue(messageTypeValue) -- inferred equivalent call

	if messageTypeValue2 ~= nil then
		return v[messageTypeValue2] or tostring(messageTypeValue2)
	end

	if typeof(messageTypeValue) == "EnumItem" then
		return messageTypeValue.Name
	end

	if typeof(messageTypeValue) == "string" and messageTypeValue ~= "" then
		return messageTypeValue
	end

	return nil
end

local function encodeContext(items) -- 1 equivalent call inferred from this helper
	if typeof(items) == "table" and next(items) ~= nil then
		return HttpService:JSONEncode(items)
	end

	return nil
end

local function getSeverityRank(p) -- 4 equivalent calls inferred from this helper
	local messageTypeValue = p.messageTypeValue

	if messageTypeValue == nil then
		return 0
	end

	return v2[messageTypeValue] or 0
end

local function trimToCapBySeverity(list, p: number)
	while p < #list do
		local severityRank2 = getSeverityRank(list[1]) -- inferred equivalent call
		local v3 = 1

		for i = 2, #list do
			local severityRank = getSeverityRank(list[i]) -- inferred equivalent call

			if not (severityRank < severityRank2) then
				continue
			end

			v3 = i
			severityRank2 = severityRank
		end

		table.remove(list, v3)
	end
end

local function selectRetainedBySeverity(list, p: number)
	local retainedBySeverity = {}

	if p <= 0 then
		return retainedBySeverity
	end

	local count = #list

	if count <= p then
		table.move(list, 1, count, 1, retainedBySeverity)
		return retainedBySeverity
	end

	local v3 = {}

	for _, item in list do
		local severityRank = getSeverityRank(item) -- inferred equivalent call
		v3[severityRank] = (v3[severityRank] or 0) + 1
	end

	local v4 = 0

	for i = 3, 0, -1 do
		local v5 = v3[i] or 0

		if v5 < p then
			p -= v5
		else
			v4 = i
			break
		end
	end

	local v5 = (v3[v4] or 0) - p

	for _, item in list do
		local severityRank = getSeverityRank(item) -- inferred equivalent call

		if v4 < severityRank then
			table.insert(retainedBySeverity, item)
		elseif severityRank == v4 then
			if v5 > 0 then
				v5 -= 1
			else
				table.insert(retainedBySeverity, item)
			end
		end
	end

	return retainedBySeverity
end

local function pushCapped(list, p, p2: number) -- 3 equivalent calls inferred from this helper
	if p2 <= 0 then
		return
	end

	table.insert(list, p)

	if p2 < #list then
		if FFlagBuildExperienceAskForLogsSeverityRetention then
			trimToCapBySeverity(list, p2)
		else
			table.remove(list, 1)
		end
	end
end

local function toLogEntry(message, messageTypeValue, timestamp, items)
	if typeof(message) ~= "string" then
		message = tostring(message or "")
	end

	if typeof(timestamp) ~= "number" then
		timestamp = nil
	end

	local logEntry = {
		message = message,
		messageType = getMessageTypeLabel(messageTypeValue), -- inferred equivalent call
		messageTypeValue = 0,
		timestamp = 0,
		contextJson = 0
	}
	messageTypeValue = getMessageTypeValue(messageTypeValue) -- inferred equivalent call
	logEntry.messageTypeValue = messageTypeValue
	logEntry.timestamp = timestamp
	logEntry.contextJson = encodeContext(items) -- inferred equivalent call
	return logEntry
end

local v3 = {}
local serverMessageOutConnection = nil
local serverContextOutConnection = nil
local flag = false
local defaultMaxEntriesPerSource = getDefaultMaxEntriesPerSource() -- inferred equivalent call
local messageOutConnection = nil
local playerRemovingConnection = nil
local count = 0
local v4 = false
local v5 = nil
local fn

local function collectClientLogs(logService, maxEntriesPerSource: number?)
	local v6 = maxEntriesPerSource or getDefaultMaxEntriesPerSource() -- inferred equivalent call
	local logHistory = (logService or LogService):GetLogHistory()

	local clientLogs = {}

	for _, v7 in logHistory do
		if typeof(v7) == "table" then
			pushCapped(clientLogs, toLogEntry(v7.message, v7.messageType, v7.timestamp, v7.context), v6) -- inferred equivalent call
		end
	end

	return clientLogs
end

local function trimServerLogs(p: number)
	if FFlagBuildExperienceAskForLogsSeverityRetention then
		trimToCapBySeverity(v3, p)
		return
	end

	while p < #v3 do
		table.remove(v3, 1)
	end
end

local function startServerLogCollection(options): boolean
	local v6 = options or {}

	if (v6.dataModel or game).GameId == 0 then
		return false
	end

	if flag then
		return true
	end

	local logService = v6.logService or LogService
	defaultMaxEntriesPerSource = v6.maxEntriesPerSource or getDefaultMaxEntriesPerSource() -- inferred equivalent call
	trimServerLogs(defaultMaxEntriesPerSource)

	serverMessageOutConnection = logService.ServerMessageOut:Connect(function(p, p2, p3, p4)
		pushCapped(v3, toLogEntry(p, p2, p3, p4), defaultMaxEntriesPerSource) -- inferred equivalent call

		if v5 ~= nil then
			v5()
		end
	end)

	serverContextOutConnection = logService.ServerContextOut:Connect(function(data)
		if typeof(data) ~= "table" or data._structuredContext == nil then
			return
		end

		pushCapped( -- inferred equivalent call
			v3,
			toLogEntry(data._message, data._messageType, data._timestamp, data._structuredContext),
			defaultMaxEntriesPerSource
		)

		if v5 ~= nil then
			v5()
		end
	end)

	logService:RequestServerOutput()

	flag = true

	if fn ~= nil then
		fn(v6)
	end

	return true
end

local function getCollectedServerLogs(maxEntriesPerSource: number?)
	local v6 = maxEntriesPerSource or getDefaultMaxEntriesPerSource() -- inferred equivalent call

	if FFlagBuildExperienceAskForLogsSeverityRetention then
		return selectRetainedBySeverity(v3, v6)
	end

	local result = {}

	for i = math.max(1, #v3 - v6 + 1), #v3 do
		table.insert(result, v3[i])
	end

	return result
end

local function getLogSnapshotKey(p: number) -- 2 equivalent calls inferred from this helper
	return `BuildExperiencePlaytestLogs:{p}`
end

local function writeLogSnapshot(p, p2: string, p3)
	local success, result = pcall(HttpService.JSONEncode, HttpService, p3)

	if not success or typeof(result) ~= "string" then
		return
	end

	pcall(p.SetItem, p, p2, result)
end

fn = function(data)
	local dataModel = data.dataModel or game
	local gameId = dataModel.GameId
	local placeId = dataModel.PlaceId
	local placeVersion = dataModel.PlaceVersion

	if typeof(gameId) ~= "number" or gameId == 0 or typeof(placeId) ~= "number" or typeof(placeVersion) ~= "number" then
		return
	end

	local logService = data.logService or LogService
	local memStorageService = data.memStorageService or MemStorageService
	local playersService = data.playersService or Players
	local maxEntriesPerSource = data.maxEntriesPerSource or getDefaultMaxEntriesPerSource() -- inferred equivalent call
	local logSnapshotKey = getLogSnapshotKey(gameId) -- inferred equivalent call
	count += 1
	local v6 = count
	v4 = false
	pcall(memStorageService.SetItem, memStorageService, logSnapshotKey, "")

	local function persistNow()
		if v6 ~= count then
			return
		end

		local success, result = pcall(collectClientLogs, logService, maxEntriesPerSource)

		if not success then
			return
		end

		local v7 = memStorageService
		local v8 = {
			schemaVersion = 1,
			universeId = gameId,
			placeId = placeId,
			placeVersion = placeVersion,
			clientLogs = result,
			serverLogs = getCollectedServerLogs(maxEntriesPerSource)
		}
		local success2, result2 = pcall(HttpService.JSONEncode, HttpService, v8)

		if success2 then
			if typeof(result2) ~= "string" then
				return
			end

			pcall(v7.SetItem, v7, logSnapshotKey, result2)
		end
	end

	local function scheduleWrite()
		if v6 ~= count or v4 then
			return
		end

		v4 = true
		local function writeAfterDelay()
			if v6 ~= count then
				return
			end

			v4 = false
			persistNow()
		end

		if data.schedule == nil then
			task.delay(1, writeAfterDelay)
		else
			data.schedule(1, writeAfterDelay)
		end
	end

	v5 = scheduleWrite
	messageOutConnection = logService.MessageOut:Connect(scheduleWrite)
	local localPlayer = playersService.LocalPlayer
	playerRemovingConnection = playersService.PlayerRemoving:Connect(function(player)
		if player == localPlayer then
			persistNow()
		end
	end)
	scheduleWrite()
end

local function readLogSnapshot(data)
	local universeId = data.universeId
	local placeId = data.placeId

	if typeof(universeId) ~= "number" or universeId == 0 or typeof(placeId) ~= "number" then
		return nil
	end

	local memStorageService = data.memStorageService or MemStorageService
	local success, item = pcall(memStorageService.GetItem, memStorageService, getLogSnapshotKey(universeId)) -- inferred equivalent call

	if not success or typeof(item) ~= "string" or item == "" then
		return nil
	end

	local success2, result = pcall(HttpService.JSONDecode, HttpService, item)

	if not success2 or typeof(result) ~= "table" then
		return nil
	end

	if
		result.schemaVersion == 1
		and result.universeId == universeId
		and result.placeId == placeId
		and typeof(result.placeVersion) == "number"
		and typeof(result.clientLogs) == "table"
		and typeof(result.serverLogs) == "table"
	then
		return result
	end

	return nil
end

local function logsAreStale(placeVersion, minimumPlaceVersion: number?): boolean -- 2 equivalent calls inferred from this helper
	return minimumPlaceVersion ~= nil and (typeof(placeVersion) ~= "number" or placeVersion < minimumPlaceVersion)
end

local ClientLogsCollector = {}
ClientLogsCollector.startServerLogCollection = startServerLogCollection

function ClientLogsCollector.stopServerLogCollection(flag2: boolean?)
	if serverMessageOutConnection ~= nil then
		serverMessageOutConnection:Disconnect()
		serverMessageOutConnection = nil
	end

	if serverContextOutConnection ~= nil then
		serverContextOutConnection:Disconnect()
		serverContextOutConnection = nil
	end

	if messageOutConnection ~= nil then
		messageOutConnection:Disconnect()
		messageOutConnection = nil
	end

	if playerRemovingConnection ~= nil then
		playerRemovingConnection:Disconnect()
		playerRemovingConnection = nil
	end

	count += 1
	v4 = false
	v5 = nil
	flag = false

	if flag2 == true then
		v3 = {}
	end
end

function ClientLogsCollector.collectToolResultContent(options)
	local v6 = options or {}
	local dataModel = v6.dataModel or game

	if dataModel.GameId == 0 then
		local v7 = readLogSnapshot(v6)

		if v7 == nil then
			return StudioClientLogsTool.formatNotInGameContent()
		end

		if logsAreStale(v7.placeVersion, v6.minimumPlaceVersion) then -- inferred equivalent call
			return StudioClientLogsTool.formatStaleLogsContent()
		end

		return StudioClientLogsTool.formatLogsContent(v7.clientLogs, v7.serverLogs)
	else
		if logsAreStale(dataModel.PlaceVersion, v6.minimumPlaceVersion) then -- inferred equivalent call
			return StudioClientLogsTool.formatStaleLogsContent()
		end

		local maxEntriesPerSource = v6.maxEntriesPerSource or getDefaultMaxEntriesPerSource() -- inferred equivalent call
		startServerLogCollection(v6)
		return StudioClientLogsTool.formatLogsContent(
			collectClientLogs(v6.logService, maxEntriesPerSource),
			getCollectedServerLogs(maxEntriesPerSource)
		)
	end
end

return ClientLogsCollector
