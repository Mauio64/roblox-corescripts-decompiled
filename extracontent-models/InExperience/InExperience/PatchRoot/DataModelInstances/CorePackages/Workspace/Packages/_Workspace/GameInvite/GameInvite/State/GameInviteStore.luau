local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local Rodux = require(ParentParent.Rodux)
local GameInviteReducer = require(scriptParent.Reducers.GameInviteReducer)

return Rodux.Store.new(GameInviteReducer, nil, { Rodux.thunkMiddleware })
