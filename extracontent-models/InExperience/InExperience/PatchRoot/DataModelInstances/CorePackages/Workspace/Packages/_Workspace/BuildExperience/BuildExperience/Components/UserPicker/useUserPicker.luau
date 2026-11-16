local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

require(script.Parent.UserPickerTypes)

local defineFastInt = game:DefineFastInt("BuildExperienceUserPickerSearchDebounceMs", 250)

local function trim(state: string) -- 4 equivalent calls inferred from this helper
	return (string.gsub(state, "^%s*(.-)%s*$", "%1"))
end

local function countKeys(items) -- 4 equivalent calls inferred from this helper
	local count = 0

	for _, item in items do
		if item then
			count += 1
		end
	end

	return count
end

local function appendUniqueIds(items, ids)
	local set = {}

	for _, item in items do
		set[item] = true
	end

	local clone = table.clone(items)

	for _, item in ids do
		if not set[item] then
			table.insert(clone, item)
		end
	end

	return clone
end

local function useUserPicker(data)
	local browseIds = data.browseIds
	local isLoading = data.browseIsLoading
	local loadMoreBrowse = data.loadMoreBrowse
	local onSearch = data.onSearch
	local onSubmit = data.onSubmit
	local selectionLimit = data.selectionLimit
	local onSelectionChanged = data.onSelectionChanged
	local excludeUserIds = data.excludeUserIds

	local state, setState = React.useState("")
	local state2, setState2 = React.useState({})

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState({})
	local state6, setState6 = React.useState("")
	local state7, setState7 = React.useState(false)

	local ref = React.useRef(false)
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(false)
	local v = trim(state) ~= "" -- inferred equivalent call
	React.useEffect(function()
		local v2 = trim(state) -- inferred equivalent call

		if v2 == "" then
			setState2({})
			setState3(nil)
			setState4(false)
		else
			ref2.current += 1
			local current = ref2.current

			setState2({})
			setState3(nil)
			setState4(true)
			local thread = task.delay(defineFastInt / 1000, function()
				onSearch(v2):andThen(function(p)
					if ref2.current == current then
						setState2(p.ids)
						setState3(p.nextCursor)
						setState4(false)
					end
				end):catch(function()
					if ref2.current == current then
						setState2({})
						setState3(nil)
						setState4(false)
					end
				end)
			end)

			return function()
				pcall(task.cancel, thread)
			end
		end
	end, { state, onSearch })

	local loadMore = React.useCallback(function()
		if not v then
			loadMoreBrowse()
			return
		end

		if ref.current or state3 == nil then
			return
		end

		ref.current = true
		local current = ref2.current
		onSearch(trim(state), state3):andThen(function(p) -- inferred equivalent call
			if ref2.current ~= current then
				return
			end

			setState2(function(p2)
				return appendUniqueIds(p2, p.ids)
			end)

			setState3(p.nextCursor)
		end):finally(function()
			ref.current = false
		end)
	end, { v, state3, state, onSearch, loadMoreBrowse })

	local userIds = React.useMemo(function()
		local selected = if v then state2 else browseIds

		if excludeUserIds == nil then
			return selected
		end

		local result = {}

		for _, v2 in selected do
			if not excludeUserIds[v2] then
				table.insert(result, v2)
			end
		end

		return result
	end, { v, state2, browseIds, excludeUserIds })
	local selectedCount = countKeys(state5) -- inferred equivalent call
	React.useEffect(function()
		if selectionLimit == nil then
			return
		end

		local v2 = selectionLimit
		setState5(function(items)
			if countKeys(items) <= v2 then -- inferred equivalent call
				return items
			end

			local count = 0
			local result = {}

			for k, item in items do
				if not (item and count < v2) then
					continue
				end

				result[k] = true
				count += 1
			end

			return result
		end)
	end, { selectionLimit })

	React.useEffect(function()
		if not ref3.current then
			ref3.current = true
		elseif onSelectionChanged ~= nil then
			local v2 = {}

			for k, v3 in state5 do
				if v3 then
					table.insert(v2, k)
				end
			end

			onSelectionChanged(v2)
		end
	end, { state5, onSelectionChanged })

	local isSelected = React.useCallback(function(p: number): boolean
		return state5[p] == true
	end, { state5 })

	local canSelect = React.useCallback(function(p: number): boolean
		return state5[p] == true or selectionLimit == nil or countKeys(state5) < selectionLimit -- inferred equivalent call
	end, { state5, selectionLimit })

	local toggleSelected = React.useCallback(function(p: number)
		setState5(function(p2)
			local clone = table.clone(p2)

			if clone[p] then
				clone[p] = nil
				return clone
			end

			if selectionLimit ~= nil and not (countKeys(clone) < selectionLimit) then -- inferred equivalent call
				return p2
			end

			clone[p] = true
			return clone
		end)
	end, { selectionLimit })

	local submit = React.useCallback(function()
		if state7 then
			return
		end

		local v2 = {}

		for k, v3 in state5 do
			if v3 then
				table.insert(v2, k)
			end
		end

		if #v2 == 0 then
			return
		end

		setState7(true)
		local v3

		if trim(state6) ~= "" then -- inferred equivalent call
			v3 = state6
		end

		onSubmit(v2, v3):finally(function()
			setState7(false)
		end)
	end, { state7, state5, state6, onSubmit })

	local v2 = {
		searchText = state,
		setSearchText = setState,
		userIds = userIds,
		isLoading = nil,
		loadMore = nil,
		selectedCount = nil,
		hasSelection = 0,
		selectionLimit = 0,
		isSelected = 0,
		canSelect = 0,
		toggleSelected = 0,
		message = 0,
		setMessage = 0,
		isSubmitting = 0,
		submit = 0
	}

	if v then
		isLoading = state4
	end

	v2.isLoading = isLoading
	v2.loadMore = loadMore
	v2.selectedCount = selectedCount
	v2.hasSelection = selectedCount > 0
	v2.selectionLimit = selectionLimit
	v2.isSelected = isSelected
	v2.canSelect = canSelect
	v2.toggleSelected = toggleSelected
	v2.message = state6
	v2.setMessage = setState6
	v2.isSubmitting = state7
	v2.submit = submit
	return v2
end

return useUserPicker
