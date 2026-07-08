local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local configuredRoduxNetworking = require(script.Parent.configuredRoduxNetworking)

return require(Parent.FriendsNetworking).config({
	roduxNetworking = configuredRoduxNetworking
})
