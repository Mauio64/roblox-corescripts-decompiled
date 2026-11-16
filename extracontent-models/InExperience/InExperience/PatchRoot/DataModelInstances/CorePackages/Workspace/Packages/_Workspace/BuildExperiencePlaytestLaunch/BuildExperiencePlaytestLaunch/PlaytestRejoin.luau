local parent = script:FindFirstAncestor("BuildExperiencePlaytestLaunch").Parent

local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local MessageBusService = game:GetService("MessageBusService")

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local launchExperience = require(script.Parent.launchExperience)

local defineFastInt = game:DefineFastInt("BuildExperiencePlaytestRejoinDelayMs", 250)

local defineFastInt2 = game:DefineFastInt("BuildExperiencePlaytestRejoinExpiryMs", 60000)

local messageId = MessageBusService:GetMessageId("Game", "onGameLeave")

local function now() -- 2 equivalent calls inferred from this helper
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

	local v = now() - result.createdAt -- inferred equivalent call

	if v < 0 or defineFastInt2 < v then
		Logger:warning("PlaytestRejoin: dropped a Playtest request that expired after {} ms", v)
		return nil
	end

	return result
end

local PlaytestRejoin = {}

function PlaytestRejoin.request(placeId: number, source: string, isTeamTest: boolean?, isEarlyTesting: boolean?)
	MemStorageService:SetItem("BuildExperiencePlaytestRejoin", HttpService:JSONEncode({
		placeId = placeId,
		source = source,
		isTeamTest = isTeamTest,
		isEarlyTesting = isEarlyTesting,
		createdAt = now() -- inferred equivalent call
	}))
end

function PlaytestRejoin.resume(p: number?): boolean
	local v = takeIntent()

	if v == nil then
		return false
	end

	local v2 = p or defineFastInt

	if v2 > 0 then
		task.delay(v2 / 1000, function()
			launchExperience(v.placeId, v.source, v.isTeamTest, nil, v.isEarlyTesting)
		end)
	else
		launchExperience(v.placeId, v.source, v.isTeamTest, nil, v.isEarlyTesting)
	end

	return true
end

function PlaytestRejoin.listen()
	PlaytestRejoin.resume()
	local connection = MessageBusService:Subscribe(messageId, function()
		PlaytestRejoin.resume()
	end, false, false)
	return function()
		connection:Disconnect()
	end
end

return PlaytestRejoin
