local parent = script:FindFirstAncestor("EditProfileBackground").Parent

local ProfileCustomizationNetworking = require(parent.ProfileCustomizationNetworking)
local ProfileRoduxNetworking = require(script.Parent.ProfileRoduxNetworking)

return (ProfileCustomizationNetworking.config({ roduxNetworking = ProfileRoduxNetworking }))
