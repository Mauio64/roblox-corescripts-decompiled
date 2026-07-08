local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local React = require(Parent.React)
local useStore = require(script.Parent.useStore)

local function v4(p1, p2) -- line: 12
	return p1 == p2
end

function useSelectorWithStore(p3: ((...any) -> ...any), p4: ((...any) -> ...any), p5) -- line: 16
	-- upvalues: React (copy)
	local _, v11 = React.useReducer(function(n1: number) -- line: 21
		return n1 + 1
	end, 0)
	local v12 = React.useRef(nil)
	local v13 = React.useRef(nil)
	local v14 = React.useRef(nil)
	local v15 = React.useRef(nil)
	local v16 = p5:getState()
	local u17 = nil
	local ok, result = pcall(function() -- line: 33
		-- upvalues: p3 (copy), v13 (copy), v16 (copy), v14 (copy), v12 (copy), v15 (copy), p4 (copy), u17 (ref)
		if p3 ~= v13.current or (v16 ~= v14.current or v12.current) then
			local v25 = p3(v16)

			if v15.current == nil or not p4(v25, v15.current) then
				u17 = v25

				return
			end

			u17 = v15.current

			return
		end

		u17 = v15.current
	end)

	if not ok then
		if v12.current then
			result = string.format("%s\nThe error may be correlated with this previous error:\n%s\n\n", tostring(result), (tostring(v12.current)))
		end

		error(result)
	end

	React.useLayoutEffect(function() -- line: 63
		-- upvalues: v13 (copy), p3 (copy), v14 (copy), v16 (copy), v15 (copy), u17 (ref), v12 (copy)
		v13.current = p3
		v14.current = v16
		v15.current = u17
		v12.current = nil
	end)
	React.useLayoutEffect(function() -- line: 70
		-- upvalues: v14 (copy), v13 (copy), p4 (copy), v15 (copy), v12 (copy), v11 (copy), p5 (copy)
		local function checkForUpdates(p6) -- line: 71
			-- upvalues: v14 (copy), v13 (copy), p4 (copy), v15 (copy), v12 (copy), v11 (copy)
			local ok2, result2 = pcall(function() -- line: 72
				-- upvalues: p6 (copy), v14 (copy), v13 (copy), p4 (copy), v15 (copy)
				if p6 == v14.current then
					return false
				end

				assert(v13.current, "latestSelector")

				local v35 = v13.current(p6)

				if p4(v35, v15.current) then
					return false
				end

				v15.current = v35
				v14.current = p6

				return true
			end)

			if not ok2 then
				result2 = result2 or "Error"
				v12.current = result2
			end

			if result2 then
				v11(nil)
			end
		end

		local v27 = p5.changed:connect(checkForUpdates)
		local v28 = p5:getState()
		local ok3, result3 = pcall(function() -- line: 72
			-- upvalues: v28 (copy), v14 (copy), v13 (copy), p4 (copy), v15 (copy)
			if v28 == v14.current then
				return false
			end

			assert(v13.current, "latestSelector")

			local v34 = v13.current(v28)

			if p4(v34, v15.current) then
				return false
			end

			v15.current = v34
			v14.current = v28

			return true
		end)

		if not ok3 then
			result3 = result3 or "Error"
			v12.current = result3
		end

		if result3 then
			v11(nil)
		end

		return function() -- line: 106
			-- upvalues: v27 (copy)
			v27.disconnect()
		end
	end, { p5 })

	return u17
end
function useSelector(p7: ((...any) -> ...any), p8: ((...any) -> ...any)?) -- line: 114
	-- upvalues: v4 (copy), useStore (copy)
	local v22 = p8 or v4
	local v23 = useStore()

	return (useSelectorWithStore(p7, v22, v23))
end

return useSelector
