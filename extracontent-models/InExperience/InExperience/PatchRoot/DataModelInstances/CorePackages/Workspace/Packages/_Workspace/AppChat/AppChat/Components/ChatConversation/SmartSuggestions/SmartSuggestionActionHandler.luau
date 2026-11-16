local Types = require(script.Parent.Types)

local SuggestionType = Types.SuggestionType

return {
	createSmartSuggestionActionHandler = function(data)
		local v = {
			[SuggestionType.Message] = function(p, p2: string)
				return data.sendMessage(p2, p.message.text)
			end,
			[SuggestionType.GameCard] = function(p, p2: string)
				return data.sendGameLinkChatMessage(p2, p.game_card.universe_id)
			end,
			[SuggestionType.StartParty] = function(_, p: string)
				return data.startParty(p)
			end
		}

		return function(p, p2: string)
			local v2 = v[p.type]

			if not v2 then
				error(`SmartSuggestionActionHandler: unknown suggestion type "{tostring(p.type)}"`)
			end

			return v2(p, p2)
		end
	end
}
