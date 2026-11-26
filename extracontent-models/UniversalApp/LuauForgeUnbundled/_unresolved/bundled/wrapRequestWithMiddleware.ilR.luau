local module = require("@luauforge/bundled/ilS")
local module2 = require("@luauforge/bundled/ilV")
local module3 = require("@luauforge/bundled/imd")
local defineFastFlag = game:DefineFastFlag("SilentlyFailIfChallenge", true)

local function wrapRequestWithChallengeMiddleware(callback, object)
	local function makeRequest(p2, p3, p4)
		local v5, v6 = callback(p2, p3, p4)

		return v5:andThen(nil, function(p5)
			return object:dispatch(module2(callback, p2, p3, p4, p5))
		end), v6
	end

	return makeRequest
end

local function wrapRequestWithMiddleware(callback, object, p2)
	local function makeRequest(p3, p4, p5, p6)
		local v5, v6 = callback(p3, p4, p5)

		if defineFastFlag and p6 then
			return v5, v6
		end

		return v5:andThen(nil, function(p7)
			if not module3() then
				return object:dispatch(module(callback, p3, p7, p2))
			end

			local v7 = callback
			local v8 = object

			local function makeRequest2(p8, p9, p10)
				local v9, v10 = v7(p8, p9, p10)

				return v9:andThen(nil, function(p11)
					return v8:dispatch(module2(v7, p8, p9, p10, p11))
				end), v10
			end

			return object:dispatch(module(makeRequest2, p3, p7, p2))
		end):andThen(nil, function(p7)
			return object:dispatch(module2(callback, p3, p4, p5, p7))
		end), v6
	end

	return makeRequest
end

return wrapRequestWithMiddleware
