local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local ProfileCustomizationNetworking = require(Parent.ProfileCustomizationNetworking)
local ProfileRoduxNetworking = require(script.Parent.ProfileRoduxNetworking)

return (ProfileCustomizationNetworking.config({
	roduxNetworking = ProfileRoduxNetworking
}))
