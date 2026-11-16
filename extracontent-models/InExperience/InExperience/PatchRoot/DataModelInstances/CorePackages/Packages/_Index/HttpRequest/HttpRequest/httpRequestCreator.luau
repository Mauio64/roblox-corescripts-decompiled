local parent = script:FindFirstAncestor("HttpRequest").Parent
local Promise = require(parent.Promise)

local HttpRequest = require(script.Parent.HttpRequest)

return function(p)
	assert(type(p.requestFunction) == "function", "Expected requestFunction to be a function")

	return function(value, value2, p2)
		assert(type(value) == "string", "Expected url to be a string")
		assert(type(value2) == "string", "Expected requestMethod to be a string")
		assert(not p2 or type(p2) == "table", "Expected options to be a table")
		local v = string.upper(value2)

		local v2 = HttpRequest.new(p, value, v, p2)

		local function cancel()
			v2:cancel()
		end

		return Promise.new(function(p3, p4)
			coroutine.wrap(function()
				v2:start(p3, p4)
			end)()
		end), cancel
	end
end
