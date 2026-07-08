local Parent = script:FindFirstAncestor("EditProfile").Parent
local UserProfileSettingsNetworking = require(Parent.UserProfileSettingsNetworking)
local ProfileRoduxNetworking = require(script.Parent.ProfileRoduxNetworking)

return (UserProfileSettingsNetworking.config({
	roduxNetworking = ProfileRoduxNetworking
}))
