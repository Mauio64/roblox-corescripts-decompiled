local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local React = require(ParentParent.Dev.React)

return function(p1, t1: {[any]: any}) -- line: 9
	-- upvalues: Cryo (copy), React (copy)
	return Cryo.List.foldRight(t1, function(p2, p3) -- line: 10
		-- upvalues: React (copy)
		return React.createElement(p3, nil, {
			ProviderChildren = p2
		})
	end, p1)
end
