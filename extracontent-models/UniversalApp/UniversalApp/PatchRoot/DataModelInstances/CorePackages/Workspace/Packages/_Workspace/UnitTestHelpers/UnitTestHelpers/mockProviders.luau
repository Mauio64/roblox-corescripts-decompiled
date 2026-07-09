local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local Rodux = require(ParentParent.Rodux)
local RoactRodux = require(ParentParent.RoactRodux)
local mockPolicyProvider = require(script.Parent.mockPolicyProvider)
local mockStyle = require(script.Parent.mockStyle)
local mockLocale = require(script.Parent.mockLocale)
local mockNavigation = require(script.Parent.mockNavigation)
local mockDesignTokens = require(script.Parent.mockDesignTokens)
local mockFoundation = require(script.Parent.mockFoundation)
local v11 = Rodux.Store.new(function() -- line: 15
	return {}
end, {}, { Rodux.thunkMiddleware })

return function(p1, p2) -- line: 19
	-- upvalues: v11 (copy), mockNavigation (copy), mockStyle (copy), mockDesignTokens (copy), mockLocale (copy), mockFoundation (copy), Roact (copy), RoactRodux (copy), mockPolicyProvider (copy)
	local v14 = p2 or {}
	local v15 = v14.store or v11
	local appPolicy = v14.appPolicy
	local v17 = v14.mockNavigation or mockNavigation
	local v18 = v14.tokenMappers or {}
	local v19 = mockStyle(mockDesignTokens(mockLocale(v17(p1)), v18))

	if v14.mockFoundation == true then
		v19 = mockFoundation(v19)
	end

	return Roact.createElement(RoactRodux.StoreProvider, {
		store = v15
	}, {
		children = mockPolicyProvider(v19, appPolicy)
	})
end
