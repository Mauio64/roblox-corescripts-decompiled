local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local context = React.createContext(nil)
local LoaderContext = {}
LoaderContext.LoaderContext = context

function LoaderContext.LoaderProvider(props)
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
end

function LoaderContext.useLoaderContext()
	local v = React.useContext(context)

	if not v then
		error("useLoaderContext must be used within a <LoaderProvider>")
	end

	return v
end

return LoaderContext
