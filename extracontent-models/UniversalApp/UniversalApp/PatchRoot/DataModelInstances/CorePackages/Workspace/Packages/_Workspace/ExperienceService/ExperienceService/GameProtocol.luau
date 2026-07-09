local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent
local MessageBus = require(ParentParent.MessageBus).MessageBus
local t = require(ParentParent.t)
local Cryo = require(ParentParent.Cryo)
local default = require(ParentParent.LoggingProtocol).default

require(script.Parent.GameProtocolTypes)

local GetFFlagMoveLuaExpLaunchBegin = require(script.Parent.Flags.GetFFlagMoveLuaExpLaunchBegin)
local v8 = t.strictInterface({
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

local function checkRequiredParams(p1) -- line: 45
	return p1.placeId or p1.userId
end

local t1 = {
	GAME_LAUNCH_DESCRIPTOR = {
		mid = MessageBus.getMessageId("Game", "launch"),
		validateParams = t.intersection(v8, checkRequiredParams)
	}
}

t1.__index = t1

function t1.new() -- line: 57
	-- upvalues: MessageBus (copy), t1 (copy)
	return (setmetatable({
		subscriber = MessageBus.Subscriber.new()
	}, t1))
end
function t1.launchGame(t2: {[any]: any}, p2, s1: string?, p3: ((...any) -> ...any)?) -- line: 64
	-- upvalues: HttpService (copy), Cryo (copy), GetFFlagMoveLuaExpLaunchBegin (copy), default (copy), MessageBus (copy)
	if type(p2.placeId) == "string" then
		p2.placeId = tonumber(p2.placeId)
	end

	if type(p2.userId) == "string" then
		p2.userId = tonumber(p2.userId)
	end

	local v16 = if p2.joinAttemptId == nil then HttpService:GenerateGUID(false) else p2.joinAttemptId
	local v17 = Cryo.Dictionary.join(p2, {
		joinAttemptId = v16,
		joinAttemptOrigin = if s1 == nil then p2.joinAttemptOrigin else s1
	})

	if p3 then
		p3(v16)
	end

	if GetFFlagMoveLuaExpLaunchBegin() then
		default:logEvent("experience_launch_begin")
	end

	MessageBus.publish(t2.GAME_LAUNCH_DESCRIPTOR, v17)
end

t1.default = t1.new()

return t1
