local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ChatMute/Signals")
local createMutedUsersStore = require("@game/CorePackages/Workspace/Packages/_Index/ChatMute/ChatMute/createMutedUsersStore")

return Signals.createComputed(createMutedUsersStore)
