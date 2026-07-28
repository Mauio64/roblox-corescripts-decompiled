local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)

require(script.Parent.UserPickerTypes)

local v3 = game:DefineFastInt("BuildExperienceUserPickerSearchDebounceMs", 250)

local function trim(s1: string) -- line: 24
	return (string.gsub(s1, "^%s*(.-)%s*$", "%1"))
end
local function countKeys(t1: {[any]: any}) -- line: 28
	local n1 = 0

	for _, v12 in t1 do
		if v12 then
			n1 += 1
		end
	end

	return n1
end
local function appendUniqueIds(t2: {[any]: any}, t3: {[any]: any}) -- line: 40
	local t4 = {}

	for _, v17 in t2 do
		t4[v17] = true
	end

	local v18 = table.clone(t2)

	for _, v20 in t3 do
		if not t4[v20] then
			table.insert(v18, v20)
		end
	end

	return v18
end
local function useUserPicker(p1) -- line: 54
	-- upvalues: React (copy), v3 (copy), appendUniqueIds (copy)
	local browseIds = p1.browseIds
	local browseIsLoading = p1.browseIsLoading
	local loadMoreBrowse = p1.loadMoreBrowse
	local onSearch = p1.onSearch
	local onSubmit = p1.onSubmit
	local selectionLimit = p1.selectionLimit
	local onSelectionChanged = p1.onSelectionChanged
	local excludeUserIds = p1.excludeUserIds
	local v30, v31 = React.useState("")
	local v32, v33 = React.useState({})
	local v34, v35 = React.useState(nil)
	local v36, v37 = React.useState(false)
	local v38, v39 = React.useState({})
	local v40, v41 = React.useState("")
	local v42, v43 = React.useState(false)
	local v44 = React.useRef(false)
	local v45 = React.useRef(0)
	local v46 = React.useRef(false)
	local v47 = string.gsub(v30, "^%s*(.-)%s*$", "%1") ~= ""

	React.useEffect(function() -- line: 80
		-- upvalues: v30 (copy), v33 (copy), v35 (copy), v37 (copy), v45 (copy), v3 (copy), onSearch (copy)
		local v57 = v30
		local v58 = string.gsub(v57, "^%s*(.-)%s*$", "%1")

		if v58 == "" then
			v33({})
			v35(nil)
			v37(false)

			return
		end

		local v59 = v45

		v59.current = v59.current + 1

		local current = v45.current

		v33({})
		v35(nil)
		v37(true)

		local thread = task.delay(v3 / 1000, function() -- line: 97
			-- upvalues: onSearch (copy), v58 (copy), v45 (copy), current (copy), v33 (copy), v35 (copy), v37 (copy)
			onSearch(v58):andThen(function(p2) -- line: 100
				-- upvalues: v45 (copy), current (copy), v33 (copy), v35 (copy), v37 (copy)
				if v45.current == current then
					v33(p2.ids)
					v35(p2.nextCursor)
					v37(false)
				end
			end):catch(function() -- line: 107
				-- upvalues: v45 (copy), current (copy), v33 (copy), v35 (copy), v37 (copy)
				if v45.current == current then
					v33({})
					v35(nil)
					v37(false)
				end
			end)
		end)

		return function() -- line: 118
			-- upvalues: thread (copy)
			pcall(task.cancel, thread)
		end
	end, {
		v30,
		onSearch
	})

	local v48 = React.useCallback(function() -- line: 123
		-- upvalues: v47 (copy), v44 (copy), v34 (copy), v45 (copy), onSearch (copy), v30 (copy), v33 (copy), appendUniqueIds (copy), v35 (copy), loadMoreBrowse (copy)
		if v47 then
			if v44.current or v34 == nil then
				return
			end

			v44.current = true

			local current = v45.current
			local v63 = onSearch
			local v64 = v30

			v63(string.gsub(v64, "^%s*(.-)%s*$", "%1"), v34):andThen(function(p3) -- line: 133
				-- upvalues: v45 (copy), current (copy), v33 (copy), appendUniqueIds (copy), v35 (copy)
				if v45.current ~= current then
					return
				end

				v33(function(p4) -- line: 138
					-- upvalues: appendUniqueIds (copy), p3 (copy)
					return (appendUniqueIds(p4, p3.ids))
				end)
				v35(p3.nextCursor)
			end):finally(function() -- line: 143
				-- upvalues: v44 (copy)
				v44.current = false
			end)

			return
		end

		loadMoreBrowse()
	end, {
		v47,
		v34,
		v30,
		onSearch,
		loadMoreBrowse
	})
	local v49 = React.useMemo(function() -- line: 155
		-- upvalues: v47 (copy), v32 (copy), browseIds (copy), excludeUserIds (copy)
		local v65 = if not v47 then browseIds else v32

		if excludeUserIds == nil then
			return v65
		end

		local t5 = {}

		for _, v68 in v65 do
			if not excludeUserIds[v68] then
				table.insert(t5, v68)
			end
		end

		return t5
	end, {
		v47,
		v32,
		browseIds,
		excludeUserIds
	})
	local n2 = 0

	for _, v52 in v38 do
		if v52 then
			n2 += 1
		end
	end

	React.useEffect(function() -- line: 174
		-- upvalues: selectionLimit (copy), v39 (copy)
		if selectionLimit == nil then
			return
		end

		local v69 = selectionLimit

		v39(function(p5) -- line: 179
			-- upvalues: v69 (copy)
			local n3 = 0

			for _, v89 in p5 do
				if v89 then
					n3 += 1
				end
			end

			if n3 <= v69 then
				return p5
			end

			local t6 = {}
			local n4 = 0

			for v92, v93 in p5 do
				if v93 and n4 < v69 then
					t6[v92] = true
					n4 += 1
				end
			end

			return t6
		end)
	end, { selectionLimit })
	React.useEffect(function() -- line: 195
		-- upvalues: v46 (copy), onSelectionChanged (copy), v38 (copy)
		if not v46.current then
			v46.current = true

			return
		end

		if onSelectionChanged ~= nil then
			local t7 = {}

			for v71, v72 in v38 do
				if v72 then
					table.insert(t7, v71)
				end
			end

			onSelectionChanged(t7)
		end
	end, {
		v38,
		onSelectionChanged
	})

	local v53 = React.useCallback(function(n5: number) -- line: 211
		-- upvalues: v38 (copy)
		return v38[n5] == true
	end, { v38 })
	local v54 = React.useCallback(function(n6: number) -- line: 215
		-- upvalues: v38 (copy), selectionLimit (copy)
		if v38[n6] == true then
			return true
		end

		local v75 = true

		if selectionLimit ~= nil then
			local n7 = 0

			for _, v78 in v38 do
				if v78 then
					n7 += 1
				end
			end

			v75 = n7 < selectionLimit
		end

		return v75
	end, {
		v38,
		selectionLimit
	})
	local v55 = React.useCallback(function(n8: number) -- line: 222
		-- upvalues: v39 (copy), selectionLimit (copy)
		v39(function(p6) -- line: 223
			-- upvalues: n8 (copy), selectionLimit (copy)
			local v95 = table.clone(p6)

			if v95[n8] then
				v95[n8] = nil

				return v95
			end

			if selectionLimit ~= nil then
				local n9 = 0

				for _, v98 in v95 do
					if v98 then
						n9 += 1
					end
				end

				if not (n9 < selectionLimit) then
					return p6
				end
			end

			v95[n8] = true

			return v95
		end)
	end, { selectionLimit })
	local v56 = React.useCallback(function() -- line: 236
		-- upvalues: v42 (copy), v38 (copy), v43 (copy), onSubmit (copy), v40 (copy)
		if v42 then
			return
		end

		local t8 = {}

		for v81, v82 in v38 do
			if v82 then
				table.insert(t8, v81)
			end
		end

		if #t8 == 0 then
			return
		end

		v43(true)

		local v83 = onSubmit
		local v84 = v40

		v83(t8, (if string.gsub(v84, "^%s*(.-)%s*$", "%1") == "" then nil else v40)):finally(function() -- line: 250
			-- upvalues: v43 (copy)
			v43(false)
		end)
	end, {
		v42,
		v38,
		v40,
		onSubmit
	})

	return {
		searchText = v30,
		setSearchText = v31,
		userIds = v49,
		isLoading = if not v47 then browseIsLoading else v36,
		loadMore = v48,
		selectedCount = n2,
		hasSelection = n2 > 0,
		selectionLimit = selectionLimit,
		isSelected = v53,
		canSelect = v54,
		toggleSelected = v55,
		message = v40,
		setMessage = v41,
		isSubmitting = v42,
		submit = v56
	}
end

return useUserPicker
