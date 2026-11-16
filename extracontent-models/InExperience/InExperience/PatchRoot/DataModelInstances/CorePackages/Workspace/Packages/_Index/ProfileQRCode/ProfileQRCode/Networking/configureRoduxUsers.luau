local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local NetworkingUsers = require(parent.NetworkingUsers)
local configuredRoduxNetworking = require(script.Parent.configuredRoduxNetworking)

return NetworkingUsers.config({ roduxNetworking = configuredRoduxNetworking })
