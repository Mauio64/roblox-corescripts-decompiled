local CorePackages = game:GetService("CorePackages")
local parent = script.Parent

local SettingsReducer = require(parent.Reducers.SettingsReducer)
local Rodux = require(CorePackages.Packages.Rodux)
return {
	Destruct = function(p)
		p.store:destruct()
	end,
	store = Rodux.Store.new(SettingsReducer, nil, { Rodux.thunkMiddleware })
}
