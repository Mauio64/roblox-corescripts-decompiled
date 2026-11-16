local Symbol = require(script.Parent.Symbol)

local named = Symbol.named("ThunkTag")
local Thunk = {}

function Thunk.middleware(options)
	local v = options or {}

	return function(callback, p)
		return function(callback2)
			if callback2[named] ~= true then
				return callback(callback2)
			end

			local v2 = {}

			for _, requiredService in pairs(callback2.requiredServices) do
				local v3 = v[requiredService]

				if v3 == nil then
					error(("Service with key %s is a dependency but was not provided"):format(requiredService))
				end

				v2[requiredService] = v3
			end

			return callback2(p, v2)
		end
	end
end

function Thunk.new(value, options, callback)
	assert(typeof(value) == "string", "Bad arg #1: name must be a string")
	assert(options == nil or typeof(options) == "table", "Bad arg #2: requiredServices must be a table or nil")

	assert(typeof(callback) == "function", "Bad arg #3: onInvoke must be a function")

	return (setmetatable({
		[named] = true,
		type = value,
		requiredServices = options or {}
	}, {
		__call = function(_, ...)
			callback(...)
		end
	}))
end

function Thunk.test(callback, p, p2)
	local v = typeof(callback) == "table" and callback[named] == true
	assert(v, "Test Error - Bad arg #1: Must provide a valid thunk")

	if #callback.requiredServices > 0 then
		for _, requiredService in ipairs(callback.requiredServices) do
			assert(
				p2[requiredService] ~= nil,
				"Test Error - Bad arg #3: Missing required service " .. tostring(requiredService)
			)
		end
	end

	return callback(p, p2)
end

return Thunk
