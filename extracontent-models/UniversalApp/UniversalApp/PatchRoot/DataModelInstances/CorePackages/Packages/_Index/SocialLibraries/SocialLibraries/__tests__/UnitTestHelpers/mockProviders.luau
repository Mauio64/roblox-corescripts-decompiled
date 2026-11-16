local Packages = script:FindFirstAncestor("Packages")
local RoactRodux = require(Packages.Dev.RoactRodux)
local dependencies = require(script.Parent.Parent.Parent.dependencies)
local roact = dependencies.Roact
local rodux = dependencies.Rodux

local mockStyle = require(script.Parent.mockStyle)
local mockNavigation = require(script.Parent.mockNavigation)

local store = rodux.Store.new(function()
	return {}
end, {}, { rodux.thunkMiddleware })

return function(p, options)
	local v = options or {}
	local store2 = v.store or store

	local children = mockStyle((v.mockNavigation or mockNavigation)(p))

	return roact.createElement(RoactRodux.StoreProvider, { store = store2 }, { children = children })
end
