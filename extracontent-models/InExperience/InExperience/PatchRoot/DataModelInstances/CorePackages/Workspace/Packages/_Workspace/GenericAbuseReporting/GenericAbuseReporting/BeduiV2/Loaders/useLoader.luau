local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local LoaderContext = require(script.Parent.LoaderContext)

local function isLoadDescriptor(p): boolean -- 1 equivalent call inferred from this helper
	return typeof(p) == "table" and p["$load"] ~= nil
end

local function cacheKey(load: string, params)
	if not params then
		return load .. "::{}"
	end

	local v = {}

	for k in pairs(params) do
		table.insert(v, k)
	end

	table.sort(v)
	local v2 = {}

	for _, v3 in ipairs(v) do
		table.insert(v2, v3 .. "=" .. params[v3])
	end

	return load .. "::" .. table.concat(v2, ",")
end

local function useLoader(p)
	local v = LoaderContext.useLoaderContext()
	local registryRef = v.registryRef
	local cacheRef = v.cacheRef
	local loadDescriptor = isLoadDescriptor(p) -- inferred equivalent call
	local load

	if loadDescriptor then
		load = p["$load"]
	else
		load = nil
	end

	local params

	if loadDescriptor then
		params = p.params
	else
		params = nil
	end

	local state, setState = React.useState(loadDescriptor and {
		data = nil,
		loading = true,
		error = nil
	} or { data = p, loading = false, error = nil })

	local state2, setState2 = React.useState(0)

	React.useEffect(function()
		if not loadDescriptor then
			setState({ data = p, loading = false, error = nil })
			return
		end

		local v2 = registryRef.current[load]

		if not v2 then
			setState({
				data = nil,
				loading = false,
				error = string.format("Loader \"%s\" not found in registry", load)
			})

			return
		end

		local v3 = cacheKey(load, params)
		local v4 = cacheRef.current[v3]

		if v4 then
			setState({ data = v4, loading = false, error = nil })
			return
		end

		local flag = false
		setState({ data = nil, loading = true, error = nil })

		v2.fetch(params or {}):andThen(function(p2)
			if flag then
				return
			end

			cacheRef.current[v3] = p2
			setState({ data = p2, loading = false, error = nil })
		end):catch(function(p2)
			if flag then
				return
			end

			setState({ data = nil, loading = false, error = tostring(p2) })
		end)

		return function()
			flag = true
		end
	end, { params, p, state2, loadDescriptor })

	local retry = React.useCallback(function()
		if not loadDescriptor then
			return
		end

		cacheRef.current[cacheKey(load, params)] = nil
		setState2(function(p2)
			return p2 + 1
		end)
	end, { p, params, loadDescriptor })

	return { data = state.data, loading = state.loading, error = state.error, retry = retry }
end

local UseLoader = {}
UseLoader.useLoader = useLoader

function UseLoader.useListLoader(p)
	local v = useLoader(p)

	return { data = v.data, loading = v.loading, error = v.error, retry = v.retry }
end

function UseLoader.useGroupedListLoader(p)
	local v = useLoader(p)

	return { data = v.data, loading = v.loading, error = v.error, retry = v.retry }
end

return UseLoader
