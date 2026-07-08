local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local React = require(SduiSharedUtilitiesParent.React)
local SignalsReact = require(SduiSharedUtilitiesParent.SignalsReact)
local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)

local function useDataUpdatedTimestamp(s1: string, s2: string?) -- line: 7
	-- upvalues: React (copy), getSduiApiStore (copy), SignalsReact (copy)
	local v9 = React.useCallback(function(p1) -- line: 8
		-- upvalues: s2 (copy), s1 (copy), getSduiApiStore (copy)
		local v11 = if not s2 then nil else `{ s1 }_{ s2 }`

		return getSduiApiStore().getDataUpdatedTimestamp(s1, p1, v11)
	end, {
		s1,
		s2
	})

	return SignalsReact.useSignalState(v9)
end

return useDataUpdatedTimestamp
