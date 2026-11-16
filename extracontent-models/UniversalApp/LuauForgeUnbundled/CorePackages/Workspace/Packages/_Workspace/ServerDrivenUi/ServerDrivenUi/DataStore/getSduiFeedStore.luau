require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/SduiFeedStoreTypes")
local createSduiFeedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/createSduiFeedStore")

local v5 = {}

return function(p2)
	local v6 = v5[p2]

	if v6 == nil then
		v5[p2] = createSduiFeedStore()
		v6 = v5[p2]
	end

	return v6
end
