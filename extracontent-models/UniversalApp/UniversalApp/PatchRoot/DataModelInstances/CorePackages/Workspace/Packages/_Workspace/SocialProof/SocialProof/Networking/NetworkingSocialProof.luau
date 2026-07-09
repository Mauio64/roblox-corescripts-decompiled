local SocialProof = script:FindFirstAncestor("SocialProof")
local SocialProofParent = SocialProof.Parent
local SocialProofNetworking = require(SocialProofParent.SocialProofNetworking)
local myRoduxNetworking = require(SocialProof.Networking.myRoduxNetworking)

return (SocialProofNetworking.config({
	roduxNetworking = myRoduxNetworking
}))
