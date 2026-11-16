local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent

require(parent.Chrome)
local React = require(parent.React)

local function useNotificationCount(object)
	local state, setState = React.useState(not object:isEmpty())
	local v, v2 = React.useBinding(object:get().value or 0)

	React.useEffect(function()
		object:connect(function(p)
			if object:isEmpty() then
				setState(false)
				return
			end

			v2((math.min(p.value, 99)))
			setState(true)
		end)
	end, { object })

	return state, v
end

return useNotificationCount
