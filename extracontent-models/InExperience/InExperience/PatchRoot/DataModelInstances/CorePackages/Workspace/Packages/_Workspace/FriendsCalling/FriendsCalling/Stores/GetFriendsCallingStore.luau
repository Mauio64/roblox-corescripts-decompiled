local FriendsCallingService = game:GetService("FriendsCallingService")

local parent = script:FindFirstAncestor("FriendsCalling").Parent

local Signals = require(parent.Signals)

local createFriendsCallingStore = require(script.createFriendsCallingStore)

return Signals.createComputed(function()
	return createFriendsCallingStore(FriendsCallingService)
end)
