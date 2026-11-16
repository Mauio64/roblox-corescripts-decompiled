local parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

local React = require(parent.React)

return function(callback, p)
	local ref = React.useRef(false)

	React.useEffect(function()
		if p and not ref.current then
			callback()
			ref.current = true
		end
	end, { p })
end
