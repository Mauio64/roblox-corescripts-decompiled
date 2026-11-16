local CorePackages = game:GetService("CorePackages")
game:GetService("CoreGui")

local AppShellReducer = require(script.Parent.Reducers.AppShellReducer)
local Rodux = require(CorePackages.Packages.Rodux)

local v = { Rodux.thunkMiddleware }
return {
	Destruct = function(p)
		p.store:destruct()
	end,
	store = Rodux.Store.new(AppShellReducer, {}, v, nil)
}
