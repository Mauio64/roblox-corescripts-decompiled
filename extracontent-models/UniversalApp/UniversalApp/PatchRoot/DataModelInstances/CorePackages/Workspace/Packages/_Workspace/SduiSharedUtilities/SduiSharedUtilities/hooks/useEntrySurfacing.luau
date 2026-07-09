local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local React = require(SduiSharedUtilitiesParent.React)
local SignalsReact = require(SduiSharedUtilitiesParent.SignalsReact)
local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)

local function useEntrySurfacing(s1: string, s2: string?, s3: string) -- line: 14
	-- upvalues: React (copy), getSduiApiStore (copy), SignalsReact (copy)
	local v10 = React.useCallback(function(p1) -- line: 15
		-- upvalues: s2 (copy), s1 (copy), getSduiApiStore (copy), s3 (copy)
		local v12 = if not s2 then nil else `{ s1 }_{ s2 }`
		local v13 = getSduiApiStore().getEntrySurfacing(s1, v12, p1)

		return v13 and v13[s3]
	end, {
		s1,
		s2,
		s3
	})

	return SignalsReact.useSignalState(v10)
end

return useEntrySurfacing
