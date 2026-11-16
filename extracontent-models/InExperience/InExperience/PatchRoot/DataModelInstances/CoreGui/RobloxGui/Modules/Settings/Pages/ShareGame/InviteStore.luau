local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local AppReducer = require(Modules.Settings.Pages.ShareGame.AppReducer)

return Rodux.Store.new(AppReducer, nil, { Rodux.thunkMiddleware })
