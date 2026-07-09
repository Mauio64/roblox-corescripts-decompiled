local ParentParent = script.Parent.Parent.Parent.Parent
local SocialService = game:GetService("SocialService")

return require(ParentParent.React).createContext({
	socialService = SocialService
})
