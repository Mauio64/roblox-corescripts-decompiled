local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local configuredRoduxNetworking = require(script.Parent.configuredRoduxNetworking)

local FriendsNetworking = require(parent.FriendsNetworking)
return FriendsNetworking.config({ roduxNetworking = configuredRoduxNetworking })
