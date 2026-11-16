local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)

local function useEntrySurfacing(p: string, p2: string?, p3: string)
	local v = React.useCallback(function(p4)
		local v

		if p2 then
			v = `{p}_{p2}`
		end

		local entrySurfacing = getSduiApiStore().getEntrySurfacing(p, v, p4)
		return entrySurfacing and entrySurfacing[p3]
	end, { p, p2, p3 })

	return SignalsReact.useSignalState(v)
end

return useEntrySurfacing
