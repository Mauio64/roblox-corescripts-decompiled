local module = require("@luauforge/bundled/fzS")
local module2 = require("@luauforge/bundled/hMx")
local module3 = require("@luauforge/bundled/hMy")

local v5 = {
	suggestionsShown = "usernameSuggestionsShown",
	suggestableInput = "suggestableUsernameInput",
	refreshButton = "usernameSuggestionRefreshButton"
}

local function shouldSuggest(items)
	local v6

	if items then
		v6 = items[module2.AlreadyInUse] == module3.Problematic

		for k, item in pairs(items) do
			if k ~= module2.AlreadyInUse and item == module3.Problematic then
				return false
			end
		end
	else
		v6 = false
	end

	return v6
end

local function createUsernameSuggestionHandlers(data)
	return {
		usernameSuggestionClicked = function(p2, p3)
			data.getAuthEventAnalytics().reportUsernameSuggestionClicked(
				module.Context.SinglePageSignUpScreen,
				module.Button.UsernameSuggestion,
				p2,
				p3
			)
		end,
		logRefreshButtonClicked = function()
			data.getAuthEventAnalytics().reportButtonClicked(
				module.Context.SinglePageSignUpScreen,
				"usernameSuggestionRefreshButton"
			)
		end,
		usernameSuggestionsShown = function(p2, p3)
			data.getAuthEventAnalytics().reportInteractWithActionAndSection(
				module.Context.SinglePageSignUpScreen,
				module.Field.Username,
				module.ActionType.Shown,
				"usernameSuggestionsShown",
				p2,
				p3
			)
		end,
		logSuggestableUsername = function(p2)
			data.getAuthEventAnalytics().reportInteractWithAction(
				module.Context.SinglePageSignUpScreen,
				module.Field.Username,
				module.ActionType.Shown,
				"suggestableUsernameInput",
				p2
			)
		end,
		shouldSuggest = function()
			return shouldSuggest(data.getIssueCondition())
		end,
		updatePillClicked = function()
			data.updateState({ pillClicked = true })
		end,
		resetPillClicked = function()
			data.updateState({ pillClicked = false })
		end,
		updateIssueCondition = function(p2)
			data.updateState({ issueCondition = p2 })
		end,
		updateSuggestionControlState = function(p2, p3)
			data.updateState({ suggestionControlState = p3 })
		end,
		loadSuggestions = function()
			data.updateState({ loadingSuggestions = true })
		end,
		finishSuggestions = function()
			data.updateState({ loadingSuggestions = false })
		end
	}
end

return createUsernameSuggestionHandlers
