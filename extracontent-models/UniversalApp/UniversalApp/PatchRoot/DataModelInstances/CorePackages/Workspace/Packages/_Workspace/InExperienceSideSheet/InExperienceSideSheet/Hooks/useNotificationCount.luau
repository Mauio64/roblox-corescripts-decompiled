local Parent = script:FindFirstAncestor("InExperienceSideSheet").Parent

require(Parent.Chrome)

local React = require(Parent.React)

local function useNotificationCount(p1) -- line: 12
	-- upvalues: React (copy)
	local v5, v6 = React.useState(not p1:isEmpty())
	local v7, v8 = React.useBinding(p1:get().value or 0)

	React.useEffect(function() -- line: 16
		-- upvalues: p1 (copy), v6 (copy), v8 (copy)
		p1:connect(function(p2) -- line: 17
			-- upvalues: p1 (copy), v6 (copy), v8 (copy)
			if p1:isEmpty() then
				v6(false)

				return
			end

			v8((math.min(p2.value, 99)))
			v6(true)
		end)
	end, { p1 })

	return v5, v7
end

return useNotificationCount
