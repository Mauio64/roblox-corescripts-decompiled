local parent = script.Parent.Parent
require(parent.ChatUIPrimitives)

local _ = { Pending = "pending", Failed = "failed" }

local HttpService = game:GetService("HttpService")
local SharedFlags = require(parent.SharedFlags)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local getTextAndTranslation = require(script.Parent.getTextAndTranslation)

local function createUserMessage(data)
	return {
		messageType = "user",
		messageId = data.messageId,
		senderUserId = data.senderUserId,
		content = data.content,
		prefixText = data.prefixText,
		timestamp = data.timestamp,
		isOutgoing = data.isOutgoing,
		status = data.status,
		wasRewritten = data.wasRewritten,
		originalText = data.originalText,
		translation = data.translation,
		textChatMessageInstance = data.textChatMessageInstance,
		presetId = data.presetId
	}
end

local Message = {}

function Message.markHistorical(p)
	local clone = table.clone(p)
	clone.isHistorical = true
	return clone
end

function Message.createSystemMessage(content: string, p: string?)
	return {
		messageId = p or HttpService:GenerateGUID(false),
		messageType = "system-roblox",
		content = content,
		timestamp = DateTime.now()
	}
end

function Message.createExperienceSystemMessage(content: string, p: string?, iconName: string?)
	return {
		messageId = p or HttpService:GenerateGUID(false),
		messageType = "system-experience",
		content = content,
		iconName = iconName,
		timestamp = DateTime.now()
	}
end

function Message.createSystemMessageFromTextChatMessage(textChatMessageInstance)
	local systemMessageFromTextChatMessage = {
		messageId = textChatMessageInstance.MessageId,
		messageType = "system-roblox",
		content = 0,
		timestamp = 0,
		textChatMessageInstance = 0
	}
	local content

	if getFFlagExpChatProtectedChatInternalAPIs() then
		content = textChatMessageInstance.TextInternal
	else
		content = textChatMessageInstance.Text
	end

	systemMessageFromTextChatMessage.content = content
	systemMessageFromTextChatMessage.timestamp = textChatMessageInstance.Timestamp
	systemMessageFromTextChatMessage.textChatMessageInstance = textChatMessageInstance
	return systemMessageFromTextChatMessage
end

Message.createUserMessage = createUserMessage

function Message.createUserMessageFromTextChatMessage(textChatMessageInstance, p: string)
	local textSource = textChatMessageInstance.TextSource

	local textAndTranslation, translation = getTextAndTranslation(textChatMessageInstance)
	local v = {
		messageId = textChatMessageInstance.MessageId,
		senderUserId = tostring(textSource.UserId),
		prefixText = 0,
		content = 0,
		translation = 0,
		wasRewritten = 0,
		originalText = 0,
		timestamp = 0,
		isOutgoing = 0,
		status = nil,
		textChatMessageInstance = 0,
		presetId = 0
	}
	local prefixText

	if getFFlagExpChatProtectedChatInternalAPIs() then
		prefixText = textChatMessageInstance.PrefixTextInternal
	else
		prefixText = textChatMessageInstance.PrefixText
	end

	v.prefixText = prefixText

	v.content = textAndTranslation
	v.translation = translation
	v.wasRewritten = textChatMessageInstance.WasRewritten and true or nil
	local originalText

	if textChatMessageInstance.WasRewritten then
		originalText = textChatMessageInstance.OriginalText
	end

	v.originalText = originalText
	v.timestamp = textChatMessageInstance.Timestamp
	v.isOutgoing = tostring(textSource.UserId) == p

	v.textChatMessageInstance = textChatMessageInstance
	local presetId

	if game:GetEngineFeature("TextChatPresetsEnabled") then
		presetId = textChatMessageInstance.PresetId
	end

	v.presetId = presetId
	return createUserMessage(v)
end

return Message
