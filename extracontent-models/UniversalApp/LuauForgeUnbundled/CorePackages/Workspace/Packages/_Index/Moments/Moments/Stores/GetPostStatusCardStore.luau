local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createPostStatusCardStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetPostStatusCardStore/createPostStatusCardStore")

return Signals.createComputed(createPostStatusCardStore)
