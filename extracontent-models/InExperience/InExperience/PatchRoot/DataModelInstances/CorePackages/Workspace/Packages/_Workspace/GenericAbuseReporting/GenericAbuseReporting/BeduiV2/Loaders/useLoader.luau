local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Dash = require(Parent.Dash)
local React = require(Parent.React)
local LoaderContext = require(script.Parent.LoaderContext)

local function isLoadDescriptor(p1) -- line: 20
	return typeof(p1) == "table" and p1["$load"] ~= nil
end
local function cacheKey(s1: string, t1: {[any]: any}?) -- line: 27
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
local function useLoader(p2) -- line: 61
	-- upvalues: LoaderContext (copy), React (copy), cacheKey (copy)
	local v17 = LoaderContext.useLoaderContext()
	local registryRef = v17.registryRef
	local cacheRef = v17.cacheRef
	local v20 = typeof(p2) == "table" and p2["$load"] ~= nil
	local v21 = if not v20 then nil else p2["$load"]
	local v22 = if not v20 then nil else p2.params
	local v23, v24 = React.useState(if not v20 then {
		loading = false,
		error = nil,
		data = p2
	} else {
		data = nil,
		loading = true,
		error = nil
	})
	local v25, v26 = React.useState(0)

	React.useEffect(function() -- line: 77
		-- upvalues: v20 (copy), v24 (copy), p2 (copy), registryRef (copy), v21 (copy), cacheKey (copy), v22 (copy), cacheRef (copy)
		if not v20 then
			v24({
				loading = false,
				error = nil,
				data = p2
			})

			return
		end

		local v32 = registryRef.current[v21]

		if not v32 then
			v24({
				data = nil,
				loading = false,
				error = string.format("Loader \"%s\" not found in registry", v21)
			})

			return
		end

		local v33 = cacheKey(v21, v22)
		local v34 = cacheRef.current[v33]

		if v34 then
			v24({
				loading = false,
				error = nil,
				data = v34
			})

			return
		end

		local u35 = false

		v24({
			data = nil,
			loading = true,
			error = nil
		})
		v32.fetch(v22 or {}):andThen(function(p3) -- line: 108
			-- upvalues: u35 (ref), cacheRef (copy), v33 (copy), v24 (copy)
			if u35 then
				return
			end

			cacheRef.current[v33] = p3
			v24({
				loading = false,
				error = nil,
				data = p3
			})
		end):catch(function(p4) -- line: 115
			-- upvalues: u35 (ref), v24 (copy)
			if u35 then
				return
			end

			v24({
				data = nil,
				loading = false,
				error = tostring(p4)
			})
		end)

		return function() -- line: 126
			-- upvalues: u35 (ref)
			u35 = true
		end
	end, {
		v22,
		p2,
		v25,
		v20
	})

	local v27 = React.useCallback(function() -- line: 132
		-- upvalues: v20 (copy), cacheRef (copy), cacheKey (copy), v21 (copy), v22 (copy), v26 (copy)
		if not v20 then
			return
		end

		cacheRef.current[cacheKey(v21, v22)] = nil
		v26(function(p5) -- line: 137
			return p5 + 1
		end)
	end, {
		p2,
		v22,
		v20
	})

	return {
		data = v23.data,
		loading = v23.loading,
		error = v23.error,
		retry = v27
	}
end

return {
	useLoader = useLoader,
	useListLoader = function(p6) -- line: 157
		-- upvalues: useLoader (copy), React (copy), Dash (copy)
		local v29 = useLoader(p6)

		return {
			data = React.useMemo(function() -- line: 159
				-- upvalues: v29 (copy), Dash (copy)
				if not v29.data then
					return nil
				end

				return Dash.values(v29.data)
			end, { v29.data }),
			loading = v29.loading,
			error = v29.error,
			retry = v29.retry
		}
	end,
	useGroupedListLoader = function(p7) -- line: 181
		-- upvalues: useLoader (copy), React (copy), Dash (copy)
		local v31 = useLoader(p7)

		return {
			data = React.useMemo(function() -- line: 183
				-- upvalues: v31 (copy), Dash (copy)
				if not v31.data then
					return nil
				end

				return (Dash.map(Dash.values(v31.data), function(p8) -- line: 187
					-- upvalues: Dash (copy)
					if p8.items then
						return Dash.join(p8, {
							items = Dash.values(p8.items)
						})
					end

					return p8
				end))
			end, { v31.data }),
			loading = v31.loading,
			error = v31.error,
			retry = v31.retry
		}
	end
}
