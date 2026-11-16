local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SignalsReact")

local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiApiStore")

local function useInputData(p2, p3)
	local v5 = React.useCallback(function(p4)
		local v6 = getSduiApiStore()
		v6.getData(p2).status(p4)

		local getInputData = v6.getInputData

		if not getInputData then
			return nil
		end

		if p3 then
			local inputData = getInputData(p2, p3, p4)

			if inputData ~= nil then
				return inputData
			end
		end

		return getInputData(p2, nil, p4)
	end, { p2, p3 })

	return SignalsReact.useSignalState(v5)
end

return useInputData
