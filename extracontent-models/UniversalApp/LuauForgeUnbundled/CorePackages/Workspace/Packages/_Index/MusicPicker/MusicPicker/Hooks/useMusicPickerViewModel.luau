local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/React")

require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Types/MusicPickerTypes")

local function useMusicPickerViewModel(data)
	local tabs = data.tabs
	local onQueryChanged = data.onQueryChanged
	local onTabChanged = data.onTabChanged

	local initialQuery = data.initialQuery or ""

	local state, setState = React.useState(initialQuery)

	local state2, setState2 = React.useState(initialQuery)
	local v5 = if #tabs > 0 then tabs[1].id else nil
	local state3, setState3 = React.useState(v5)

	React.useEffect(function()
		local v6 = false

		for k, tab in tabs do
			if tab.id == state3 then
				v6 = true
				break
			end
		end

		if not v6 then
			local v9 = if #tabs > 0 then tabs[1].id else nil
			setState3(v9)
		end
	end, { tabs, state3 })

	local v6 = React.useCallback(function(p2)
		setState(p2)

		if p2 == "" then
			setState2("")

			if onQueryChanged ~= nil then
				onQueryChanged("")
			end
		end
	end, { onQueryChanged })

	local v7 = React.useCallback(function()
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

	local v8 = React.useCallback(function(p2)
		setState3(p2)

		if onTabChanged ~= nil then
			onTabChanged(p2)
		end
	end, { onTabChanged })

	return {
		searchText = state,
		submittedQuery = state2,
		mode = state2 == "" and "tabs" or "search",
		activeTabId = state3,
		onSearchChanged = v6,
		onSubmitSearch = v7,
		onTabSelected = v8
	}
end

return useMusicPickerViewModel
