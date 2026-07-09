local t1 = {
	Message = "message",
	GameCard = "game_card"
}

return {
	SuggestionType = t1,
	createSmartSuggestionActionHandler = function(t2: {[any]: any}) -- line: 44
		-- upvalues: t1 (copy)
		local t5 = {
			[t1.Message] = function(t3: {[any]: any}, s1: string) -- line: 48
				-- upvalues: t2 (copy)
				return t2.sendMessage(s1, t3.message.text)
			end,
			[t1.GameCard] = function(t4: {[any]: any}, s2: string) -- line: 51
				-- upvalues: t2 (copy)
				return t2.sendGameLinkChatMessage(s2, t4.game_card.universe_id)
			end
		}

		return function(p1, s3: string) -- line: 56
			-- upvalues: t5 (copy)
			local v10 = t5[p1.type]

			if not v10 then
				error(`SmartSuggestionActionHandler: unknown suggestion type "{ tostring(p1.type) }"`)
			end

			return v10(p1, s3)
		end
	end
}
