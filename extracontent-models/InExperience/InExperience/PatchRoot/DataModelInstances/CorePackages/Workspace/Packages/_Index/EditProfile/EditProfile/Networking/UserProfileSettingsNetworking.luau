local parent = script:FindFirstAncestor("EditProfile").Parent

local UserProfileSettingsNetworking = require(parent.UserProfileSettingsNetworking)
local ProfileRoduxNetworking = require(script.Parent.ProfileRoduxNetworking)

return (UserProfileSettingsNetworking.config({ roduxNetworking = ProfileRoduxNetworking }))
