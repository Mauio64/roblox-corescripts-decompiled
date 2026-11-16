local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Rodux")
local GameInviteReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/State/Reducers/GameInviteReducer")

return Rodux.Store.new(GameInviteReducer, nil, { Rodux.thunkMiddleware })
