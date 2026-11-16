local parent = script.Parent.Parent.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local function createLazyComponent(callback)
	return React.forwardRef(function(p, ref)
		return React.createElement(callback(), Cryo.Dictionary.join(p, { ref = ref }))
	end)
end

return createLazyComponent
