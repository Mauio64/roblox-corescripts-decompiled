local HttpService = game:GetService("HttpService")

local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/MessageBus").MessageBus
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/t")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/Cryo")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/LoggingProtocol").default

require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/ExperienceService/GameProtocolTypes")

local GetFFlagMoveLuaExpLaunchBegin = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/ExperienceService/Flags/GetFFlagMoveLuaExpLaunchBegin")

local strictInterface = t.strictInterface({
	placeId = t.optional(t.number),
	userId = t.optional(t.number),
	accessCode = t.optional(t.string),
	gameInstanceId = t.optional(t.string),
	linkCode = t.optional(t.string),
	referralPage = t.optional(t.string),
	launchData = t.optional(t.string),
	eventId = t.optional(t.string),
	referredByPlayerId = t.optional(t.number),
	joinAttemptOrigin = t.optional(t.string),
	joinAttemptId = t.string
})

local function checkRequiredParams(p2)
	return p2.placeId or p2.userId
end

local v5 = {
	GAME_LAUNCH_DESCRIPTOR = {
		mid = messageBus.getMessageId("Game", "launch"),
		validateParams = t.intersection(strictInterface, checkRequiredParams)
	}
}

v5.__index = v5

function v5.new()
	return (setmetatable({ subscriber = messageBus.Subscriber.new() }, v5))
end

function v5.launchGame(p2, state, joinAttemptOrigin, callback)
	if type(state.placeId) == "string" then
		state.placeId = tonumber(state.placeId)
	end

	if type(state.userId) == "string" then
		state.userId = tonumber(state.userId)
	end

	local v6

	if state.joinAttemptId == nil then
		v6 = HttpService:GenerateGUID(false)
	else
		v6 = state.joinAttemptId
	end

	local join = Cryo.Dictionary.join

	if joinAttemptOrigin == nil then
		joinAttemptOrigin = state.joinAttemptOrigin
	end

	local v8 = join(state, { joinAttemptId = v6, joinAttemptOrigin = joinAttemptOrigin })

	if callback then
		callback(v6)
	end

	if GetFFlagMoveLuaExpLaunchBegin() then
		default:logEvent("experience_launch_begin")
	end

	messageBus.publish(p2.GAME_LAUNCH_DESCRIPTOR, v8)
end

v5.default = v5.new()

return v5
