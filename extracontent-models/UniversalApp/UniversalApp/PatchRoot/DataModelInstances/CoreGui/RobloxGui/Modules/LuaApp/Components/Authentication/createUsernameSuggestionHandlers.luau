local Modules = game:GetService("CoreGui").RobloxGui.Modules
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local UsernameIssue = require(Modules.LuaApp.Components.Authentication.Enum.UsernameIssue)
local IssueCondition = require(Modules.LuaApp.Components.Authentication.Enum.IssueCondition)
local _ = {
	suggestionsShown = "usernameSuggestionsShown",
	suggestableInput = "suggestableUsernameInput",
	refreshButton = "usernameSuggestionRefreshButton"
}

local function shouldSuggest(t1: {[any]: any}?) -- line: 19
	-- upvalues: UsernameIssue (copy), IssueCondition (copy)
	local v9 = false

	if t1 then
		v9 = t1[UsernameIssue.AlreadyInUse] == IssueCondition.Problematic

		for k, v in pairs(t1) do
			if k ~= UsernameIssue.AlreadyInUse and v == IssueCondition.Problematic then
				return false
			end
		end
	end

	return v9
end
local function createUsernameSuggestionHandlers(t2: {[any]: any}) -- line: 34
	-- upvalues: EventStreamConstants (copy), shouldSuggest (copy)
	return {
		usernameSuggestionClicked = function(p1, p2) -- line: 36
			-- upvalues: t2 (copy), EventStreamConstants (copy)
			t2.getAuthEventAnalytics().reportUsernameSuggestionClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.UsernameSuggestion, p1, p2)
		end,
		logRefreshButtonClicked = function() -- line: 46
			-- upvalues: t2 (copy), EventStreamConstants (copy)
			t2.getAuthEventAnalytics().reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, "usernameSuggestionRefreshButton")
		end,
		usernameSuggestionsShown = function(p3, p4) -- line: 54
			-- upvalues: t2 (copy), EventStreamConstants (copy)
			t2.getAuthEventAnalytics().reportInteractWithActionAndSection(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.Username, EventStreamConstants.ActionType.Shown, "usernameSuggestionsShown", p3, p4)
		end,
		logSuggestableUsername = function(p5) -- line: 66
			-- upvalues: t2 (copy), EventStreamConstants (copy)
			t2.getAuthEventAnalytics().reportInteractWithAction(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.Username, EventStreamConstants.ActionType.Shown, "suggestableUsernameInput", p5)
		end,
		shouldSuggest = function() -- line: 77
			-- upvalues: shouldSuggest (copy), t2 (copy)
			return (shouldSuggest(t2.getIssueCondition()))
		end,
		updatePillClicked = function() -- line: 81
			-- upvalues: t2 (copy)
			t2.updateState({
				pillClicked = true
			})
		end,
		resetPillClicked = function() -- line: 87
			-- upvalues: t2 (copy)
			t2.updateState({
				pillClicked = false
			})
		end,
		updateIssueCondition = function(p6) -- line: 93
			-- upvalues: t2 (copy)
			t2.updateState({
				issueCondition = p6
			})
		end,
		updateSuggestionControlState = function(_, p8) -- line: 99
			-- upvalues: t2 (copy)
			t2.updateState({
				suggestionControlState = p8
			})
		end,
		loadSuggestions = function() -- line: 105
			-- upvalues: t2 (copy)
			t2.updateState({
				loadingSuggestions = true
			})
		end,
		finishSuggestions = function() -- line: 109
			-- upvalues: t2 (copy)
			t2.updateState({
				loadingSuggestions = false
			})
		end
	}
end

return createUsernameSuggestionHandlers
