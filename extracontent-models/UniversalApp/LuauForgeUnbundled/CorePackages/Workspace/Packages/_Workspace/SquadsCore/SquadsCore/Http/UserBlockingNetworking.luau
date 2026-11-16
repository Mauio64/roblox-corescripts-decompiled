local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/RoduxNetworking")

return (require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UserBlockingNetworking").config({ roduxNetworking = RoduxNetworking }))
