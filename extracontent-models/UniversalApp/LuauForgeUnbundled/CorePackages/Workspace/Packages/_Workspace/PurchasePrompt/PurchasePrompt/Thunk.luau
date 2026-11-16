local named = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Symbols/Symbol").named("ThunkTag")
return {
	middleware = function(options)
		local v6 = options or {}

		return function(callback, p2)
			return function(callback2)
				if callback2[named] ~= true then
					return callback(callback2)
				end

				local v7 = {}

				for k, requiredService in pairs(callback2.requiredServices) do
					local v8 = v6[requiredService]

					if v8 == nil then
						error(("Service with key %s is a dependency but was not provided"):format((tostring(requiredService))))
					end

					v7[requiredService] = v8
				end

				return callback2(p2, v7)
			end
		end
	end,
	new = function(value, options, callback)
		assert(typeof(value) == "string", "Bad arg #1: name must be a string")
		assert(
			options == nil or typeof(options) == "table",
			"Bad arg #2: requiredServices must be a table or nil"
		)

		assert(typeof(callback) == "function", "Bad arg #3: onInvoke must be a function")

		return (setmetatable({
			[named] = true,
			type = value,
			requiredServices = options or {}
		}, {
			__call = function(p2, ...)
				return callback(...)
			end
		}))
	end,
	test = function(self, p2, p3)
		local v6 = typeof(self) == "table" and self[named] == true
		assert(v6, "Test Error - Bad arg #1: Must provide a valid thunk")

		if #self.requiredServices > 0 then
			for i, requiredService in ipairs(self.requiredServices) do
				assert(
					p3[requiredService] ~= nil,
					"Test Error - Bad arg #3: Missing required service " .. tostring(requiredService)
				)
			end
		end

		return self(p2, p3)
	end
}
