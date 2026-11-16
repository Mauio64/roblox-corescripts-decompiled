local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)
local SduiInputDataUpdates = {}

function SduiInputDataUpdates.findInputData(p: string, callback)
	local inputData = nil
	getSduiApiStore().forEachInputData(p, function(_, p2): boolean
		if not callback(p2) then
			return false
		end

		inputData = p2
		return true
	end)

	return inputData
end

function SduiInputDataUpdates.updateInputDataField(p: string, callback, p2: string, callback2)
	local sduiApiStore = getSduiApiStore()
	local v = false
	sduiApiStore.forEachInputData(p, function(p3, p4): boolean
		if not callback(p4) then
			return false
		end

		local v2 = p4[p2]

		if v2 ~= nil then
			v = sduiApiStore.setInputDataField(p, p3, p2, callback2(v2))
		end

		return true
	end)

	return v
end

return SduiInputDataUpdates
