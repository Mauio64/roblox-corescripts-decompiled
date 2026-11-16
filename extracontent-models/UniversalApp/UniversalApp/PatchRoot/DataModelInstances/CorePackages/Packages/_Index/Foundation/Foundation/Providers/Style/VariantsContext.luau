local parent = script:FindFirstAncestor("Foundation").Parent
local React = require(parent.React)

function getOrSet(sets, p, callback, ...)
	local set = sets[p]

	if not set then
		set = callback(...)
		sets[p] = set
	end

	return set
end

function useVariantsState()
	local ref = React.useRef({})
	local ref2 = React.useRef(nil)
	return React.useCallback(function(p: string, callback, current)
		if ref2.current ~= current then
			table.clear(ref.current)
			ref2.current = current
		end

		return getOrSet(ref.current, p, callback, current)
	end, {})
end

local context = React.createContext(nil)

function useVariants(p: string, callback, p2)
	local v = React.useContext(context)

	if v == nil then
		error("VariantsContext hasn't been instantiated")
	end

	return v(p, callback, p2)
end

return {
	useVariants = useVariants,
	useVariantsState = useVariantsState,
	Provider = context.Provider
}
