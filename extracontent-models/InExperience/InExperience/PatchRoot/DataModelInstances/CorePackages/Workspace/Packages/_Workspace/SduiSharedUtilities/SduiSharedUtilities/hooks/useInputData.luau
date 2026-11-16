local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)

local function useInputData(p: string, p2: string?)
	local v = React.useCallback(function(p3)
		local sduiApiStore = getSduiApiStore()
		sduiApiStore.getData(p).status(p3)

		local getInputData = sduiApiStore.getInputData

		if not getInputData then
			return nil
		end

		if p2 then
			local inputData = getInputData(p, p2, p3)

			if inputData ~= nil then
				return inputData
			end
		end

		return getInputData(p, nil, p3)
	end, { p, p2 })

	return SignalsReact.useSignalState(v)
end

return useInputData
