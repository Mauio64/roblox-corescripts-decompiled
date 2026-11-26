local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").Hooks.useTokens

local function useInitialButtonDisableDelay(p2, p3)
	local v5 = useTokens()

	local v6 = p3 or v5.Time.Time_300
	local state, setState = React.useState(true)

	React.useEffect(function()
		local v7 = false

		task.delay(v6, function()
			if not v7 then
				setState(false)
			end
		end)

		return function()
			v7 = true
		end
	end, { v6 })

	return p2 or state
end

return useInitialButtonDisableDelay
