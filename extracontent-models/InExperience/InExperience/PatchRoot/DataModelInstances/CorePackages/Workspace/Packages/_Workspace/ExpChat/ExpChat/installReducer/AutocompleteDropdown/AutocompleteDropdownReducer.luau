local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local AutocompleteDropdownActivated = require(Actions.AutocompleteDropdownActivated)
local AutocompleteDropdownResultsChanged = require(Actions.AutocompleteDropdownResultsChanged)
local AutocompleteDropdownSelectionChanged = require(Actions.AutocompleteDropdownSelectionChanged)
local AutocompleteDropdownTypeChanged = require(Actions.AutocompleteDropdownTypeChanged)
local AutocompleteDropdownDeactivated = require(Actions.AutocompleteDropdownDeactivated)

return Rodux.createReducer({
	activated = false,
	results = {},
	query = "",
	selectedIndex = 1,
	autocompleteType = "none"
}, {
	[AutocompleteDropdownActivated.name] = function(p, p2)
		return dictionary.join(p, { activated = p2.activated })
	end,
	[AutocompleteDropdownResultsChanged.name] = function(p, p2)
		return dictionary.join(p, {
			results = p2.results,
			query = p2.query or "",
			selectedIndex = 1
		})
	end,
	[AutocompleteDropdownSelectionChanged.name] = function(p, p2)
		return dictionary.join(p, { selectedIndex = p2.selectedIndex })
	end,
	[AutocompleteDropdownTypeChanged.name] = function(p, p2)
		if p2.autocompleteType == p.autocompleteType then
			return p
		end

		return dictionary.join(p, {
			autocompleteType = p2.autocompleteType,
			activated = false,
			results = {},
			query = "",
			selectedIndex = 1
		})
	end,
	[AutocompleteDropdownDeactivated.name] = function(p, _)
		return dictionary.join(p, {
			autocompleteType = "none",
			activated = false,
			results = {},
			query = "",
			selectedIndex = 1
		})
	end
})
