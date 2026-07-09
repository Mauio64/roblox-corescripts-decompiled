local Parent = script:FindFirstAncestor("EditProfile").Parent
local ProfileRoduxNetworking = require(script.Parent.ProfileRoduxNetworking)

return (require(Parent.SocialLinksNetworking).config({
	roduxNetworking = ProfileRoduxNetworking
}))
