local CorePackages = game:GetService("CorePackages")
local scriptParent = script.Parent
local SettingsReducer = require(scriptParent.Reducers.SettingsReducer)
local Rodux = require(CorePackages.Packages.Rodux)
local Store = Rodux.Store

return {
	Destruct = function(p1) -- line: 10
		p1.store:destruct()
	end,
	store = Store.new(SettingsReducer, nil, { Rodux.thunkMiddleware })
}
