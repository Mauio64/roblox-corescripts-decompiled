local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Signals = require(scriptParentParent.Signals)

require(scriptParentParent.HttpSignals)
require(scriptParent.HttpStoreTypes)

local function createParsedResponse(p1, p2) -- line: 13
	-- upvalues: Signals (copy)
	return Signals.createComputed(function(p3) -- line: 17
		-- upvalues: p1 (copy), p2 (copy)
		local v8 = p1(p3)

		if v8.status == "success" then
			local data = v8.data

			return {
				status = "Success",
				config = p2,
				response = data
			}
		end

		if v8.status == "error" then
			local error = v8.error

			return {
				status = "Failed",
				config = p2,
				response = error
			}
		end

		return {
			status = "Fetching",
			config = p2
		}
	end)
end

return createParsedResponse
