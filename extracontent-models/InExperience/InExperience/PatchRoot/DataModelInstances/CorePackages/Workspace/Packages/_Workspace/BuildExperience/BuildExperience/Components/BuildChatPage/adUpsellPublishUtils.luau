local BuildExperience = script:FindFirstAncestor("BuildExperience")

local chatTypes = require(BuildExperience.Chat.chatTypes)

local function getMessageKey(item) -- 1 equivalent call inferred from this helper
	if item.kind == "assistant_turn" then
		local assistantTurnAnchorKey = chatTypes.makeAssistantTurnAnchorKey(item.sessionId, item.endSequenceId)

		if assistantTurnAnchorKey ~= nil then
			return assistantTurnAnchorKey
		end

		if item.turnKey ~= nil then
			return `turn:{item.turnKey}`
		end
	end

	if item.id == nil then
		return nil
	end

	return `message:{item.id}`
end

local AdUpsellPublishUtils = {}
AdUpsellPublishUtils.getMessageKey = getMessageKey

function AdUpsellPublishUtils.getMessageIndexByKey(items)
	local messageIndex = {}

	for k, item in items do
		local messageKey = getMessageKey(item) -- inferred equivalent call

		if messageKey ~= nil then
			messageIndex[messageKey] = k
		end
	end

	return messageIndex
end

function AdUpsellPublishUtils.getLastMessageKey(list)
	for i = #list, 1, -1 do
		local item = list[i]
		local v

		if item.kind == "assistant_turn" then
			v = not item.isDone or item.isOptimisticallyCancelled == true
		elseif item.id == nil then
			v = false
		else
			v = string.sub(item.id, -#chatTypes.PENDING_USER_MESSAGE_ID_SUFFIX) == chatTypes.PENDING_USER_MESSAGE_ID_SUFFIX
		end

		local v2

		if not v then
			if item.kind == "assistant_turn" then
				v2 = chatTypes.makeAssistantTurnAnchorKey(item.sessionId, item.endSequenceId)

				if v2 == nil then
					if item.turnKey == nil then
						if item.id == nil then
							v2 = nil
						else
							v2 = `message:{item.id}`
						end
					else
						v2 = `turn:{item.turnKey}`
					end
				end
			elseif item.id ~= nil then
				v2 = `message:{item.id}`
			end
		end

		if v2 ~= nil then
			return v2
		end
	end

	return nil
end

return AdUpsellPublishUtils
