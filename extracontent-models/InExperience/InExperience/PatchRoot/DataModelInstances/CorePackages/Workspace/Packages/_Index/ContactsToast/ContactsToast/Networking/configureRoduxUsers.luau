local Parent = script:FindFirstAncestor("ContactsToast").Parent
local NetworkingUsers = require(Parent.NetworkingUsers)
local configuredRoduxNetworking = require(script.Parent.configuredRoduxNetworking)

return NetworkingUsers.config({
	roduxNetworking = configuredRoduxNetworking
})
