local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local MemStorageService = game:GetService("MemStorageService")
local Players = game:GetService("Players")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

local FFlagBuildExperienceAskForLogsSeverityRetention = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAskForLogsSeverityRetention")

local studioClientLogsTool = CreatorAgentChat.StudioClientLogsTool

game:DefineFastInt("MyStatsExperienceAskForLogsMaxEntries", 100)

local function getDefaultMaxEntriesPerSource()
	return (math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries")))
end

local v5 = {
	[Enum.MessageType.MessageOutput.Value] = "Output",
	[Enum.MessageType.MessageInfo.Value] = "Information",
	[Enum.MessageType.MessageWarning.Value] = "Warning",
	[Enum.MessageType.MessageError.Value] = "Error"
}

local v6 = {
	[Enum.MessageType.MessageOutput.Value] = 0,
	[Enum.MessageType.MessageInfo.Value] = 1,
	[Enum.MessageType.MessageWarning.Value] = 2,
	[Enum.MessageType.MessageError.Value] = 3
}

local function getMessageTypeValue(value)
	if typeof(value) == "EnumItem" then
		return value.Value
	end

	if typeof(value) == "number" then
		return value
	end

	return nil
end

local function getMessageTypeLabel(value)
	local v7

	if typeof(value) == "EnumItem" then
		v7 = value.Value
	elseif typeof(value) == "number" then
		v7 = value
	end

	if v7 ~= nil then
		return v5[v7] or tostring(v7)
	end

	if typeof(value) == "EnumItem" then
		return value.Name
	end

	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function encodeContext(items)
	if typeof(items) == "table" and next(items) ~= nil then
		return HttpService:JSONEncode(items)
	end

	return nil
end

local function getSeverityRank(p2)
	local messageTypeValue = p2.messageTypeValue

	if messageTypeValue == nil then
		return 0
	end

	return v6[messageTypeValue] or 0
end

local function trimToCapBySeverity(list, p2)
	while p2 < #list do
		local messageTypeValue = list[1].messageTypeValue
		local v7 = messageTypeValue == nil and 0 or v6[messageTypeValue] or 0
		local v8 = 1

		for i = 2, #list do
			local messageTypeValue2 = list[i].messageTypeValue
			local v9 = messageTypeValue2 == nil and 0 or v6[messageTypeValue2] or 0

			if not (v9 < v7) then
				continue
			end

			v8 = i
			v7 = v9
		end

		table.remove(list, v8)
	end
end

local function selectRetainedBySeverity(list, p2)
	local retainedBySeverity = {}

	if p2 <= 0 then
		return retainedBySeverity
	end

	local count = #list

	if count <= p2 then
		table.move(list, 1, count, 1, retainedBySeverity)
		return retainedBySeverity
	end

	local v7 = {}

	for k, item in list do
		local messageTypeValue = item.messageTypeValue
		local v8 = messageTypeValue == nil and 0 or v6[messageTypeValue] or 0

		v7[v8] = (v7[v8] or 0) + 1
	end

	local v8 = 0

	for i = 3, 0, -1 do
		local v9 = v7[i] or 0

		if v9 < p2 then
			p2 -= v9
		else
			v8 = i
			break
		end
	end

	local v9 = (v7[v8] or 0) - p2

	for k, item in list do
		local messageTypeValue = item.messageTypeValue
		local v10 = messageTypeValue == nil and 0 or v6[messageTypeValue] or 0

		if v8 < v10 then
			table.insert(retainedBySeverity, item)
		elseif v10 == v8 then
			if v9 > 0 then
				v9 -= 1
			else
				table.insert(retainedBySeverity, item)
			end
		end
	end

	return retainedBySeverity
end

local function pushCapped(list, p2, p3)
	if p3 <= 0 then
		return
	end

	table.insert(list, p2)

	if p3 < #list then
		if FFlagBuildExperienceAskForLogsSeverityRetention then
			trimToCapBySeverity(list, p3)
		else
			table.remove(list, 1)
		end
	end
end

local function toLogEntry(value, messageTypeValue, timestamp, items)
	if typeof(value) ~= "string" then
		value = tostring(value or "")
	end

	if typeof(timestamp) ~= "number" then
		timestamp = nil
	end

	local v7

	if typeof(messageTypeValue) == "EnumItem" then
		v7 = messageTypeValue.Value
	elseif typeof(messageTypeValue) == "number" then
		v7 = messageTypeValue
	end

	local v8

	if v7 == nil then
		if typeof(messageTypeValue) == "EnumItem" then
			v8 = messageTypeValue.Name
		elseif typeof(messageTypeValue) == "string" and messageTypeValue ~= "" then
			v8 = messageTypeValue
		end
	else
		v8 = v5[v7] or tostring(v7)
	end

	if typeof(messageTypeValue) == "EnumItem" then
		messageTypeValue = messageTypeValue.Value
	elseif typeof(messageTypeValue) ~= "number" then
		messageTypeValue = nil
	end

	local v9 = if typeof(items) == "table" and next(items) ~= nil then HttpService:JSONEncode(items) else nil

	return {
		message = value,
		messageType = v8,
		messageTypeValue = messageTypeValue,
		timestamp = timestamp,
		contextJson = v9
	}
end

local v7 = {}
local serverMessageOutConnection = nil
local serverContextOutConnection = nil
local flag = false
local v8 = math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))

local messageOutConnection = nil
local playerRemovingConnection = nil
local count = 0
local v9 = false
local v10 = nil
local fn

local function collectClientLogs(logService, maxEntriesPerSource)
	local v12 = maxEntriesPerSource or math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))

	local logHistory = (logService or LogService):GetLogHistory()

	local clientLogs = {}

	for k, v13 in logHistory do
		if typeof(v13) ~= "table" then
			continue
		end

		local v14 = toLogEntry(v13.message, v13.messageType, v13.timestamp, v13.context)

		if v12 <= 0 then
			continue
		end

		table.insert(clientLogs, v14)

		if not (v12 < #clientLogs) then
			continue
		end

		if FFlagBuildExperienceAskForLogsSeverityRetention then
			trimToCapBySeverity(clientLogs, v12)
		else
			table.remove(clientLogs, 1)
		end
	end

	return clientLogs
end

local function trimServerLogs(p2)
	if FFlagBuildExperienceAskForLogsSeverityRetention then
		trimToCapBySeverity(v7, p2)
		return
	end

	while p2 < #v7 do
		table.remove(v7, 1)
	end
end

local function startServerLogCollection(options): boolean
	local v11 = options or {}

	if (v11.dataModel or game).GameId == 0 then
		return false
	end

	if flag then
		return true
	end

	local logService = v11.logService or LogService
	v8 = v11.maxEntriesPerSource or math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))
	trimServerLogs(v8)

	serverMessageOutConnection = logService.ServerMessageOut:Connect(function(p2, p3, p4, p5)
		local v12 = v7
		local v13 = toLogEntry(p2, p3, p4, p5)
		local v14 = v8

		if not (v14 <= 0) then
			table.insert(v12, v13)

			if v14 < #v12 then
				if FFlagBuildExperienceAskForLogsSeverityRetention then
					trimToCapBySeverity(v12, v14)
				else
					table.remove(v12, 1)
				end
			end
		end

		if v10 ~= nil then
			v10()
		end
	end)

	serverContextOutConnection = logService.ServerContextOut:Connect(function(data)
		if typeof(data) ~= "table" or data._structuredContext == nil then
			return
		end

		local v12 = v7
		local v13 = toLogEntry(data._message, data._messageType, data._timestamp, data._structuredContext)
		local v14 = v8

		if not (v14 <= 0) then
			table.insert(v12, v13)

			if v14 < #v12 then
				if FFlagBuildExperienceAskForLogsSeverityRetention then
					trimToCapBySeverity(v12, v14)
				else
					table.remove(v12, 1)
				end
			end
		end

		if v10 ~= nil then
			v10()
		end
	end)

	logService:RequestServerOutput()

	flag = true

	if fn ~= nil then
		fn(v11)
	end

	return true
end

local function getCollectedServerLogs(maxEntriesPerSource)
	local v11 = maxEntriesPerSource or math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))

	if FFlagBuildExperienceAskForLogsSeverityRetention then
		return selectRetainedBySeverity(v7, v11)
	end

	local result = {}

	for i = math.max(1, #v7 - v11 + 1), #v7 do
		table.insert(result, v7[i])
	end

	return result
end

local function getLogSnapshotKey(p2)
	return `BuildExperiencePlaytestLogs:{p2}`
end

local function writeLogSnapshot(p2, p3, p4)
	local success, result = pcall(HttpService.JSONEncode, HttpService, p4)

	if not success or typeof(result) ~= "string" then
		return
	end

	pcall(p2.SetItem, p2, p3, result)
end

fn = function(data)
	local dataModel = data.dataModel or game
	local gameId = dataModel.GameId
	local placeId = dataModel.PlaceId
	local placeVersion = dataModel.PlaceVersion

	if
		typeof(gameId) ~= "number"
		or gameId == 0
		or typeof(placeId) ~= "number"
		or typeof(placeVersion) ~= "number"
	then
		return
	end

	local logService = data.logService or LogService
	local memStorageService = data.memStorageService or MemStorageService
	local playersService = data.playersService or Players
	local maxEntriesPerSource = data.maxEntriesPerSource
		or math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))
	local formatted = `BuildExperiencePlaytestLogs:{gameId}`

	count += 1
	local v11 = count
	v9 = false
	pcall(memStorageService.SetItem, memStorageService, formatted, "")

	local function persistNow()
		if v11 ~= count then
			return
		end

		local success, result = pcall(collectClientLogs, logService, maxEntriesPerSource)

		if not success then
			return
		end

		local v12 = memStorageService
		local v13 = formatted
		local v14 = {
			schemaVersion = 1,
			universeId = gameId,
			placeId = placeId,
			placeVersion = placeVersion,
			clientLogs = result,
			serverLogs = getCollectedServerLogs(maxEntriesPerSource)
		}
		local success2, result2 = pcall(HttpService.JSONEncode, HttpService, v14)

		if success2 then
			if typeof(result2) ~= "string" then
				return
			end

			pcall(v12.SetItem, v12, v13, result2)
		end
	end

	local function scheduleWrite()
		if v11 ~= count or v9 then
			return
		end

		v9 = true
		local function writeAfterDelay()
			if v11 ~= count then
				return
			end

			v9 = false
			persistNow()
		end

		if data.schedule == nil then
			task.delay(1, writeAfterDelay)
		else
			data.schedule(1, writeAfterDelay)
		end
	end

	v10 = scheduleWrite
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
	local success, item = pcall(
		memStorageService.GetItem,
		memStorageService,
		`BuildExperiencePlaytestLogs:{universeId}`
	)

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

local function logsAreStale(value, p2): boolean
	return p2 ~= nil and (typeof(value) ~= "number" or value < p2)
end

return {
	startServerLogCollection = startServerLogCollection,
	stopServerLogCollection = function(p2)
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
		v9 = false
		v10 = nil
		flag = false

		if p2 == true then
			v7 = {}
		end
	end,
	collectToolResultContent = function(options)
		local v11 = options or {}
		local dataModel = v11.dataModel or game

		if dataModel.GameId == 0 then
			local v12 = readLogSnapshot(v11)

			if v12 == nil then
				return studioClientLogsTool.formatNotInGameContent()
			end

			local placeVersion = v12.placeVersion
			local minimumPlaceVersion = v11.minimumPlaceVersion
			local v13

			if minimumPlaceVersion == nil then
				v13 = false
			else
				v13 = typeof(placeVersion) ~= "number" or placeVersion < minimumPlaceVersion
			end

			if v13 then
				return studioClientLogsTool.formatStaleLogsContent()
			end

			return studioClientLogsTool.formatLogsContent(v12.clientLogs, v12.serverLogs)
		else
			local placeVersion = dataModel.PlaceVersion
			local minimumPlaceVersion = v11.minimumPlaceVersion
			local v12

			if minimumPlaceVersion == nil then
				v12 = false
			else
				v12 = typeof(placeVersion) ~= "number" or placeVersion < minimumPlaceVersion
			end

			if v12 then
				return studioClientLogsTool.formatStaleLogsContent()
			end

			local maxEntriesPerSource = v11.maxEntriesPerSource
				or math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))
			startServerLogCollection(v11)
			return studioClientLogsTool.formatLogsContent(
				collectClientLogs(v11.logService, maxEntriesPerSource),
				getCollectedServerLogs(maxEntriesPerSource)
			)
		end
	end
}
