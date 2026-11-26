local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UserPicker/UserPickerTypes")

local defineFastInt = game:DefineFastInt("BuildExperienceUserPickerSearchDebounceMs", 250)

local function trim(value)
	return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
end

local function countKeys(items)
	local count = 0

	for k, item in items do
		if item then
			count += 1
		end
	end

	return count
end

local function appendUniqueIds(items, ids)
	local set = {}

	for k, item in items do
		set[item] = true
	end

	local clone = table.clone(items)

	for k, item in ids do
		if not set[item] then
			table.insert(clone, item)
		end
	end

	return clone
end

local function useUserPicker(data)
	local browseIds = data.browseIds
	local v5 = data.browseIsLoading
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
	local v6 = string.gsub(state, "^%s*(.-)%s*$", "%1") ~= ""

	React.useEffect(function()
		local v8 = string.gsub(state, "^%s*(.-)%s*$", "%1")

		if v8 == "" then
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
				onSearch(v8):andThen(function(p2)
					if ref2.current == current then
						setState2(p2.ids)
						setState3(p2.nextCursor)
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

	local v7 = React.useCallback(function()
		if not v6 then
			loadMoreBrowse()
			return
		end

		if ref.current or state3 == nil then
			return
		end

		ref.current = true
		local current = ref2.current
		onSearch(string.gsub(state, "^%s*(.-)%s*$", "%1"), state3):andThen(function(p2)
			if ref2.current ~= current then
				return
			end

			setState2(function(p3)
				return appendUniqueIds(p3, p2.ids)
			end)

			setState3(p2.nextCursor)
		end):finally(function()
			ref.current = false
		end)
	end, { v6, state3, state, onSearch, loadMoreBrowse })

	local v8 = React.useMemo(function()
		local v9 = if v6 then state2 else browseIds

		if excludeUserIds == nil then
			return v9
		end

		local result = {}

		for k, v10 in v9 do
			if not excludeUserIds[v10] then
				table.insert(result, v10)
			end
		end

		return result
	end, { v6, state2, browseIds, excludeUserIds })
	local count = 0

	for k, v9 in state5 do
		if v9 then
			count += 1
		end
	end

	React.useEffect(function()
		if selectionLimit == nil then
			return
		end

		local v9 = selectionLimit
		setState5(function(items)
			local count2 = 0

			for k, item in items do
				if item then
					count2 += 1
				end
			end

			if count2 <= v9 then
				return items
			end

			local count3 = 0
			local result = {}

			for k, item in items do
				if not (item and count3 < v9) then
					continue
				end

				result[k] = true
				count3 += 1
			end

			return result
		end)
	end, { selectionLimit })

	React.useEffect(function()
		if not ref3.current then
			ref3.current = true
		elseif onSelectionChanged ~= nil then
			local v9 = {}

			for k, v10 in state5 do
				if v10 then
					table.insert(v9, k)
				end
			end

			onSelectionChanged(v9)
		end
	end, { state5, onSelectionChanged })

	local v9 = React.useCallback(function(p2): boolean
		return state5[p2] == true
	end, { state5 })

	local v10 = React.useCallback(function(p2)
		if state5[p2] == true then
			return true
		end

		local v11

		if selectionLimit == nil then
			v11 = true
		else
			local count2 = 0

			for k, v12 in state5 do
				if v12 then
					count2 += 1
				end
			end

			v11 = count2 < selectionLimit
		end

		return v11
	end, { state5, selectionLimit })

	local v11 = React.useCallback(function(p2)
		setState5(function(p3)
			local clone = table.clone(p3)

			if clone[p2] then
				clone[p2] = nil
				return clone
			end

			if selectionLimit ~= nil then
				local count2 = 0

				for k, v12 in clone do
					if v12 then
						count2 += 1
					end
				end

				if not (count2 < selectionLimit) then
					return p3
				end
			end

			clone[p2] = true
			return clone
		end)
	end, { selectionLimit })

	local v12 = React.useCallback(function()
		if state7 then
			return
		end

		local v13 = {}

		for k, v14 in state5 do
			if v14 then
				table.insert(v13, k)
			end
		end

		if #v13 == 0 then
			return
		end

		setState7(true)
		local v16 = if string.gsub(state6, "^%s*(.-)%s*$", "%1") ~= "" then state6 else nil

		onSubmit(v13, v16):finally(function()
			setState7(false)
		end)
	end, { state7, state5, state6, onSubmit })

	local v13 = {
		searchText = state,
		setSearchText = setState,
		userIds = v8,
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

	if v6 then
		v5 = state4
	end

	v13.isLoading = v5
	v13.loadMore = v7
	v13.selectedCount = count
	v13.hasSelection = count > 0
	v13.selectionLimit = selectionLimit
	v13.isSelected = v9
	v13.canSelect = v10
	v13.toggleSelected = v11
	v13.message = state6
	v13.setMessage = setState6
	v13.isSubmitting = state7
	v13.submit = v12
	return v13
end

return useUserPicker
