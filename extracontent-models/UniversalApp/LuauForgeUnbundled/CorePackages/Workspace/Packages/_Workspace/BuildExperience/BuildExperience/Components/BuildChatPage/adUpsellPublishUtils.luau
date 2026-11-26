local chatTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

return {
	getMessageKey = function(data)
		if data.kind == "assistant_turn" then
			local assistantTurnAnchorKey = chatTypes.makeAssistantTurnAnchorKey(
				data.sessionId,
				data.endSequenceId
			)

			if assistantTurnAnchorKey ~= nil then
				return assistantTurnAnchorKey
			end

			if data.turnKey ~= nil then
				return `turn:{data.turnKey}`
			end
		end

		if data.id == nil then
			return nil
		end

		return `message:{data.id}`
	end,
	getMessageIndexByKey = function(items)
		local messageIndex = {}

		for k, item in items do
			local v5

			if item.kind == "assistant_turn" then
				v5 = chatTypes.makeAssistantTurnAnchorKey(item.sessionId, item.endSequenceId)

				if v5 == nil then
					if item.turnKey == nil then
						v5 = if item.id ~= nil then `message:{item.id}` else nil
					else
						v5 = `turn:{item.turnKey}`
					end
				end
			elseif item.id ~= nil then
				v5 = `message:{item.id}`
			end

			if v5 ~= nil then
				messageIndex[v5] = k
			end
		end

		return messageIndex
	end,
	getLastMessageKey = function(list)
		for i = #list, 1, -1 do
			local item = list[i]
			local v5

			if item.kind == "assistant_turn" then
				v5 = not item.isDone or item.isOptimisticallyCancelled == true
			elseif item.id == nil then
				v5 = false
			else
				v5 = string.sub(item.id, -#chatTypes.PENDING_USER_MESSAGE_ID_SUFFIX) == chatTypes.PENDING_USER_MESSAGE_ID_SUFFIX
			end

			local v6

			if not v5 then
				if item.kind == "assistant_turn" then
					v6 = chatTypes.makeAssistantTurnAnchorKey(item.sessionId, item.endSequenceId)

					if v6 == nil then
						if item.turnKey == nil then
							v6 = if item.id ~= nil then `message:{item.id}` else nil
						else
							v6 = `turn:{item.turnKey}`
						end
					end
				elseif item.id ~= nil then
					v6 = `message:{item.id}`
				end
			end

			if v6 ~= nil then
				return v6
			end
		end

		return nil
	end
}
