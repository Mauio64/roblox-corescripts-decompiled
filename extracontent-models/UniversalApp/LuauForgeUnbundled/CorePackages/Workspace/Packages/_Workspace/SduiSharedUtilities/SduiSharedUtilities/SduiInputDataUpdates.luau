local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiApiStore")

return {
	findInputData = function(p2, callback)
		local inputData = nil
		getSduiApiStore().forEachInputData(p2, function(p3, p4): boolean
			if not callback(p4) then
				return false
			end

			inputData = p4
			return true
		end)

		return inputData
	end,
	updateInputDataField = function(p2, callback, p3, callback2)
		local v5 = getSduiApiStore()
		local v6 = false
		v5.forEachInputData(p2, function(p4, p5): boolean
			if not callback(p5) then
				return false
			end

			local v7 = p5[p3]

			if v7 ~= nil then
				v6 = v5.setInputDataField(p2, p4, p3, callback2(v7))
			end

			return true
		end)

		return v6
	end
}
