local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local HttpError = require(Modules.LuaApp.Http.HttpError)

return function(p1, p2) -- line: 12
	-- upvalues: Promise (copy), HttpError (copy)
	assert(type(p1) == "function", "Expected requestFunc to be a function")

	local n1 = 30

	if p2 then
		assert(type(p2) == "number", "Expected timout to be a number")
		assert(p2 > 0, "Expected timeout to be greater than or equal to 0")
		n1 = p2
	end

	return function(p3, p4, p5) -- line: 22
		-- upvalues: p1 (copy), Promise (copy), n1 (ref), HttpError (copy)
		local v10 = p1(p3, p4, p5)

		return (Promise.new(function(resolve, reject) -- line: 33
			-- upvalues: v10 (copy), n1 (ref), HttpError (copy), p3 (copy)
			v10:andThen(resolve, reject)
			delay(n1, function() -- line: 38
				-- upvalues: n1 (ref), reject (copy), HttpError (copy), p3 (copy)
				local v13 = string.format("Lua Timeout of %s seconds reached.", (tostring(n1)))

				reject(HttpError.new(p3, HttpError.Kind.LuaTimeout, v13))
			end)
		end))
	end
end
