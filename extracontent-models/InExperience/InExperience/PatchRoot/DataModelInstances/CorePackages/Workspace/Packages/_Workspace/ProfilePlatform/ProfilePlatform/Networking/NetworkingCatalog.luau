local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

local CatalogNetworking = require(parent.CatalogNetworking)
return (CatalogNetworking.config({ roduxNetworking = myRoduxNetworking }))
