local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local React = require(parent.React)

local getSduiFocusActivationStore = require(script.Parent.getSduiFocusActivationStore)

local function useSduiFocusActivation(p: string?, callback)
	React.useEffect(function()
		if p == nil or callback == nil then
			return
		end

		return getSduiFocusActivationStore().register(p, callback)
	end, { p, callback })
end

return useSduiFocusActivation
