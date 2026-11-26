local FriendsCallingService = game:GetService("FriendsCallingService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/Signals")

local createFriendsCallingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Stores/GetFriendsCallingStore/createFriendsCallingStore")

return Signals.createComputed(function()
	return createFriendsCallingStore(FriendsCallingService)
end)
