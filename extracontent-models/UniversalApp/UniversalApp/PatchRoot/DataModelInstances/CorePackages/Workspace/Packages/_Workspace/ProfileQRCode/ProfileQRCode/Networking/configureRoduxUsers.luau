local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local NetworkingUsers = require(Parent.NetworkingUsers)
local configuredRoduxNetworking = require(script.Parent.configuredRoduxNetworking)

return NetworkingUsers.config({
	roduxNetworking = configuredRoduxNetworking
})
