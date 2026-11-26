local actionHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/SignalsMiddleware").ActionHandlers
local SetLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/SetLocalUserId")
local ClearUserSpecificData = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/ClearUserSpecificData")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/LocalUserIdStore").LocalUserIdStore

local function handleSetLocalUserId(p2): boolean
	localUserIdStore.setCurrentUserId(p2.userId)
	return false
end

local function handleClearUserSpecificData(p2): boolean
	localUserIdStore.reset()
	return false
end

return function(p2)
	actionHandlers.register(p2, SetLocalUserId.name, handleSetLocalUserId)
	actionHandlers.register(p2, ClearUserSpecificData.name, handleClearUserSpecificData)
end
