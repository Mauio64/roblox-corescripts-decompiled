local SuggestionType = require(script.Parent.Types).SuggestionType

return {
	createSmartSuggestionActionHandler = function(t1: {[any]: any}) -- line: 21
		-- upvalues: SuggestionType (copy)
		local t2 = {
			[SuggestionType.Message] = function(p1, s1: string) -- line: 25
				-- upvalues: t1 (copy)
				return t1.sendMessage(s1, p1.message.text)
			end,
			[SuggestionType.GameCard] = function(p2, s2: string) -- line: 28
				-- upvalues: t1 (copy)
				return t1.sendGameLinkChatMessage(s2, p2.game_card.universe_id)
			end,
			[SuggestionType.StartParty] = function(_, s3: string) -- line: 31
				-- upvalues: t1 (copy)
				return t1.startParty(s3)
			end
		}

		return function(p4, s4: string) -- line: 36
			-- upvalues: t2 (copy)
			local v12 = t2[p4.type]

			if not v12 then
				error(`SmartSuggestionActionHandler: unknown suggestion type "{ tostring(p4.type) }"`)
			end

			return v12(p4, s4)
		end
	end
}
