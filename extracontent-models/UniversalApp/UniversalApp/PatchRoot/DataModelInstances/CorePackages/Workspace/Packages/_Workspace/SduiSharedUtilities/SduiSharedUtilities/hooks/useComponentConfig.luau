local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local React = require(SduiSharedUtilitiesParent.React)
local SignalsReact = require(SduiSharedUtilitiesParent.SignalsReact)

require(SduiSharedUtilitiesParent.SduiCoreSystem)

local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)

local function useComponentConfig(s1: string, s2: string?) -- line: 10
	-- upvalues: React (copy), getSduiApiStore (copy), SignalsReact (copy)
	local v9 = React.useCallback(function(p1) -- line: 12
		-- upvalues: s2 (copy), s1 (copy), getSduiApiStore (copy)
		local v11 = if not s2 then nil else `{ s1 }_{ s2 }`

		return getSduiApiStore().getRootConfig(s1, p1, v11)
	end, {
		s1,
		s2
	})

	return SignalsReact.useSignalState(v9)
end

return useComponentConfig
