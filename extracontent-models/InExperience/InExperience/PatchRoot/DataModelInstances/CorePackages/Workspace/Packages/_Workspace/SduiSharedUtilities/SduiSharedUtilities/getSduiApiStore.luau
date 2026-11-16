local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local createSduiApiStore = require(SduiSharedUtilities.createSduiApiStore)

local sduiApiStore = nil

local function getSduiApiStore()
	if sduiApiStore == nil then
		sduiApiStore = createSduiApiStore()
	end

	return sduiApiStore
end

return getSduiApiStore
