local parent = script:FindFirstAncestor("EditProfile").Parent
local ProfileRoduxNetworking = require(script.Parent.ProfileRoduxNetworking)
local SocialLinksNetworking = require(parent.SocialLinksNetworking)

return (SocialLinksNetworking.config({ roduxNetworking = ProfileRoduxNetworking }))
