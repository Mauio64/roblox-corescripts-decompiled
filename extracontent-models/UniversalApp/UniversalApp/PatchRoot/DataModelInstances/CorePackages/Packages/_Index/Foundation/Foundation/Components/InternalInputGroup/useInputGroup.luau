local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local InputGroupContext = require(script.Parent.InputGroupContext)

local function useInputGroup()
	return React.useContext(InputGroupContext)
end

return useInputGroup
