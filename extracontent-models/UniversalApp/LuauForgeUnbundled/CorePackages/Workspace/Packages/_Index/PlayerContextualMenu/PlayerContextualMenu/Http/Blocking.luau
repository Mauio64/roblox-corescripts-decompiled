local networkingBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/LuaSocialLibrariesDeps").NetworkingBlocking
local UserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/UserBlockingNetworking")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Http/RoduxNetworking")

if require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Flags/FFlagUserBlockingApiPlayerContextMenuEnabled") then
	return (UserBlockingNetworking.config({ roduxNetworking = RoduxNetworking }))
end

return (networkingBlocking.config({ roduxNetworking = RoduxNetworking }))
