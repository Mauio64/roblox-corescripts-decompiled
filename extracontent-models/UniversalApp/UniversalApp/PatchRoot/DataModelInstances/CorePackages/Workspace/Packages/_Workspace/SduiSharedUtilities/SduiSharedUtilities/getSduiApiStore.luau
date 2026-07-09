local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local createSduiApiStore = require(SduiSharedUtilities.createSduiApiStore)
local u3 = nil

local function getSduiApiStore() -- line: 9
	-- upvalues: u3 (ref), createSduiApiStore (copy)
	if u3 == nil then
		u3 = createSduiApiStore()
	end

	return u3
end

return getSduiApiStore
