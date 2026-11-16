local SocialProof = script:FindFirstAncestor("SocialProof")
local parent = SocialProof.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(SocialProof.Networking.myRoduxNetworking)

return LuaSocialLibrariesDeps.NetworkingUsers.config({ roduxNetworking = myRoduxNetworking })
