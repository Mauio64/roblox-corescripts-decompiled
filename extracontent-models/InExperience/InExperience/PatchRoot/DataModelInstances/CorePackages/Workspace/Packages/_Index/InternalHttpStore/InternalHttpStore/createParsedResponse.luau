local parent = script.Parent
local parent2 = parent.Parent

local Signals = require(parent2.Signals)
require(parent2.HttpSignals)

require(parent.HttpStoreTypes)

local function createParsedResponse(callback, config)
	return Signals.createComputed(function(p)
		local v = callback(p)

		if v.status == "success" then
			return { status = "Success", config = config, response = v.data }
		end

		if v.status ~= "error" then
			return { status = "Fetching", config = config }
		end

		return { status = "Failed", config = config, response = v.error }
	end)
end

return createParsedResponse
