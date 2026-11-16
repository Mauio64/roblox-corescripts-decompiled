local parent = script:FindFirstAncestor("AppChat").Parent

local Signals = require(parent.Signals)

local createFriendsChatSettingsStore = require(script.createFriendsChatSettingsStore)

return Signals.createComputed(function()
	return createFriendsChatSettingsStore()
end)
