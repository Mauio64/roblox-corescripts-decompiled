local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local useTokens = require(ParentParent.Foundation).Hooks.useTokens

local function useInitialButtonDisableDelay(b1: boolean?, n1: number?) -- line: 7
	-- upvalues: useTokens (copy), React (copy)
	local v7 = useTokens()
	local v8 = n1 or v7.Time.Time_300
	local v9, v10 = React.useState(true)

	React.useEffect(function() -- line: 13
		-- upvalues: v8 (copy), v10 (copy)
		local u11 = false

		task.delay(v8, function() -- line: 16
			-- upvalues: u11 (ref), v10 (copy)
			if not u11 then
				v10(false)
			end
		end)

		return function() -- line: 22
			-- upvalues: u11 (ref)
			u11 = true
		end
	end, { v8 })

	return b1 or v9
end

return useInitialButtonDisableDelay
