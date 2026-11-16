local Message = require(script.Parent.Message)
local TextChatServiceIntegration = {}

function TextChatServiceIntegration.mapTextChatMessage(p, p2: string)
	if p.TextSource then
		return Message.createUserMessageFromTextChatMessage(p, p2)
	end

	return Message.createSystemMessageFromTextChatMessage(p)
end

function TextChatServiceIntegration.mapSendingMessage(p, p2: string)
	return Message.createUserMessageFromTextChatMessage(p, p2)
end

function TextChatServiceIntegration.applyMessage(items, p)
	for k, item in items do
		if item.messageId == p.messageId then
			local clone = table.clone(items)

			if p.content == "" then
				table.remove(clone, k)
				return clone
			end

			clone[k] = p

			return clone
		end
	end

	if p.content == "" then
		return items
	end

	local clone = table.clone(items)
	table.insert(clone, p)
	return clone
end

return TextChatServiceIntegration
