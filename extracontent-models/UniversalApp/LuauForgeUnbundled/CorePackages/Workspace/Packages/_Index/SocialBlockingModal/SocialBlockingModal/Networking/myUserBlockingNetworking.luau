local UserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/UserBlockingNetworking")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/SocialBlockingModal/Networking/myRoduxNetworking")

return (UserBlockingNetworking.config({ roduxNetworking = myRoduxNetworking }))
