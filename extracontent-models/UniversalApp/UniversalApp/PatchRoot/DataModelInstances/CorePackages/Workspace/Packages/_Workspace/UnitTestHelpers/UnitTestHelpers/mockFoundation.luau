local ParentParent = script.Parent.Parent
local FoundationProvider = require(ParentParent.Foundation).FoundationProvider
local Roact = require(ParentParent.Roact)

return function(p1) -- line: 7
	-- upvalues: Roact (copy), FoundationProvider (copy)
	return Roact.createElement(FoundationProvider, nil, {
		Element = p1
	})
end
