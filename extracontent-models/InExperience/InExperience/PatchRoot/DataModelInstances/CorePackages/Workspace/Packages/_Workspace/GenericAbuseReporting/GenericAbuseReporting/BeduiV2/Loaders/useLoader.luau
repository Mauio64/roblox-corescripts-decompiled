local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local React = require(GenericAbuseReportingParent.React)
local LoaderContext = require(script.Parent.LoaderContext)
local FFlagAbuseReportDensifyResolvedArrays = require(GenericAbuseReporting.Flags.FFlagAbuseReportDensifyResolvedArrays)

local function isLoadDescriptor(p1) -- line: 21
	return typeof(p1) == "table" and p1["$load"] ~= nil
end
local function cacheKey(s1: string, t1: {[any]: any}?) -- line: 28
	if not t1 then
		return s1 .. "::{}"
	end

	local t2 = {}

	for k in pairs(t1) do
		table.insert(t2, k)
	end

	table.sort(t2)

	local t3 = {}

	for _, v in ipairs(t2) do
		table.insert(t3, v .. "=" .. t1[v])
	end

	return s1 .. "::" .. table.concat(t3, ",")
end
local function useLoader(p2) -- line: 62
	-- upvalues: LoaderContext (copy), React (copy), cacheKey (copy)
	local v19 = LoaderContext.useLoaderContext()
	local registryRef = v19.registryRef
	local cacheRef = v19.cacheRef
	local v22 = typeof(p2) == "table" and p2["$load"] ~= nil
	local v23 = if not v22 then nil else p2["$load"]
	local v24 = if not v22 then nil else p2.params
	local v25, v26 = React.useState(if not v22 then {
		loading = false,
		error = nil,
		data = p2
	} else {
		data = nil,
		loading = true,
		error = nil
	})
	local v27, v28 = React.useState(0)

	React.useEffect(function() -- line: 78
		-- upvalues: v22 (copy), v26 (copy), p2 (copy), registryRef (copy), v23 (copy), cacheKey (copy), v24 (copy), cacheRef (copy)
		if not v22 then
			v26({
				loading = false,
				error = nil,
				data = p2
			})

			return
		end

		local v34 = registryRef.current[v23]

		if not v34 then
			v26({
				data = nil,
				loading = false,
				error = string.format("Loader \"%s\" not found in registry", v23)
			})

			return
		end

		local v35 = cacheKey(v23, v24)
		local v36 = cacheRef.current[v35]

		if v36 then
			v26({
				loading = false,
				error = nil,
				data = v36
			})

			return
		end

		local u37 = false

		v26({
			data = nil,
			loading = true,
			error = nil
		})
		v34.fetch(v24 or {}):andThen(function(p3) -- line: 109
			-- upvalues: u37 (ref), cacheRef (copy), v35 (copy), v26 (copy)
			if u37 then
				return
			end

			cacheRef.current[v35] = p3
			v26({
				loading = false,
				error = nil,
				data = p3
			})
		end):catch(function(p4) -- line: 116
			-- upvalues: u37 (ref), v26 (copy)
			if u37 then
				return
			end

			v26({
				data = nil,
				loading = false,
				error = tostring(p4)
			})
		end)

		return function() -- line: 127
			-- upvalues: u37 (ref)
			u37 = true
		end
	end, {
		v24,
		p2,
		v27,
		v22
	})

	local v29 = React.useCallback(function() -- line: 133
		-- upvalues: v22 (copy), cacheRef (copy), cacheKey (copy), v23 (copy), v24 (copy), v28 (copy)
		if not v22 then
			return
		end

		cacheRef.current[cacheKey(v23, v24)] = nil
		v28(function(p5) -- line: 138
			return p5 + 1
		end)
	end, {
		p2,
		v24,
		v22
	})

	return {
		data = v25.data,
		loading = v25.loading,
		error = v25.error,
		retry = v29
	}
end

return {
	useLoader = useLoader,
	useListLoader = function(p6) -- line: 157
		-- upvalues: useLoader (copy), React (copy), FFlagAbuseReportDensifyResolvedArrays (copy), Dash (copy)
		local v31 = useLoader(p6)

		return {
			data = React.useMemo(function() -- line: 159
				-- upvalues: v31 (copy), FFlagAbuseReportDensifyResolvedArrays (copy), Dash (copy)
				if not v31.data then
					return nil
				end

				local data = v31.data

				if FFlagAbuseReportDensifyResolvedArrays then
					return data
				end

				return (Dash.values(data))
			end, { v31.data }),
			loading = v31.loading,
			error = v31.error,
			retry = v31.retry
		}
	end,
	useGroupedListLoader = function(p7) -- line: 181
		-- upvalues: useLoader (copy), React (copy), FFlagAbuseReportDensifyResolvedArrays (copy), Dash (copy)
		local v33 = useLoader(p7)

		return {
			data = React.useMemo(function() -- line: 183
				-- upvalues: v33 (copy), FFlagAbuseReportDensifyResolvedArrays (copy), Dash (copy)
				if not v33.data then
					return nil
				end

				local data = v33.data

				if FFlagAbuseReportDensifyResolvedArrays then
					return data
				end

				return (Dash.map(Dash.values(data), function(p8) -- line: 193
					-- upvalues: Dash (copy)
					if p8.items then
						return Dash.join(p8, {
							items = Dash.values(p8.items)
						})
					end

					return p8
				end))
			end, { v33.data }),
			loading = v33.loading,
			error = v33.error,
			retry = v33.retry
		}
	end
}
