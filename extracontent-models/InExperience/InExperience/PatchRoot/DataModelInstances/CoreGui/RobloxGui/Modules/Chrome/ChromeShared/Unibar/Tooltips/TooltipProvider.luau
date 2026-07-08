local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local TooltipContext = require(script.Parent.TooltipContext)

function TooltipProvider(p1) -- line: 29
	-- upvalues: React (copy), TooltipContext (copy)
	local v5, v6 = React.useState(nil)
	local v7 = React.useRef(nil)
	local v8 = React.useRef(nil)
	local v9 = React.useRef(nil)
	local v10 = React.useRef({})
	local v11 = React.useCallback(function(t1: {[any]: any}?) -- line: 40
		-- upvalues: v6 (copy), v7 (copy), v8 (copy)
		v6(t1)
		v7.current = t1

		if v7.current and (v8.current and v7.current.id == v8.current.id) then
			v8.current = nil
		end
	end, {})
	local v12 = React.useCallback(function(s1: string) -- line: 52
		-- upvalues: v7 (copy), v11 (copy), v8 (copy), v10 (copy)
		if v7 and (v7.current and s1 == v7.current.id) then
			v11(nil)
		end

		if v8 and v8.current and s1 == v8.current.id then
			v8.current = nil
		end

		local v16 = nil

		for _, v in pairs(v10.current) do
			if s1 == v.id then
				v16 = v

				break
			end
		end

		if v16 and v16.priority and v10.current[v16.priority] then
			v10.current[v16.priority] = nil
		end
	end, { v5 })

	v9.current = React.useCallback(function() -- line: 73
		-- upvalues: v7 (copy), v8 (copy), v10 (copy), v11 (copy), v12 (copy), v9 (copy)
		if v7.current or v8.current then
			return
		end

		local current = v10.current
		local t2 = {}

		for _, v in pairs(current) do
			table.insert(t2, v)
		end

		table.sort(t2, function(t3: {[any]: any}, t4: {[any]: any}) -- line: 85
			return t3.priority > t4.priority
		end)

		local v23 = t2[1]

		if not v23 then
			return
		end

		v8.current = v23
		task.delay(v23.showDelay / 1000, function() -- line: 96
			-- upvalues: v11 (copy), v23 (copy), v12 (copy), v9 (copy)
			v11(v23)
			task.delay(v23.dismissDelay / 1000, function() -- line: 99
				-- upvalues: v12 (copy), v23 (copy), v9 (copy)
				v12(v23.id)

				if v9.current then
					v9.current()
				end
			end)
		end)
	end, { v5 })

	local v13 = React.useMemo(function() -- line: 114
		-- upvalues: v10 (copy), v9 (copy), v12 (copy), v5 (copy)
		return {
			registerTooltip = function(s2: string, n1: number, n2: number, n3: number) -- line: 116
				-- upvalues: v10 (copy), v9 (copy)
				if not v10.current[n1] then
					table.insert(v10.current, n1, {
						id = s2,
						priority = n1,
						showDelay = n2,
						dismissDelay = n3
					})

					if v9.current then
						v9.current()
					end
				end
			end,
			unregisterTooltip = function(s3: string) -- line: 127
				-- upvalues: v12 (copy), v9 (copy)
				v12(s3)

				if v9.current then
					v9.current()
				end
			end,
			dismissTooltip = function(s4: string, _: string?) -- line: 131
				-- upvalues: v12 (copy), v9 (copy)
				v12(s4)

				if v9.current then
					v9.current()
				end
			end,
			isCurrentTooltip = function(s6: string) -- line: 135
				-- upvalues: v5 (copy)
				return v5 and s6 == v5.id
			end
		}
	end, { v5 })

	return React.createElement(TooltipContext.Provider, {
		value = v13
	}, p1.children)
end

return TooltipProvider
