local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local AutocompleteDropdownActivated = require(Actions.AutocompleteDropdownActivated)
local AutocompleteDropdownResultsChanged = require(Actions.AutocompleteDropdownResultsChanged)
local AutocompleteDropdownSelectionChanged = require(Actions.AutocompleteDropdownSelectionChanged)
local AutocompleteDropdownTypeChanged = require(Actions.AutocompleteDropdownTypeChanged)
local AutocompleteDropdownDeactivated = require(Actions.AutocompleteDropdownDeactivated)
local t1 = {
	activated = false,
	selectedIndex = 1,
	autocompleteType = "none",
	results = {}
}

return Rodux.createReducer(t1, {
	[AutocompleteDropdownActivated.name] = function(t2: {[any]: any}, p1) -- line: 28
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t2, {
			activated = p1.activated
		})
	end,
	[AutocompleteDropdownResultsChanged.name] = function(t3: {[any]: any}, p2) -- line: 31
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t3, {
			selectedIndex = 1,
			results = p2.results
		})
	end,
	[AutocompleteDropdownSelectionChanged.name] = function(t4: {[any]: any}, p3) -- line: 40
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t4, {
			selectedIndex = p3.selectedIndex
		})
	end,
	[AutocompleteDropdownTypeChanged.name] = function(t5: {[any]: any}, p4) -- line: 46
		-- upvalues: Dictionary (copy)
		if p4.autocompleteType ~= t5.autocompleteType then
			return Dictionary.join(t5, {
				activated = false,
				selectedIndex = 1,
				autocompleteType = p4.autocompleteType,
				results = {}
			})
		end

		return t5
	end,
	[AutocompleteDropdownDeactivated.name] = function(t6: {[any]: any}, _) -- line: 57
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t6, {
			autocompleteType = "none",
			activated = false,
			selectedIndex = 1,
			results = {}
		})
	end
})
