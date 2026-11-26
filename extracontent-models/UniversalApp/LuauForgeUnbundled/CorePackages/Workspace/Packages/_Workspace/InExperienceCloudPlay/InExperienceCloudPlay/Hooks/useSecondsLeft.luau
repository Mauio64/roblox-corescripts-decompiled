local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/getCloudClientService")

local function useSecondsLeft(object, p2)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if not object or not p2 or p2 <= 0 then
			setState(nil)
			return nil
		end

		local v5 = os.clock() + p2 - object:GetSessionElapsedTime()
		local v6 = nil
		local function tick2()
			local v7 = v5 - os.clock()
			local v8 = math.max(0, (math.ceil(v7)))
			setState(v8)
			v6 = if v8 > 0 then task.delay(v7 - (v8 - 1), tick2) else nil
		end

		local v7 = v5 - os.clock()
		local v8 = math.max(0, (math.ceil(v7)))
		setState(v8)
		v6 = if v8 > 0 then task.delay(v7 - (v8 - 1), tick2) else nil

		return function()
			if v6 then
				task.cancel(v6)
			end
		end
	end, { object, p2 })

	return state
end

return useSecondsLeft
