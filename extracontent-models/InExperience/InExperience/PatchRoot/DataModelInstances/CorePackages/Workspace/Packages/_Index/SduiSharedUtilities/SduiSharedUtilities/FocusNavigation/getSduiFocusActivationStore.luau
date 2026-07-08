local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local createSduiFocusActivationStore = require(SduiSharedUtilities.FocusNavigation.createSduiFocusActivationStore)
local u3 = nil

local function getSduiFocusActivationStore() -- line: 8
	-- upvalues: u3 (ref), createSduiFocusActivationStore (copy)
	if u3 == nil then
		u3 = createSduiFocusActivationStore()
	end

	return u3
end

return getSduiFocusActivationStore
