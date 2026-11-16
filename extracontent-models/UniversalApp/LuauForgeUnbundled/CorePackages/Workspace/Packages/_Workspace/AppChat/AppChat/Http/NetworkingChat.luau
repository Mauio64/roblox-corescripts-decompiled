local networkingChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuaSocialLibrariesDeps").NetworkingChat

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")

return networkingChat.config({ roduxNetworking = RoduxNetworking })
