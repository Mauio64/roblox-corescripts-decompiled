local CorePackages = game:GetService("CorePackages")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local v5 = logger.new(logger, "SendGameLinkMessagePolicy")

local module = require("@luauforge/deferred/gHP")
local DEPRECATED_ChatSendGameLinkMessage = require("@game/CorePackages/Workspace/Packages/Http").Requests.DEPRECATED_ChatSendGameLinkMessage
local module2 = require("@luauforge/deferred/gHQ")

local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDefaultHttpRetry
local HttpRequest = require(CorePackages.Packages.HttpRequest)
local config = HttpRequest.config
local v6 = {
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	maxRetryCount = 0
}

local v7 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt(
	"SendGameLinkMessagePolicyHttpRetryCount",
	4
) else nil
v6.maxRetryCount = v7
local v8 = config(v6)

local object = setmetatable({}, module2)
object.__index = object

function object.new(p2, p3, universeId, decorators, isExperienceInvite, userId, placeId)
	local v9 = module2:new(p3, nil)
	setmetatable(v9, p2)

	v9.universeId = universeId
	v9.decorators = decorators
	v9.isExperienceInvite = isExperienceInvite
	v9.userId = userId
	v9.placeId = placeId

	return v9
end

function object.sendMessage(data, p2)
	return DEPRECATED_ChatSendGameLinkMessage(
		v8,
		data.conversationId,
		data.universeId,
		data.decorators,
		data.isExperienceInvite or false,
		data.userId or 0,
		data.placeId or 0
	)
end

function object.sendingMessagePayload(p2)
	return {
		messageType = module.MessageTypes.Link,
		link = {
			type = module.LinkTypes.Game,
			game = { universeId = p2.universeId }
		}
	}
end

return object
