local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function useDebounce(p, duration: number?)
	local state, setState = React.useState(p)

	React.useLayoutEffect(function()
		local function updateValue() -- 1 equivalent call inferred from this helper
			setState(p)
		end

		if duration == nil or duration == 0 then
			updateValue() -- inferred equivalent call
		else
			local thread = task.delay(duration, updateValue)

			return function()
				task.cancel(thread)
			end
		end
	end, { p, duration })

	return state
end

return useDebounce
