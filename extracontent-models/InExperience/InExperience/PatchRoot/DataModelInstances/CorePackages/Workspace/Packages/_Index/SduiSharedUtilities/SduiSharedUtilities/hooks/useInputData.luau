local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local React = require(SduiSharedUtilitiesParent.React)
local SignalsReact = require(SduiSharedUtilitiesParent.SignalsReact)
local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)

local function useInputData(s1: string, s2: string?) -- line: 9
	-- upvalues: React (copy), getSduiApiStore (copy), SignalsReact (copy)
	local v9 = React.useCallback(function(p1) -- line: 10
		-- upvalues: getSduiApiStore (copy), s1 (copy), s2 (copy)
		local v11 = getSduiApiStore()

		v11.getData(s1).status(p1)

		local getInputData = v11.getInputData

		if not getInputData then
			return nil
		end

		if s2 then
			local v13 = getInputData(s1, s2, p1)

			if v13 ~= nil then
				return v13
			end
		end

		return getInputData(s1, nil, p1)
	end, {
		s1,
		s2
	})

	return SignalsReact.useSignalState(v9)
end

return useInputData
