local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local mockFoundation = require(ParentParent.Dev.UnitTestHelpers).mockFoundation

return function(t1: {[any]: any}, _: {[any]: any}?) -- line: 9
	-- upvalues: mockFoundation (copy), React (copy)
	return mockFoundation(React.createElement(React.Fragment, nil, t1))
end
