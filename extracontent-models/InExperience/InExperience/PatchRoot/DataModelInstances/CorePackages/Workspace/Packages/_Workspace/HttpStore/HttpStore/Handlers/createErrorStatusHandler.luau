local parent = script.Parent.Parent

local parent2 = parent.Parent
local Signals = require(parent2.Signals)
require(parent2.InternalHttpStore)
require(parent.Types)

local function createErrorStatusHandler(p)
	return function(callback)
		return Signals.createComputed(function(p2)
			local v = callback(p2)

			if v.status == "Success" then
				local statusCode = v.response.StatusCode

				if p[statusCode] ~= nil then
					p[statusCode](v)
				end
			end

			return v
		end)
	end
end

return createErrorStatusHandler
