local Parent = script:FindFirstAncestor("AccountRecovery").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Dropdown = Foundation.Dropdown

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), View (copy), Dropdown (copy)
	local v7 = t1.initialWidth or UDim.new(0, 300)
	local v8, v9 = React.useState(v7)

	t1.dropdownProps.width = v8

	return React.createElement(View, {
		tag = "size-full",
		onAbsoluteSizeChanged = function(p1) -- line: 24
			-- upvalues: v9 (copy)
			v9(UDim.new(0, p1.AbsoluteSize.X))
		end
	}, {
		Dropdown = React.createElement(Dropdown.Root, t1.dropdownProps)
	})
end
