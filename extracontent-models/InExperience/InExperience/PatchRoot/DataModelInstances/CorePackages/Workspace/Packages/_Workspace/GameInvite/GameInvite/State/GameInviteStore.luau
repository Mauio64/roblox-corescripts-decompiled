local parent = script.Parent
local parent2 = parent.Parent.Parent

local Rodux = require(parent2.Rodux)
local GameInviteReducer = require(parent.Reducers.GameInviteReducer)

return Rodux.Store.new(GameInviteReducer, nil, { Rodux.thunkMiddleware })
