local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local LoaderContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Loaders/LoaderContext")

local function isLoadDescriptor(p2): boolean
	return typeof(p2) == "table" and p2["$load"] ~= nil
end

local function cacheKey(load, params)
	if not params then
		return load .. "::{}"
	end

	local v5 = {}

	for k in pairs(params) do
		table.insert(v5, k)
	end

	table.sort(v5)
	local v6 = {}

	for i, v7 in ipairs(v5) do
		table.insert(v6, v7 .. "=" .. params[v7])
	end

	return load .. "::" .. table.concat(v6, ",")
end

local function useLoader(p2)
	local v5 = LoaderContext.useLoaderContext()
	local registryRef = v5.registryRef
	local cacheRef = v5.cacheRef
	local v6 = typeof(p2) == "table" and p2["$load"] ~= nil

	local load = if v6 then p2["$load"] else nil
	local params = if v6 then p2.params else nil

	local state, setState = React.useState(v6 and {
		data = nil,
		loading = true,
		error = nil
	} or { data = p2, loading = false, error = nil })

	local state2, setState2 = React.useState(0)

	React.useEffect(function()
		if not v6 then
			setState({ data = p2, loading = false, error = nil })
			return
		end

		local v7 = registryRef.current[load]

		if not v7 then
			setState({
				data = nil,
				loading = false,
				error = string.format("Loader \"%s\" not found in registry", load)
			})

			return
		end

		local v8 = cacheKey(load, params)
		local v9 = cacheRef.current[v8]

		if v9 then
			setState({ data = v9, loading = false, error = nil })
			return
		end

		local flag = false
		setState({ data = nil, loading = true, error = nil })

		v7.fetch(params or {}):andThen(function(p3)
			if flag then
				return
			end

			cacheRef.current[v8] = p3
			setState({ data = p3, loading = false, error = nil })
		end):catch(function(p3)
			if flag then
				return
			end

			setState({ data = nil, loading = false, error = tostring(p3) })
		end)

		return function()
			flag = true
		end
	end, { params, p2, state2, v6 })

	local v7 = React.useCallback(function()
		if not v6 then
			return
		end

		cacheRef.current[cacheKey(load, params)] = nil
		setState2(function(p3)
			return p3 + 1
		end)
	end, { p2, params, v6 })

	return {
		data = state.data,
		loading = state.loading,
		error = state.error,
		retry = v7
	}
end

return {
	useLoader = useLoader,
	useListLoader = function(p2)
		local v5 = useLoader(p2)

		return {
			data = v5.data,
			loading = v5.loading,
			error = v5.error,
			retry = v5.retry
		}
	end,
	useGroupedListLoader = function(p2)
		local v5 = useLoader(p2)

		return {
			data = v5.data,
			loading = v5.loading,
			error = v5.error,
			retry = v5.retry
		}
	end
}
