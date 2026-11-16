local parent = script:FindFirstAncestor("AppChat").Parent

local FriendsRodux = require(parent.FriendsRodux)

return FriendsRodux.config({ keyPath = "ChatAppReducer.Friends" })
