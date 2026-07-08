local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.InGameMenuDependencies).Rodux
local scriptParent = script.Parent
local GlobalConfig = require(scriptParent.GlobalConfig)
local reducer = require(scriptParent.reducer)

local function createStore() -- line: 11
	-- upvalues: Rodux (copy), GlobalConfig (copy), reducer (copy)
	local t1 = { Rodux.thunkMiddleware }

	if GlobalConfig.logStore then
		table.insert(t1, Rodux.loggerMiddleware)
	end

	return Rodux.Store.new(reducer, nil, t1)
end

return createStore
