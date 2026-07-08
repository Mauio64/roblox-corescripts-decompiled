local t1 = {}

function t1.new(p1) -- line: 19
	-- upvalues: t1 (copy)
	local t2 = {
		defaultConfig = p1,
		defaultConfigKeys = {}
	}

	for k in pairs(p1) do
		table.insert(t2.defaultConfigKeys, k)
	end

	t2._currentConfig = setmetatable({}, {
		__index = function(_, p3) -- line: 29
			-- upvalues: t2 (copy)
			local v16 = ("Invalid global configuration key %q. Valid configuration keys are: %s"):format(tostring(p3), table.concat(t2.defaultConfigKeys, ", "))

			error(v16, 3)
		end
	})

	function t2.set(...) -- line: 42
		-- upvalues: t1 (copy), t2 (copy)
		return t1.set(t2, ...)
	end
	function t2.get(...) -- line: 46
		-- upvalues: t1 (copy), t2 (copy)
		return t1.get(t2, ...)
	end
	function t2.scoped(...) -- line: 50
		-- upvalues: t1 (copy), t2 (copy)
		return t1.scoped(t2, ...)
	end

	t2.set(p1)

	return t2
end
function t1.set(p4, p5) -- line: 59
	local t3 = {}
	local t4 = {}

	for k, v in pairs(p5) do
		if p4.defaultConfig[k] == nil then
			table.insert(t3, k)
		elseif typeof(v) ~= "boolean" then
			table.insert(t4, tostring(k) .. " (type " .. typeof(v) .. ")")
		else
			p4._currentConfig[k] = v
		end
	end

	if next(t3) ~= nil then
		local v11 = ("Invalid global configuration keys %s. Valid configuration keys are: %s"):format(table.concat(t3, ", "), table.concat(p4.defaultConfigKeys, ", "))

		error(v11, 3)
	end

	if next(t4) ~= nil then
		local v12 = ("Invalid global configuration types for keys %s. All configuration values must be boolean."):format(table.concat(t4, ", "))

		error(v12, 3)
	end
end
function t1.get(p6) -- line: 98
	return p6._currentConfig
end

return t1
