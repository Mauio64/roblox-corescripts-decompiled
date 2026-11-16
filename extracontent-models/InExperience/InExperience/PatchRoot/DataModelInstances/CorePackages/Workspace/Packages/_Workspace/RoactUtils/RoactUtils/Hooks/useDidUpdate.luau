local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)

return function(callback)
	local ref = React.useRef(false)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		if not ref.current then
			ref.current = true
			return
		end

		if not ref2.current then
			ref2.current = true
		end

		if callback then
			callback()
		end
	end)

	return ref2
end
