local Parent = script:FindFirstAncestor("EditProfile").Parent
local ProfileRoduxNetworking = require(script.Parent.ProfileRoduxNetworking)

return (require(Parent.NetworkingUsers).config({
	roduxNetworking = ProfileRoduxNetworking
}))
