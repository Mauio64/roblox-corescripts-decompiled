local CorePackages = game:GetService("CorePackages")

game:GetService("CoreGui")

local AppShellReducer = require(script.Parent.Reducers.AppShellReducer)
local Rodux = require(CorePackages.Packages.Rodux)
local t1 = {
	Destruct = function(p1) -- line: 12
		p1.store:destruct()
	end
}
local t2 = { Rodux.thunkMiddleware }

t1.store = Rodux.Store.new(AppShellReducer, {}, t2, nil)

return t1
