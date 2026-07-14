local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local SmartSuggestionActionHandler = require(script.Parent.SmartSuggestionActionHandler)
local SuggestionType = SmartSuggestionActionHandler.SuggestionType
local createSmartSuggestionActionHandler = SmartSuggestionActionHandler.createSmartSuggestionActionHandler
local t1 = {
	{
		display_text = "Sounds good!",
		type = SuggestionType.Message,
		message = {
			text = "Sounds good!"
		}
	},
	{
		display_text = "On my way",
		type = SuggestionType.Message,
		message = {
			text = "On my way"
		}
	},
	{
		display_text = "Let's play later",
		type = SuggestionType.Message,
		message = {
			text = "Let's play later"
		}
	},
	{
		display_text = "Share a game",
		type = SuggestionType.GameCard,
		game_card = {
			universe_id = 1537690962
		}
	}
}

local function useSmartSuggestions(s1: string, p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 53
	-- upvalues: React (copy), createSmartSuggestionActionHandler (copy), Cryo (copy), t1 (copy)
	local v12 = React.useMemo(function() -- line: 58
		-- upvalues: createSmartSuggestionActionHandler (copy), p1 (copy), p2 (copy)
		return createSmartSuggestionActionHandler({
			sendMessage = p1,
			sendGameLinkChatMessage = p2
		})
	end, {
		p1,
		p2
	})
	local v13, v14 = React.useState(function() -- line: 65
		return {}
	end)
	local v15 = React.useCallback(function(p3) -- line: 69
		-- upvalues: v14 (copy), Cryo (copy), v12 (copy), s1 (copy)
		v14(function(t2: {[any]: any}) -- line: 71
			-- upvalues: Cryo (copy), p3 (copy)
			return Cryo.Dictionary.join(t2, {
				[p3] = true
			})
		end)

		local v17 = v12(p3, s1)

		if typeof(v17) == "table" and typeof(v17.catch) == "function" then
			v17:catch(function() -- line: 78
				-- upvalues: v14 (copy), Cryo (copy), p3 (copy)
				v14(function(t3: {[any]: any}) -- line: 79
					-- upvalues: Cryo (copy), p3 (copy)
					return Cryo.Dictionary.join(t3, {
						[p3] = Cryo.None
					})
				end)
			end)
		end
	end, {
		v12,
		s1
	})

	return {
		isLoading = false,
		suggestions = t1,
		hiddenSuggestions = v13,
		onActivated = v15
	}
end

return useSmartSuggestions
