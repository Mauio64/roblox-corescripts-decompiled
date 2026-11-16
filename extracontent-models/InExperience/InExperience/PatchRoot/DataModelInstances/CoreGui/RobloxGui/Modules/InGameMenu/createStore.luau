local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Rodux = InGameMenuDependencies.Rodux

local parent = script.Parent

local GlobalConfig = require(parent.GlobalConfig)
local reducer = require(parent.reducer)

local function createStore()
	local loggerMiddlewares = { Rodux.thunkMiddleware }

	if GlobalConfig.logStore then
		table.insert(loggerMiddlewares, Rodux.loggerMiddleware)
	end

	return Rodux.Store.new(reducer, nil, loggerMiddlewares)
end

return createStore
