local parent = script:FindFirstAncestor("Components").Parent.Parent
local React = require(parent.React)

local function onHover()
	warn("Wrap the component using HoverContext with a HoverContext.Provider element")
end

local context = React.createContext({ registerOnHoverCallback = onHover, onHover = onHover })

function useHoverContext(p)
	local v = React.useContext(context)
	local state, setState = React.useState(false)

	React.useEffect(function()
		v.registerOnHoverCallback(p, setState)
	end, {})

	return state, (React.useCallback(function(flag: boolean)
		v.onHover(p, flag)
	end, { p }))
end

function Provider(p)
	local ref = React.useRef({})
	local onHover2 = React.useCallback(function(p2, p3)
		if not ref.current[p2] then
			return
		end

		for _, v in ref.current[p2] do
			v(p3)
		end
	end, {})

	local registerOnHoverCallback = React.useCallback(function(p2, p3)
		local v = ref.current[p2]

		if v then
			table.insert(v, p3)
		else
			ref.current[p2] = { p3 }
		end
	end, {})

	return React.createElement(context.Provider, {
		value = { onHover = onHover2, registerOnHoverCallback = registerOnHoverCallback }
	}, p.children)
end

return { useHoverContext = useHoverContext, Provider = Provider }
