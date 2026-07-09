local Parent = script:FindFirstAncestor("AppDebug").Parent
local React = require(Parent.React)
local CollectionService = game:GetService("CollectionService")
local t1 = {
	DevDebugPanel = true,
	TagAnnotation = true
}

local function isInExcludedScreenGui(p1) -- line: 45
	-- upvalues: t1 (copy)
	while p1 do
		if p1:IsA("ScreenGui") and t1[p1.Name] then
			return true
		end

		p1 = p1.Parent
	end

	return false
end
local function extractTestId(s1: string) -- line: 56
	if string.sub(s1, 1, 12) == "data-testid=" then
		return (string.sub(s1, 13))
	end

	return nil
end
local function getInstancePath(p2) -- line: 63
	local t2 = {}

	while p2 and p2 ~= game do
		table.insert(t2, 1, p2.Name)
		p2 = p2.Parent
	end

	return table.concat(t2, "/")
end
local function createTagInfo(p3, s2: string, s3: string) -- line: 73
	-- upvalues: getInstancePath (copy)
	local vector2 = Vector2.new(0, 0)
	local vector2_2 = Vector2.new(0, 0)

	if p3:IsA("GuiObject") then
		vector2 = p3.AbsolutePosition
		vector2_2 = p3.AbsoluteSize
	end

	return {
		instance = p3,
		testId = s3,
		fullTag = s2,
		absolutePosition = vector2,
		absoluteSize = vector2_2,
		className = p3.ClassName,
		name = p3.Name,
		path = getInstancePath(p3)
	}
end
local function scanAllTags() -- line: 102
	-- upvalues: CollectionService (copy), isInExcludedScreenGui (copy), createTagInfo (copy)
	local t3 = {}
	local ok, result = pcall(function() -- line: 111
		-- upvalues: CollectionService (copy)
		return CollectionService:GetAllTags()
	end)

	if not ok then
		return {}, {}, {}
	end

	local t4 = {}

	for _, v26 in result do
		local v27 = if string.sub(v26, 1, 12) ~= "data-testid=" then nil else string.sub(v26, 13)

		if v27 then
			table.insert(t4, v26)

			local ok2, result2 = pcall(function() -- line: 126
				-- upvalues: CollectionService (copy), v26 (copy)
				return CollectionService:GetTagged(v26)
			end)

			if ok2 then
				for _, v31 in result2 do
					if not isInExcludedScreenGui(v31) then
						local ok3, result3 = pcall(function() -- line: 135
							-- upvalues: createTagInfo (copy), v31 (copy), v26 (copy), v27 (copy)
							return (createTagInfo(v31, v26, v27))
						end)

						if ok3 then
							table.insert(t3, result3)
						end
					end
				end
			end
		end
	end

	return t3, result, t4
end
local function subscribeToTag(s4: string, p4: ((...any) -> ...any), p5: ((...any) -> ...any)) -- line: 153
	-- upvalues: CollectionService (copy)
	local connection = CollectionService:GetInstanceAddedSignal(s4):Connect(p4)
	local connection2 = CollectionService:GetInstanceRemovedSignal(s4):Connect(p5)

	return function() -- line: 161
		-- upvalues: connection (copy), connection2 (copy)
		connection:Disconnect()
		connection2:Disconnect()
	end
end
local function useTagScanner(_: {[any]: any}?, n1: number?) -- line: 179
	-- upvalues: React (copy), isInExcludedScreenGui (copy), createTagInfo (copy), subscribeToTag (copy), CollectionService (copy), scanAllTags (copy)
	local v41, v42 = React.useState({})
	local v43, v44 = React.useState({})
	local v45, v46 = React.useState({})
	local v47, v48 = React.useState(0)
	local v49 = React.useRef({})
	local v50 = React.useCallback(function() -- line: 188
		-- upvalues: v48 (copy)
		v48(function(p6) -- line: 189
			return p6 + 1
		end)
	end, {})
	local v51 = React.useCallback(function(p7, s5: string) -- line: 195
		-- upvalues: isInExcludedScreenGui (copy), createTagInfo (copy), v42 (copy)
		if isInExcludedScreenGui(p7) then
			return
		end

		local v57 = if string.sub(s5, 1, 12) ~= "data-testid=" then nil else string.sub(s5, 13)

		if v57 then
			local v58 = createTagInfo(p7, s5, v57)

			v42(function(p8) -- line: 202
				-- upvalues: v58 (copy)
				local v81 = table.clone(p8)

				table.insert(v81, v58)

				return v81
			end)
		end
	end, {})
	local v52 = React.useCallback(function(p9) -- line: 211
		-- upvalues: v42 (copy)
		v42(function(p10) -- line: 212
			-- upvalues: p9 (copy)
			local t6 = {}

			for _, v85 in p10 do
				if v85.instance ~= p9 then
					table.insert(t6, v85)
				end
			end

			return t6
		end)
	end, {})
	local v53 = React.useCallback(function(s6: string) -- line: 224
		-- upvalues: v49 (copy), subscribeToTag (copy), v51 (copy), v52 (copy), CollectionService (copy), v44 (copy), v46 (copy)
		if v49.current[s6] then
			return
		end

		local v61 = subscribeToTag(s6, function(p11) -- line: 231
			-- upvalues: v51 (copy), s6 (copy)
			v51(p11, s6)
		end, function(p12) -- line: 233
			-- upvalues: v52 (copy)
			v52(p12)
		end)

		v49.current[s6] = v61

		local v62 = if string.sub(s6, 1, 12) ~= "data-testid=" then nil else string.sub(s6, 13)

		if v62 then
			for _, v64 in (CollectionService:GetTagged(s6)) do
				v51(v64, s6)
			end
		end

		v44(function(p13) -- line: 248
			-- upvalues: s6 (copy)
			if not table.find(p13, s6) then
				local v89 = table.clone(p13)

				table.insert(v89, s6)

				return v89
			end

			return p13
		end)

		if v62 then
			v46(function(p14) -- line: 259
				-- upvalues: s6 (copy)
				if not table.find(p14, s6) then
					local v91 = table.clone(p14)

					table.insert(v91, s6)

					return v91
				end

				return p14
			end)
		end
	end, {
		v51,
		v52
	})
	local v54 = React.useCallback(function(s7: string) -- line: 271
		-- upvalues: v49 (copy), v44 (copy), v46 (copy), v42 (copy)
		local v66 = v49.current[s7]

		if v66 then
			v66()
			v49.current[s7] = nil
		end

		v44(function(p15) -- line: 279
			-- upvalues: s7 (copy)
			local t7 = {}

			for _, v95 in p15 do
				if v95 ~= s7 then
					table.insert(t7, v95)
				end
			end

			return t7
		end)
		v46(function(p16) -- line: 290
			-- upvalues: s7 (copy)
			local t8 = {}

			for _, v99 in p16 do
				if v99 ~= s7 then
					table.insert(t8, v99)
				end
			end

			return t8
		end)
		v42(function(p17) -- line: 301
			-- upvalues: s7 (copy)
			local t9 = {}

			for _, v103 in p17 do
				if v103.fullTag ~= s7 then
					table.insert(t9, v103)
				end
			end

			return t9
		end)
	end, {})

	React.useEffect(function() -- line: 313
		-- upvalues: CollectionService (copy), v53 (copy), v54 (copy), scanAllTags (copy), v42 (copy), v44 (copy), v46 (copy), subscribeToTag (copy), createTagInfo (copy), v49 (copy)
		local t10 = {}
		local ok, result = pcall(function() -- line: 318
			-- upvalues: CollectionService (copy), v53 (copy)
			return CollectionService.TagAdded:Connect(function(s8: string) -- line: 319
				-- upvalues: v53 (copy)
				v53(s8)
			end)
		end)

		if ok then
			table.insert(t10, result)
		end

		local ok4, result4 = pcall(function() -- line: 330
			-- upvalues: CollectionService (copy), v54 (copy)
			return CollectionService.TagRemoved:Connect(function(s9: string) -- line: 331
				-- upvalues: v54 (copy)
				v54(s9)
			end)
		end)

		if ok4 then
			table.insert(t10, result4)
		end

		local v72, v73, v74 = scanAllTags()

		v42(v72)
		v44(v73)
		v46(v74)

		for _, v76 in v73 do
			local ok5, result5 = pcall(function() -- line: 347
				-- upvalues: subscribeToTag (copy), v76 (copy), createTagInfo (copy), v42 (copy)
				return (subscribeToTag(v76, function(p18) -- line: 348
					-- upvalues: v76 (copy), createTagInfo (copy), v42 (copy)
					local v111 = v76
					local v112 = if string.sub(v111, 1, 12) ~= "data-testid=" then nil else string.sub(v111, 13)

					if v112 then
						local v113 = createTagInfo(p18, v76, v112)

						v42(function(p19) -- line: 352
							-- upvalues: v113 (copy)
							local v116 = table.clone(p19)

							table.insert(v116, v113)

							return v116
						end)
					end
				end, function(p20) -- line: 358
					-- upvalues: v42 (copy)
					v42(function(p21) -- line: 359
						-- upvalues: p20 (copy)
						local t11 = {}

						for _, v120 in p21 do
							if v120.instance ~= p20 then
								table.insert(t11, v120)
							end
						end

						return t11
					end)
				end))
			end)

			if ok5 then
				v49.current[v76] = result5
			end
		end

		return function() -- line: 376
			-- upvalues: t10 (copy), v49 (copy)
			for _, v105 in t10 do
				pcall(function() -- line: 378
					-- upvalues: v105 (copy)
					v105:Disconnect()
				end)
			end

			for _, v107 in v49.current do
				pcall(v107)
			end

			v49.current = {}
		end
	end, {
		v47,
		v53,
		v54,
		n1
	})

	return {
		tags = v41,
		allTags = v43,
		testIdTags = v45,
		rescan = v50
	}
end

return useTagScanner
