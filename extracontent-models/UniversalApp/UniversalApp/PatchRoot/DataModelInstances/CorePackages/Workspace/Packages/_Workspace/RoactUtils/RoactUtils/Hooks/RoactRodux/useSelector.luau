local Parent = script:FindFirstAncestor("RoactUtils").Parent
local ArgCheck = require(Parent.ArgCheck)
local React = require(Parent.React)
local Dash = require(Parent.Dash)
local useStore = require(script.Parent.useStore)

local function v6(p1, p2) -- line: 52
	return p1 == p2
end

function useSelectorWithStore(p3: ((...any) -> ...any), p4: ((...any) -> ...any), p5) -- line: 56
	-- upvalues: React (copy)
	local _, v13 = React.useReducer(function(n1: number) -- line: 61
		return n1 + 1
	end, 0)
	local v14 = React.useRef(nil)
	local v15 = React.useRef(nil)
	local v16 = React.useRef(nil)
	local v17 = React.useRef(nil)
	local v18 = p5:getState()
	local u19 = nil
	local ok, result = pcall(function() -- line: 73
		-- upvalues: p3 (copy), v15 (copy), v18 (copy), v16 (copy), v14 (copy), v17 (copy), p4 (copy), u19 (ref)
		if p3 ~= v15.current or (v18 ~= v16.current or v14.current) then
			local v27 = p3(v18)

			if v17.current == nil or not p4(v27, v17.current) then
				u19 = v27

				return
			end

			u19 = v17.current

			return
		end

		u19 = v17.current
	end)

	if not ok then
		if v14.current then
			result = string.format("%s\nThe error may be correlated with this previous error:\n%s\n\n", tostring(result), (tostring(v14.current)))
		end

		error(result)
	end

	React.useLayoutEffect(function() -- line: 103
		-- upvalues: v15 (copy), p3 (copy), v16 (copy), v18 (copy), v17 (copy), u19 (ref), v14 (copy)
		v15.current = p3
		v16.current = v18
		v17.current = u19
		v14.current = nil
	end)
	React.useLayoutEffect(function() -- line: 110
		-- upvalues: v16 (copy), v15 (copy), p4 (copy), v17 (copy), v14 (copy), v13 (copy), p5 (copy)
		local function checkForUpdates(p6) -- line: 111
			-- upvalues: v16 (copy), v15 (copy), p4 (copy), v17 (copy), v14 (copy), v13 (copy)
			local ok2, result2 = pcall(function() -- line: 112
				-- upvalues: p6 (copy), v16 (copy), v15 (copy), p4 (copy), v17 (copy)
				if p6 == v16.current then
					return false
				end

				assert(v15.current, "latestSelector")

				local v37 = v15.current(p6)

				if p4(v37, v17.current) then
					return false
				end

				v17.current = v37
				v16.current = p6

				return true
			end)

			if not ok2 then
				result2 = result2 or "Error"
				v14.current = result2
			end

			if result2 then
				v13(nil)
			end
		end

		local v29 = p5.changed:connect(checkForUpdates)
		local v30 = p5:getState()
		local ok3, result3 = pcall(function() -- line: 112
			-- upvalues: v30 (copy), v16 (copy), v15 (copy), p4 (copy), v17 (copy)
			if v30 == v16.current then
				return false
			end

			assert(v15.current, "latestSelector")

			local v36 = v15.current(v30)

			if p4(v36, v17.current) then
				return false
			end

			v17.current = v36
			v16.current = v30

			return true
		end)

		if not ok3 then
			result3 = result3 or "Error"
			v14.current = result3
		end

		if result3 then
			v13(nil)
		end

		return function() -- line: 146
			-- upvalues: v29 (copy)
			v29:disconnect()
		end
	end, { p5 })

	return u19
end
function useSelector(p7: ((...any) -> ...any), p8: ((...any) -> ...any)?) -- line: 154
	-- upvalues: ArgCheck (copy), Dash (copy), v6 (copy), useStore (copy)
	ArgCheck.isNotNil(p7, "selector")
	ArgCheck.assert(Dash.isCallable(p7), "useSelector expects 'selector' to be callable")
	ArgCheck.isTypeOrNil(p8, "function", "equalityFn")

	local v24 = p8 or v6
	local v25 = useStore()

	return (useSelectorWithStore(p7, v24, v25))
end

return useSelector
