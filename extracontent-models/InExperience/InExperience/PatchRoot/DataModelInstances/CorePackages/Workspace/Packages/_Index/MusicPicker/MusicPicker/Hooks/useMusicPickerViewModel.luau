local MusicPicker = script:FindFirstAncestor("MusicPicker")
local parent = MusicPicker.Parent

local React = require(parent.React)

require(MusicPicker.Types.MusicPickerTypes)

local function useMusicPickerViewModel(data)
	local tabs = data.tabs
	local onQueryChanged = data.onQueryChanged
	local onTabChanged = data.onTabChanged

	local initialQuery = data.initialQuery or ""

	local state, setState = React.useState(initialQuery)

	local state2, setState2 = React.useState(initialQuery)
	local v

	if #tabs > 0 then
		v = tabs[1].id
	end

	local state3, setState3 = React.useState(v)

	React.useEffect(function()
		local v2 = false

		for _, tab in tabs do
			if tab.id == state3 then
				v2 = true
				break
			end
		end

		if not v2 then
			local v3

			if #tabs > 0 then
				v3 = tabs[1].id
			end

			setState3(v3)
		end
	end, { tabs, state3 })

	local onSearchChanged = React.useCallback(function(p: string)
		setState(p)

		if p == "" then
			setState2("")

			if onQueryChanged ~= nil then
				onQueryChanged("")
			end
		end
	end, { onQueryChanged })

	local onSubmitSearch = React.useCallback(function()
		if state == state2 then
			return
		end

		setState2(state)

		if onQueryChanged ~= nil then
			onQueryChanged(state)
		end
	end, { onQueryChanged, state, state2 })

	React.useEffect(function()
		if state == "" or state == state2 then
			return nil
		end

		local flag = false
		task.delay(0.3, function()
			if flag then
				return
			end

			setState2(state)

			if onQueryChanged ~= nil then
				onQueryChanged(state)
			end
		end)
		return function()
			flag = true
		end
	end, { state, state2, onQueryChanged })

	local onTabSelected = React.useCallback(function(p: string)
		setState3(p)

		if onTabChanged ~= nil then
			onTabChanged(p)
		end
	end, { onTabChanged })

	return {
		searchText = state,
		submittedQuery = state2,
		mode = state2 == "" and "tabs" or "search",
		activeTabId = state3,
		onSearchChanged = onSearchChanged,
		onSubmitSearch = onSubmitSearch,
		onTabSelected = onTabSelected
	}
end

return useMusicPickerViewModel
