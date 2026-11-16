local parent = script.Parent.Parent.Parent.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function useInitialButtonDisableDelay(flag: boolean?, p: number?)
	local v = useTokens()

	local v2 = p or v.Time.Time_300
	local state, setState = React.useState(true)

	React.useEffect(function()
		local v3 = false

		task.delay(v2, function()
			if not v3 then
				setState(false)
			end
		end)

		return function()
			v3 = true
		end
	end, { v2 })

	return flag or state
end

return useInitialButtonDisableDelay
