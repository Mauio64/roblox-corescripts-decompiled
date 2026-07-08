local Parent = script:FindFirstAncestor("HttpRequest").Parent
local Promise = require(Parent.Promise)
local HttpRequest = require(script.Parent.HttpRequest)

return function(p1) -- line: 6
	-- upvalues: HttpRequest (copy), Promise (copy)
	assert(type(p1.requestFunction) == "function", "Expected requestFunction to be a function")

	return function(p2, p3, p4) -- line: 9
		-- upvalues: HttpRequest (copy), p1 (copy), Promise (copy)
		assert(type(p2) == "string", "Expected url to be a string")
		assert(type(p3) == "string", "Expected requestMethod to be a string")
		assert(not p4 or type(p4) == "table", "Expected options to be a table")

		local v8 = string.upper(p3)
		local v9 = HttpRequest.new(p1, p2, v8, p4)

		local function cancel() -- line: 23
			-- upvalues: v9 (copy)
			v9:cancel()
		end

		return Promise.new(function(resolve, reject) -- line: 17
			-- upvalues: v9 (copy)
			coroutine.wrap(function() -- line: 18
				-- upvalues: v9 (copy), resolve (copy), reject (copy)
				v9:start(resolve, reject)
			end)()
		end), cancel
	end
end
