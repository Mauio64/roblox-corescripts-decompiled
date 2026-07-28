local SuggestionType = require(script.Parent.Types).SuggestionType

return {
	createSmartSuggestionActionHandler = function(t1: {[any]: any}) -- line: 19
		-- upvalues: SuggestionType (copy)
		local t2 = {
			[SuggestionType.Message] = function(p1, s1: string) -- line: 23
				-- upvalues: t1 (copy)
				return t1.sendMessage(s1, p1.message.text)
			end,
			[SuggestionType.GameCard] = function(p2, s2: string) -- line: 26
				-- upvalues: t1 (copy)
				return t1.sendGameLinkChatMessage(s2, p2.game_card.universe_id)
			end
		}

		return function(p3, s3: string) -- line: 31
			-- upvalues: t2 (copy)
			local v10 = t2[p3.type]

			if not v10 then
				error(`SmartSuggestionActionHandler: unknown suggestion type "{ tostring(p3.type) }"`)
			end

			return v10(p3, s3)
		end
	end
}
