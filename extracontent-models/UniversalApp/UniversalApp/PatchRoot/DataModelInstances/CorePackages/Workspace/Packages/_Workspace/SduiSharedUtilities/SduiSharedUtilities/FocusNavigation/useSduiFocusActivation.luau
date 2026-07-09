local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(Parent.React)
local getSduiFocusActivationStore = require(script.Parent.getSduiFocusActivationStore)

local function useSduiFocusActivation(s1: string?, p1: ((...any) -> ...any)?) -- line: 10
	-- upvalues: React (copy), getSduiFocusActivationStore (copy)
	React.useEffect(function() -- line: 11
		-- upvalues: s1 (copy), p1 (copy), getSduiFocusActivationStore (copy)
		if s1 == nil or p1 == nil then
			return
		end

		return getSduiFocusActivationStore().register(s1, p1)
	end, {
		s1,
		p1
	})
end

return useSduiFocusActivation
