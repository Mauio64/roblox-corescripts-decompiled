local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/LuaSocialLibrariesDeps")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Networking/myRoduxNetworking")

return (LuaSocialLibrariesDeps.NetworkingGames.config({ roduxNetworking = myRoduxNetworking }))
