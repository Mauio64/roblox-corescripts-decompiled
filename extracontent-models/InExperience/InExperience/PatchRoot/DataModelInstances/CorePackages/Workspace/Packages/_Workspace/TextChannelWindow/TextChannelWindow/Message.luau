local ParentParent = script.Parent.Parent

require(ParentParent.ChatUIPrimitives)

local _ = {
	Pending = "pending",
	Failed = "failed"
}
local HttpService = game:GetService("HttpService")
local getFFlagExpChatProtectedChatInternalAPIs = require(ParentParent.SharedFlags).getFFlagExpChatProtectedChatInternalAPIs
local getTextAndTranslation = require(script.Parent.getTextAndTranslation)

local function createUserMessage(t1: {[any]: any}) -- line: 71
	return {
		messageType = "user",
		messageId = t1.messageId,
		senderUserId = t1.senderUserId,
		content = t1.content,
		prefixText = t1.prefixText,
		timestamp = t1.timestamp,
		isOutgoing = t1.isOutgoing,
		status = t1.status,
		wasRewritten = t1.wasRewritten,
		originalText = t1.originalText,
		textChatMessageInstance = t1.textChatMessageInstance
	}
end

return {
	createSystemMessage = function(s1: string, s2: string?) -- line: 37
		-- upvalues: HttpService (copy)
		return {
			messageType = "system-roblox",
			messageId = s2 or HttpService:GenerateGUID(false),
			content = s1,
			timestamp = DateTime.now()
		}
	end,
	createSystemMessageFromTextChatMessage = function(p1) -- line: 48
		-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy)
		return {
			messageType = "system-roblox",
			messageId = p1.MessageId,
			content = if not getFFlagExpChatProtectedChatInternalAPIs() then p1.Text else p1.TextInternal,
			timestamp = p1.Timestamp,
			textChatMessageInstance = p1
		}
	end,
	createUserMessage = createUserMessage,
	createUserMessageFromTextChatMessage = function(p2, s3: string) -- line: 87
		-- upvalues: createUserMessage (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), getTextAndTranslation (copy)
		local TextSource = p2.TextSource

		return (createUserMessage({
			status = nil,
			messageId = p2.MessageId,
			senderUserId = tostring(TextSource.UserId),
			prefixText = if not getFFlagExpChatProtectedChatInternalAPIs() then p2.PrefixText else p2.PrefixTextInternal,
			content = getTextAndTranslation(p2),
			wasRewritten = not not p2.WasRewritten or nil,
			originalText = if not p2.WasRewritten then nil else p2.OriginalText,
			timestamp = p2.Timestamp,
			isOutgoing = s3 == tostring(TextSource.UserId),
			textChatMessageInstance = p2
		}))
	end
}
