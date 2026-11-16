local SocialProof = script:FindFirstAncestor("SocialProof")
local parent = SocialProof.Parent
local SocialProofNetworking = require(parent.SocialProofNetworking)
local myRoduxNetworking = require(SocialProof.Networking.myRoduxNetworking)

return (SocialProofNetworking.config({ roduxNetworking = myRoduxNetworking }))
