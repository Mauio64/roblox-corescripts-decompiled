local HttpService = game:GetService("HttpService")

local parent = script.Parent.Parent
local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local t = require(parent.t)
local Cryo = require(parent.Cryo)
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

require(script.Parent.GameProtocolTypes)

local GetFFlagMoveLuaExpLaunchBegin = require(script.Parent.Flags.GetFFlagMoveLuaExpLaunchBegin)

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

local function checkRequiredParams(p)
	return p.placeId or p.userId
end

local GameProtocol = {
	GAME_LAUNCH_DESCRIPTOR = {
		mid = messageBus.getMessageId("Game", "launch"),
		validateParams = t.intersection(strictInterface, checkRequiredParams)
	}
}

GameProtocol.__index = GameProtocol

function GameProtocol.new()
	return (setmetatable({ subscriber = messageBus.Subscriber.new() }, GameProtocol))
end

function GameProtocol.launchGame(p, state, joinAttemptOrigin: string?, callback)
	if type(state.placeId) == "string" then
		state.placeId = tonumber(state.placeId)
	end

	if type(state.userId) == "string" then
		state.userId = tonumber(state.userId)
	end

	local joinAttemptId

	if state.joinAttemptId == nil then
		joinAttemptId = HttpService:GenerateGUID(false)
	else
		joinAttemptId = state.joinAttemptId
	end

	local join = Cryo.Dictionary.join

	if joinAttemptOrigin == nil then
		joinAttemptOrigin = state.joinAttemptOrigin
	end

	local v = join(state, { joinAttemptId = joinAttemptId, joinAttemptOrigin = joinAttemptOrigin })

	if callback then
		callback(joinAttemptId)
	end

	if GetFFlagMoveLuaExpLaunchBegin() then
		default:logEvent("experience_launch_begin")
	end

	messageBus.publish(p.GAME_LAUNCH_DESCRIPTOR, v)
end

GameProtocol.default = GameProtocol.new()

return GameProtocol
