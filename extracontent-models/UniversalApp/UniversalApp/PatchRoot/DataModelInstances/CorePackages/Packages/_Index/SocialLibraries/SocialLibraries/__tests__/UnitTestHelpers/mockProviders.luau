local Packages = script:FindFirstAncestor("Packages")
local RoactRodux = require(Packages.Dev.RoactRodux)
local dependencies = require(script.Parent.Parent.Parent.dependencies)
local Roact = dependencies.Roact
local Rodux = dependencies.Rodux
local mockStyle = require(script.Parent.mockStyle)
local mockNavigation = require(script.Parent.mockNavigation)
local v8 = Rodux.Store.new(function() -- line: 10
	return {}
end, {}, { Rodux.thunkMiddleware })

return function(p1, p2) -- line: 14
	-- upvalues: v8 (copy), mockNavigation (copy), mockStyle (copy), Roact (copy), RoactRodux (copy)
	local v11 = p2 or {}
	local v12 = v11.store or v8
	local v13 = v11.mockNavigation or mockNavigation
	local v14 = mockStyle(v13(p1))

	return Roact.createElement(RoactRodux.StoreProvider, {
		store = v12
	}, {
		children = v14
	})
end
