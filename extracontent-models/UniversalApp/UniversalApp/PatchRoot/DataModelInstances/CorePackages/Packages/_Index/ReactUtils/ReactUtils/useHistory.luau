local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ReactUtils = script:FindFirstAncestor("ReactUtils")
local ReactUtilsParent = ReactUtils.Parent
local React = require(ReactUtilsParent.React)
local LUAU_ANALYZE_ERROR = ReactUtils.LUAU_ANALYZE_ERROR

local function useHistory(p1, p2: ((...any) -> ...any), t1: {[any]: any}) -- line: 11
	-- upvalues: React (copy), ChangeHistoryService (copy), LUAU_ANALYZE_ERROR (copy)
	local v10 = React.useRef(p1)
	local v11 = React.useRef({})
	local v12 = React.useRef({})

	React.useEffect(function() -- line: 16
		-- upvalues: ChangeHistoryService (copy), v11 (copy), v12 (copy), LUAU_ANALYZE_ERROR (copy), v10 (copy), p2 (copy)
		local connection = ChangeHistoryService.OnUndo:Connect(function(p3) -- line: 17
			-- upvalues: v11 (copy), v12 (copy), LUAU_ANALYZE_ERROR (copy), v10 (copy), p2 (copy)
			local current = v11.current
			local current2 = v12.current

			assert(current ~= nil, LUAU_ANALYZE_ERROR)
			assert(current2 ~= nil, LUAU_ANALYZE_ERROR)

			if not current[p3] or #current[p3] == 0 then
				return
			end

			if not current2[p3] then
				current2[p3] = {}
			end

			local v21 = #current[p3]
			local v22 = current[p3][v21]

			table.insert(current2[p3], v10.current)
			table.remove(current[p3], v21)
			v10.current = v22
			p2(v22)
			v11.current = current
			v12.current = current2
		end)
		local connection2 = ChangeHistoryService.OnRedo:Connect(function(p4) -- line: 48
			-- upvalues: v11 (copy), v12 (copy), LUAU_ANALYZE_ERROR (copy), v10 (copy), p2 (copy)
			local current = v11.current
			local current3 = v12.current

			assert(current ~= nil, LUAU_ANALYZE_ERROR)
			assert(current3 ~= nil, LUAU_ANALYZE_ERROR)

			if not current3[p4] or #current3[p4] == 0 then
				return
			end

			local v26 = #current3[p4]
			local v27 = current3[p4][v26]

			table.insert(current[p4], v10.current)
			table.remove(current3[p4], v26)
			assert(v27 ~= nil, LUAU_ANALYZE_ERROR)
			v10.current = v27
			p2(v27)
			v11.current = current
			v12.current = current3
		end)

		return function() -- line: 76
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, t1)
	React.useEffect(function() -- line: 82
		-- upvalues: v11 (copy), v12 (copy)
		v11.current = {}
		v12.current = {}
	end, t1)

	return (React.useCallback(function(s1: string, p5) -- line: 87
		-- upvalues: v11 (copy), LUAU_ANALYZE_ERROR (copy), v12 (copy), ChangeHistoryService (copy), v10 (copy)
		local current = v11.current

		assert(current ~= nil, LUAU_ANALYZE_ERROR)

		if not current[s1] then
			current[s1] = {}
		end

		v12.current = {}
		ChangeHistoryService:SetWaypoint(s1)

		if typeof(v10.current) == "table" then
			table.insert(current[s1], table.clone(v10.current))
		else
			table.insert(current[s1], v10.current)
		end

		v10.current = p5
		v11.current = current
	end, t1))
end

return useHistory
