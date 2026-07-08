local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

function getOrSet(t1: {[any]: any}, p1, p2: ((...any) -> ...any), ...) -- line: 7
	local v7 = t1[p1]

	if not v7 then
		v7 = p2(...)
		t1[p1] = v7
	end

	return v7
end
function useVariantsState() -- line: 22
	-- upvalues: React (copy)
	local v8 = React.useRef({})
	local v9 = React.useRef(nil)

	return React.useCallback(function(s1: string, p3: ((...any) -> ...any), p4) -- line: 26
		-- upvalues: v9 (copy), v8 (copy)
		if p4 ~= v9.current then
			table.clear(v8.current)
			v9.current = p4
		end

		return getOrSet(v8.current, s1, p3, p4)
	end, {})
end

local v3 = React.createContext(nil)

function useVariants(s2: string, p5: ((...any) -> ...any), p6) -- line: 39
	-- upvalues: React (copy), v3 (copy)
	local v13 = React.useContext(v3)

	if v13 == nil then
		error("VariantsContext hasn't been instantiated")
	end

	return v13(s2, p5, p6)
end

return {
	useVariants = useVariants,
	useVariantsState = useVariantsState,
	Provider = v3.Provider
}
