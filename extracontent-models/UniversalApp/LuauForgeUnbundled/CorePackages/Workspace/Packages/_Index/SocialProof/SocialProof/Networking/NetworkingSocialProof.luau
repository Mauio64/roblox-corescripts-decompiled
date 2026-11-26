local SocialProofNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/SocialProofNetworking")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Networking/myRoduxNetworking")

return (SocialProofNetworking.config({ roduxNetworking = myRoduxNetworking }))
