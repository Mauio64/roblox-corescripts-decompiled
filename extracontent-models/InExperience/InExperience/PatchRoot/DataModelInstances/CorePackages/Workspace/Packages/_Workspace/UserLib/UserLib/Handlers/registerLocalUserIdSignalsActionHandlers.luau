local UserLib = script:FindFirstAncestor("UserLib")
local UserLibParent = UserLib.Parent
local ActionHandlers = require(UserLibParent.SignalsMiddleware).ActionHandlers
local SetLocalUserId = require(UserLib.Actions.SetLocalUserId)
local ClearUserSpecificData = require(UserLib.Actions.ClearUserSpecificData)
local LocalUserIdStore = require(UserLib.Stores.LocalUserIdStore)

local function handleSetLocalUserId(t1: {[any]: any}) -- line: 21
	-- upvalues: LocalUserIdStore (copy)
	LocalUserIdStore.setCurrentUserId(t1.userId)

	return false
end
local function handleClearUserSpecificData(_) -- line: 26
	-- upvalues: LocalUserIdStore (copy)
	LocalUserIdStore.reset()

	return false
end

return function(p2) -- line: 31
	-- upvalues: ActionHandlers (copy), SetLocalUserId (copy), handleSetLocalUserId (copy), ClearUserSpecificData (copy), handleClearUserSpecificData (copy)
	ActionHandlers.register(p2, SetLocalUserId.name, handleSetLocalUserId)
	ActionHandlers.register(p2, ClearUserSpecificData.name, handleClearUserSpecificData)
end
