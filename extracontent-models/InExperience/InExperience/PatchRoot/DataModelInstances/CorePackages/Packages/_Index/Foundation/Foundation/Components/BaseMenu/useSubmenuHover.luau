local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local useTokens = require(Foundation.Providers.Style.useTokens)

local function truncatePath(t1: {[any]: any}, n1: number) -- line: 36
	local t2 = {}

	for i = 1, n1 do
		if t1[i] then
			t2[i] = t1[i]
		end
	end

	return t2
end
local function buildPath(t3: {[any]: any}, n2: number, p1) -- line: 46
	local t4 = {}

	for i = 1, n2 - 1 do
		if t3[i] then
			t4[i] = t3[i]
		end
	end

	t4[n2] = p1

	return t4
end
local function useSubmenuHover() -- line: 52
	-- upvalues: useTokens (copy), React (copy)
	local v17 = useTokens()
	local Time_100 = v17.Time.Time_100
	local Time_300 = v17.Time.Time_300
	local v20, v21 = React.useState({})
	local v22 = React.useRef({})
	local v23 = React.useRef(nil)
	local v24 = React.useRef(nil)

	v22.current = v20

	local v25 = React.useCallback(function() -- line: 64
		-- upvalues: v23 (copy), v24 (copy)
		if v23.current then
			task.cancel(v23.current)
			v23.current = nil
		end

		if v24.current then
			task.cancel(v24.current)
			v24.current = nil
		end
	end, {})
	local v26 = React.useCallback(function(n3: number, p2, b1: boolean?) -- line: 75
		-- upvalues: v25 (copy), v22 (copy), v21 (copy), v23 (copy), Time_100 (copy)
		v25()

		if p2 == v22.current[n3] then
			return
		end

		if b1 then
			v21(function(t5: {[any]: any}) -- line: 83
				-- upvalues: n3 (copy), p2 (copy)
				local v34 = n3
				local v35 = p2
				local t6 = {}

				for i = 1, v34 - 1 do
					if t5[i] then
						t6[i] = t5[i]
					end
				end

				t6[v34] = v35

				return t6
			end)

			return
		end

		v23.current = task.delay(Time_100, function() -- line: 89
			-- upvalues: v21 (copy), n3 (copy), p2 (copy), v23 (copy)
			v21(function(t7: {[any]: any}) -- line: 90
				-- upvalues: n3 (copy), p2 (copy)
				local v39 = n3
				local v40 = p2
				local t8 = {}

				for i = 1, v39 - 1 do
					if t7[i] then
						t8[i] = t7[i]
					end
				end

				t8[v39] = v40

				return t8
			end)
			v23.current = nil
		end)
	end, {
		v25,
		Time_100
	})
	local v27 = React.useCallback(function(n4: number) -- line: 97
		-- upvalues: v25 (copy), v22 (copy), v24 (copy), Time_300 (copy), v21 (copy)
		v25()

		if n4 > #v22.current then
			return
		end

		v24.current = task.delay(Time_300, function() -- line: 104
			-- upvalues: v21 (copy), n4 (copy), v24 (copy)
			v21(function(t9: {[any]: any}) -- line: 105
				-- upvalues: n4 (copy)
				if #t9 < n4 then
					return t9
				end

				local t10 = {}

				for i = 1, n4 - 1 do
					if t9[i] then
						t10[i] = t9[i]
					end
				end

				return t10
			end)
			v24.current = nil
		end)
	end, {
		v25,
		Time_300
	})
	local v28 = React.useCallback(function() -- line: 117
		-- upvalues: v25 (copy), v21 (copy)
		v25()
		v21({})
	end, { v25 })

	React.useEffect(function() -- line: 123
		-- upvalues: v23 (copy), v24 (copy)
		return function() -- line: 124
			-- upvalues: v23 (copy), v24 (copy)
			if v23.current then
				task.cancel(v23.current)
			end

			if v24.current then
				task.cancel(v24.current)
			end
		end
	end, {})

	return {
		openPath = v20,
		openAtDepth = v26,
		closeAtDepth = v27,
		reset = v28
	}
end

return useSubmenuHover
