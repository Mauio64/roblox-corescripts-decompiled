local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)

return function(callback)
	React.useEffect(function()
		callback()
	end, {})
end
