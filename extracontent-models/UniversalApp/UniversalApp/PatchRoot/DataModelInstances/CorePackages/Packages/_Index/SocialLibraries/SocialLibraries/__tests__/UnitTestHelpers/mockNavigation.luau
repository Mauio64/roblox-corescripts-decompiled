local dependencies = require(script.Parent.Parent.Parent.dependencies)
local Roact = dependencies.Roact
local RoactNavigation = dependencies.RoactNavigation
local t1 = {
	state = {
		routeName = "",
		key = "",
		params = {}
	},
	dispatch = function() -- line: 11
	end,
	goBack = function() -- line: 12
	end,
	addListener = function() -- line: 13
	end,
	isFocused = function() -- line: 14
	end,
	setParams = function() -- line: 15
	end,
	getParam = function() -- line: 16
	end
}

return function(p1) -- line: 19
	-- upvalues: Roact (copy), RoactNavigation (copy), t1 (copy)
	return Roact.createElement(RoactNavigation.Provider, {
		value = t1
	}, {
		Element = p1
	})
end
