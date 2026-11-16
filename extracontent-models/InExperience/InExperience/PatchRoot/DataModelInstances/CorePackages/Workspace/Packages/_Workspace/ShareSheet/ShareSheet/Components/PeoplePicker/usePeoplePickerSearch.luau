local parent = script:FindFirstAncestor("ShareSheet").Parent

local React = require(parent.React)

local defineFastInt = game:DefineFastInt("ShareSheetPeoplePickerSearchDebounceMs", 250)

local function usePeoplePickerSearch()
	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")

	React.useEffect(function()
		if state == state2 then
			return
		end

		local v = false
		local thread = task.delay(defineFastInt / 1000, function()
			if not v then
				setState2(state)
			end
		end)
		return function()
			v = true
			pcall(task.cancel, thread)
		end
	end, { state2, state })

	return {
		debouncedQuery = state2,
		query = state,
		reset = React.useCallback(function()
			setState("")
			setState2("")
		end, {}),
		setQuery = setState
	}
end

return usePeoplePickerSearch
