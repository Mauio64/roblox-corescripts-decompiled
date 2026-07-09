local CorePackages = game:GetService("CorePackages")
local v2 = require(CorePackages.Workspace.Packages.Loggers).Logger:new("SendGameLinkMessagePolicy")
local MessageModel = require(CorePackages.Workspace.Packages.AppChat.MessageModel)
local DEPRECATED_ChatSendGameLinkMessage = require(CorePackages.Workspace.Packages.Http).Requests.DEPRECATED_ChatSendGameLinkMessage
local SendChatMessagePolicy = require(CorePackages.Workspace.Packages.AppChat.SendChatMessagePolicy)
local FFlagLuaAppDefaultHttpRetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDefaultHttpRetry
local HttpRequest = require(CorePackages.Packages.HttpRequest)
local v8 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 15
		-- upvalues: v2 (copy), HttpRequest (copy)
		v2:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("SendGameLinkMessagePolicyHttpRetryCount", 4)
})
local self = setmetatable({}, SendChatMessagePolicy)

self.__index = self

function self.new(t1: {[any]: any}, p4, p5, p6, b1: boolean?, n1: number?, n2: number?) -- line: 27
	-- upvalues: SendChatMessagePolicy (copy)
	local v20 = SendChatMessagePolicy:new(p4, nil)

	setmetatable(v20, t1)
	v20.universeId = p5
	v20.decorators = p6
	v20.isExperienceInvite = b1
	v20.userId = n1
	v20.placeId = n2

	return v20
end
function self.sendMessage(p7, _) -- line: 47
	-- upvalues: DEPRECATED_ChatSendGameLinkMessage (copy), v8 (copy)
	return DEPRECATED_ChatSendGameLinkMessage(v8, p7.conversationId, p7.universeId, p7.decorators, p7.isExperienceInvite or false, p7.userId or 0, p7.placeId or 0)
end
function self.sendingMessagePayload(p9) -- line: 59
	-- upvalues: MessageModel (copy)
	return {
		messageType = MessageModel.MessageTypes.Link,
		link = {
			type = MessageModel.LinkTypes.Game,
			game = {
				universeId = p9.universeId
			}
		}
	}
end

return self
