local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
require(parent.SduiCoreSystem)
local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)

local function useComponentConfig(p: string, p2: string?)
	local v = React.useCallback(function(p3)
		local v

		if p2 then
			v = `{p}_{p2}`
		end

		return getSduiApiStore().getRootConfig(p, p3, v)
	end, { p, p2 })

	return SignalsReact.useSignalState(v)
end

return useComponentConfig
