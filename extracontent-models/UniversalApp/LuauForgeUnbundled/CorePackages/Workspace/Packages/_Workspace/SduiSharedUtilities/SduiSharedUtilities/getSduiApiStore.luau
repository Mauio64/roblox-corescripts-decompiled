local createSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/createSduiApiStore")

local sduiApiStore = nil

local function getSduiApiStore()
	if sduiApiStore == nil then
		sduiApiStore = createSduiApiStore()
	end

	return sduiApiStore
end

return getSduiApiStore
