local parent = script:FindFirstAncestor("EditProfile").Parent
local ProfileRoduxNetworking = require(script.Parent.ProfileRoduxNetworking)
local NetworkingUsers = require(parent.NetworkingUsers)

return (NetworkingUsers.config({ roduxNetworking = ProfileRoduxNetworking }))
