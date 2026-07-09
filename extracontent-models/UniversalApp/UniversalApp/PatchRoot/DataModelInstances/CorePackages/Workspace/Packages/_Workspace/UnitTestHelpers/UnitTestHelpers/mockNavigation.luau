local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local RoactNavigation = require(ParentParent.RoactNavigation)
local t1 = {
	state = {
		routeName = "",
		key = "",
		params = {}
	},
	dispatch = function() -- line: 12
	end,
	goBack = function() -- line: 13
	end,
	addListener = function() -- line: 14
		return {
			remove = function() -- line: 16
			end
		}
	end,
	isFocused = function() -- line: 19
	end,
	setParams = function() -- line: 20
	end,
	getParam = function() -- line: 21
	end,
	replace = function() -- line: 22
	end,
	push = function() -- line: 23
	end,
	navigate = function() -- line: 24
	end
}

return function(p1) -- line: 27
	-- upvalues: Roact (copy), RoactNavigation (copy), t1 (copy)
	return Roact.createElement(RoactNavigation.Provider, {
		value = t1
	}, {
		Element = p1
	})
end
