local Parent = script:FindFirstAncestor("ChallengeDialog").Parent
local Roact = require(Parent.Roact)
local RoactRodux = require(Parent.RoactRodux)
local Rodux = require(Parent.Rodux)
local v5 = Rodux.Store.new(function() -- line: 8
	return {}
end, {}, { Rodux.thunkMiddleware })

return {
	createTreeWithProviders = function(p1, p2, p3) -- line: 12
		-- upvalues: Roact (copy), RoactRodux (copy), v5 (copy)
		local v9 = Roact.createFragment({
			storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
				store = if p3 == nil then v5 else p3
			}, {
				myElement = Roact.createElement(p1, p2)
			})
		})
		local v10 = Roact.mount(v9)

		return v10, function() -- line: 23
			-- upvalues: Roact (copy), v10 (copy)
			Roact.unmount(v10)
		end
	end
}
