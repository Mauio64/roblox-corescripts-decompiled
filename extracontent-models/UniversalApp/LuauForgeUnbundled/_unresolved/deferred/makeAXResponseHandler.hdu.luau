local module = require("@luauforge/deferred/hdq")
local sendAXStat = module.sendAXStat
local sendAXCounterV2 = module.sendAXCounterV2
require("@luauforge/deferred/hdt")

local function makeAXResponseHandler(object, p2, p3)
	local latencyCounter = if p3 then p3.latencyCounter else nil
	local modelMismatchCounter = if p3 then p3.modelMismatchCounter else nil

	local now = if latencyCounter then os.clock() else nil
	return object:andThen(function(p4)
		if latencyCounter and now then
			sendAXStat({
				statName = latencyCounter,
				deltaMs = (os.clock() - now) * 1000
			})
		end

		local v6 = if p4 then p4.responseBody else nil
		local v7, v8 = p2(v6)

		if v8 and modelMismatchCounter then
			sendAXCounterV2(modelMismatchCounter)
		end

		return v7
	end)
end

return makeAXResponseHandler
