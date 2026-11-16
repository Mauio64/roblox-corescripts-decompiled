local UserLib = script:FindFirstAncestor("UserLib")
local parent = UserLib.Parent

local SignalsMiddleware = require(parent.SignalsMiddleware)
local ActionHandlers = SignalsMiddleware.ActionHandlers
local SetLocalUserId = require(UserLib.Actions.SetLocalUserId)
local ClearUserSpecificData = require(UserLib.Actions.ClearUserSpecificData)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local function handleSetLocalUserId(p): boolean
	localUserIdStore.setCurrentUserId(p.userId)
	return false
end

local function handleClearUserSpecificData(_): boolean
	localUserIdStore.reset()
	return false
end

return function(p)
	ActionHandlers.register(p, SetLocalUserId.name, handleSetLocalUserId)
	ActionHandlers.register(p, ClearUserSpecificData.name, handleClearUserSpecificData)
end
