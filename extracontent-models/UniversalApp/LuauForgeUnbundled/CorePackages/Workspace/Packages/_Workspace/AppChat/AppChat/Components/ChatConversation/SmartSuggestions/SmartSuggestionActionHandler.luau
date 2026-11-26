local suggestionType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/Types").SuggestionType

return {
	createSmartSuggestionActionHandler = function(data)
		local v5 = {
			[suggestionType.Message] = function(p2, p3)
				return data.sendMessage(p3, p2.message.text)
			end,
			[suggestionType.GameCard] = function(p2, p3)
				return data.sendGameLinkChatMessage(p3, p2.game_card.universe_id)
			end,
			[suggestionType.StartParty] = function(p2, p3)
				return data.startParty(p3)
			end
		}

		return function(p2, p3)
			local v6 = v5[p2.type]

			if not v6 then
				error(`SmartSuggestionActionHandler: unknown suggestion type "{tostring(p2.type)}"`)
			end

			return v6(p2, p3)
		end
	end
}
