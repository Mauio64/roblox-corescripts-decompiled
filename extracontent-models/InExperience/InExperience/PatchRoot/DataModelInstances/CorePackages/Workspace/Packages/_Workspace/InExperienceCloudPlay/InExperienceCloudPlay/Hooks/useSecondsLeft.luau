local InExperienceCloudPlay = script:FindFirstAncestor("InExperienceCloudPlay")
local parent = InExperienceCloudPlay.Parent

local React = require(parent.React)
require(InExperienceCloudPlay.getCloudClientService)

local function useSecondsLeft(object, p: number?)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if not object or not p or p <= 0 then
			setState(nil)
			return nil
		end

		local v = os.clock() + p - object:GetSessionElapsedTime()
		local v2 = nil
		local function tick()
			local v3 = v - os.clock()
			local v4 = math.max(0, (math.ceil(v3)))
			setState(v4)
			local v5

			if v4 > 0 then
				v5 = task.delay(v3 - (v4 - 1), tick)
			end

			v2 = v5
		end

		local v3 = v - os.clock()
		local v4 = math.max(0, (math.ceil(v3)))
		setState(v4)

		if v4 > 0 then
			v2 = task.delay(v3 - (v4 - 1), tick)
		else
			v2 = nil
		end

		return function()
			if v2 then
				task.cancel(v2)
			end
		end
	end, { object, p })

	return state
end

return useSecondsLeft
