local SocialProof = script:FindFirstAncestor("SocialProof")
local SocialProofParent = SocialProof.Parent
local LuaSocialLibrariesDeps = require(SocialProofParent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(SocialProof.Networking.myRoduxNetworking)

return LuaSocialLibrariesDeps.NetworkingUsers.config({
	roduxNetworking = myRoduxNetworking
})
