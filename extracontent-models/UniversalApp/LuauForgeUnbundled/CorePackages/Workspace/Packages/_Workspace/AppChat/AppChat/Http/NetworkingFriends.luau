local UserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserBlockingNetworking")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")

return UserBlockingNetworking.config({ roduxNetworking = RoduxNetworking })
