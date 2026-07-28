local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createFriendsChatSettingsStore = require(script.createFriendsChatSettingsStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createFriendsChatSettingsStore (copy)
	return createFriendsChatSettingsStore()
end)
