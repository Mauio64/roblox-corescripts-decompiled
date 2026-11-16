local UseReactiveVar = {}
local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local useEffect = React.useEffect
local useState = React.useState

require(parent.cache)

local v = { __value = "nil placeholder" }

function UseReactiveVar.useReactiveVar(callback)
	local v2 = callback()

	local _, setState = useState(v2)

	useEffect(function()
		local v3 = callback()

		if v2 == v3 then
			return callback:onNextChange(setState)
		end

		setState(v3)
	end, { v2 or v })

	return v2
end

return UseReactiveVar
