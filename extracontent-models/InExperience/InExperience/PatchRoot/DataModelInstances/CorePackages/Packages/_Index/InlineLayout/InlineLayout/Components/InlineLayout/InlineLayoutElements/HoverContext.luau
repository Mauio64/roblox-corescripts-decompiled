local ParentParent = script:FindFirstAncestor("Components").Parent.Parent
local React = require(ParentParent.React)

local function v3() -- line: 39
	warn("Wrap the component using HoverContext with a HoverContext.Provider element")
end

local v4 = React.createContext({
	registerOnHoverCallback = v3,
	onHover = v3
})

function useHoverContext(p1) -- line: 54
	-- upvalues: React (copy), v4 (copy)
	local v6 = React.useContext(v4)
	local v7, v8 = React.useState(false)

	React.useEffect(function() -- line: 58
		-- upvalues: v6 (copy), p1 (copy), v8 (copy)
		v6.registerOnHoverCallback(p1, v8)
	end, {})

	return v7, (React.useCallback(function(b1: boolean) -- line: 62
		-- upvalues: v6 (copy), p1 (copy)
		v6.onHover(p1, b1)
	end, { p1 }))
end
function Provider(t1: {[any]: any}) -- line: 69
	-- upvalues: React (copy), v4 (copy)
	local v10 = React.useRef({})
	local v11 = React.useCallback(function(p2, p3) -- line: 71
		-- upvalues: v10 (copy)
		if not v10.current[p2] then
			return
		end

		for _, v17 in v10.current[p2] do
			v17(p3)
		end
	end, {})
	local v12 = React.useCallback(function(p4, p5) -- line: 80
		-- upvalues: v10 (copy)
		local v20 = v10.current[p4]

		if v20 then
			table.insert(v20, p5)

			return
		end

		v10.current[p4] = { p5 }
	end, {})

	return React.createElement(v4.Provider, {
		value = {
			onHover = v11,
			registerOnHoverCallback = v12
		}
	}, t1.children)
end

return {
	useHoverContext = useHoverContext,
	Provider = Provider
}
