local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local v3 = React.createContext(nil)

return {
	LoaderContext = v3,
	LoaderProvider = function(t1: {[any]: any}) -- line: 44
		-- upvalues: React (copy), v3 (copy)
		local v5 = React.useRef({})
		local v6 = React.useRef(t1.loaders)

		v6.current = t1.loaders
		React.useEffect(function() -- line: 49
			-- upvalues: t1 (copy), v5 (copy)
			if not t1.open then
				v5.current = {}
			end
		end, { t1.open })

		local current = React.useRef({
			registryRef = v6,
			cacheRef = v5
		}).current

		return React.createElement(v3.Provider, {
			value = current
		}, t1.children)
	end,
	useLoaderContext = function() -- line: 64
		-- upvalues: React (copy), v3 (copy)
		local v8 = React.useContext(v3)

		if not v8 then
			error("useLoaderContext must be used within a <LoaderProvider>")
		end

		return v8
	end
}
