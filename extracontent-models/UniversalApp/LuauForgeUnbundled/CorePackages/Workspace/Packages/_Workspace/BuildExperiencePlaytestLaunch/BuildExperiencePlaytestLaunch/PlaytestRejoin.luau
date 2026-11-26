local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local MessageBusService = game:GetService("MessageBusService")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/Loggers").Logger
local launchExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/launchExperience")

local defineFastInt = game:DefineFastInt("BuildExperiencePlaytestRejoinDelayMs", 250)

local defineFastInt2 = game:DefineFastInt("BuildExperiencePlaytestRejoinExpiryMs", 60000)

local messageId = MessageBusService:GetMessageId("Game", "onGameLeave")

local function now()
	return DateTime.now().UnixTimestampMillis
end

local function takeIntent()
	local item = MemStorageService:GetItem("BuildExperiencePlaytestRejoin")

	if item == nil or item == "" then
		return nil
	end

	MemStorageService:SetItem("BuildExperiencePlaytestRejoin", "")
	local success, result = pcall(HttpService.JSONDecode, HttpService, item)

	if
		not success
		or type(result) ~= "table"
		or type(result.placeId) ~= "number"
		or type(result.source) ~= "string"
		or type(result.createdAt) ~= "number"
	then
		return nil
	end

	local v5 = DateTime.now().UnixTimestampMillis - result.createdAt

	if v5 < 0 or defineFastInt2 < v5 then
		logger:warning("PlaytestRejoin: dropped a Playtest request that expired after {} ms", v5)
		return nil
	end

	return result
end

local v5 = {}

function v5.request(p2, p3, p4, p5)
	MemStorageService:SetItem("BuildExperiencePlaytestRejoin", HttpService:JSONEncode({
		placeId = p2,
		source = p3,
		isTeamTest = p4,
		isEarlyTesting = p5,
		createdAt = DateTime.now().UnixTimestampMillis
	}))
end

function v5.resume(p2): boolean
	local v6 = takeIntent()

	if v6 == nil then
		return false
	end

	local v7 = p2 or defineFastInt

	if v7 > 0 then
		task.delay(v7 / 1000, function()
			launchExperience(v6.placeId, v6.source, v6.isTeamTest, nil, v6.isEarlyTesting)
		end)
	else
		launchExperience(v6.placeId, v6.source, v6.isTeamTest, nil, v6.isEarlyTesting)
	end

	return true
end

function v5.listen()
	v5.resume()
	local connection = MessageBusService:Subscribe(messageId, function()
		v5.resume()
	end, false, false)
	return function()
		connection:Disconnect()
	end
end

return v5
