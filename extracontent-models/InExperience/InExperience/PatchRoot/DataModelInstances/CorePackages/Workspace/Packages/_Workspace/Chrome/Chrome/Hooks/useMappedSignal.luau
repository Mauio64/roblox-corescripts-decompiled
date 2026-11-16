local Chrome = script:FindFirstAncestor("Chrome")

local parent = Chrome.Parent
local React = require(parent.React)
require(Chrome.Common.Types)

return function(object)
	local v

	if object ~= nil then
		v = object:get()
	end

	local state, setState = React.useState(v)
	React.useEffect(function()
		if object == nil then
			return
		end

		local v2 = object
		local connection = v2:connect(function(p)
			setState(p)
		end)

		if state ~= v2:get() then
			setState(v2:get())
		end

		return function()
			connection:disconnect()
		end
	end, { object })

	return state
end
