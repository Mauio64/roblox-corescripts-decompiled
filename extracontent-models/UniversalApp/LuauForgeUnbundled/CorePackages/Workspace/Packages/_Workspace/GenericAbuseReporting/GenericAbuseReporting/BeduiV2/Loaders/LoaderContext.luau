local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local context = React.createContext(nil)

return {
	LoaderContext = context,
	LoaderProvider = function(props)
		local ref = React.useRef({})
		local ref2 = React.useRef(props.loaders)
		ref2.current = props.loaders

		React.useEffect(function()
			if not props.open then
				ref.current = {}
			end
		end, { props.open })

		local current = React.useRef({ registryRef = ref2, cacheRef = ref }).current
		return React.createElement(context.Provider, { value = current }, props.children)
	end,
	useLoaderContext = function()
		local v5 = React.useContext(context)

		if not v5 then
			error("useLoaderContext must be used within a <LoaderProvider>")
		end

		return v5
	end
}
