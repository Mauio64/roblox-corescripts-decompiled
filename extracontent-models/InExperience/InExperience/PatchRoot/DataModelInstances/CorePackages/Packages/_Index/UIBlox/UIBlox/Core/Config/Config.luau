local Config = {}

function Config.new(defaultConfig)
	local v = {}
	v.defaultConfig = defaultConfig
	v.defaultConfigKeys = {}

	for k in pairs(defaultConfig) do
		table.insert(v.defaultConfigKeys, k)
	end

	v._currentConfig = setmetatable({}, {
		__index = function(_, p)
			local formatted = ("Invalid global configuration key %q. Valid configuration keys are: %s"):format(
				tostring(p),
				table.concat(v.defaultConfigKeys, ", ")
			)

			error(formatted, 3)
		end
	})

	function v.set(...)
		return Config.set(v, ...)
	end

	function v.get(...)
		return Config.get(v, ...)
	end

	function v.scoped(...)
		return Config.scoped(v, ...)
	end

	v.set(defaultConfig)

	return v
end

function Config:set(items)
	local v = {}
	local v2 = {}

	for k, item in pairs(items) do
		if self.defaultConfig[k] == nil then
			table.insert(v2, k)
		elseif typeof(item) == "boolean" then
			self._currentConfig[k] = item
		else
			table.insert(v, tostring(k) .. " (type " .. typeof(item) .. ")")
		end
	end

	if next(v2) ~= nil then
		local formatted = ("Invalid global configuration keys %s. Valid configuration keys are: %s"):format(
			table.concat(v2, ", "),
			table.concat(self.defaultConfigKeys, ", ")
		)

		error(formatted, 3)
	end

	if next(v) ~= nil then
		local formatted = ("Invalid global configuration types for keys %s. All configuration values must be boolean."):format(table.concat(v, ", "))

		error(formatted, 3)
	end
end

function Config:get()
	return self._currentConfig
end

return Config
