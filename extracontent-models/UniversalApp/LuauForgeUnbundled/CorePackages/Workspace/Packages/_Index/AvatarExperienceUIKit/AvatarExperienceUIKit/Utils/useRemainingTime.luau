local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")

local getRemainingTime = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/getRemainingTime")

local v5 = { days = 86400, hours = 3600, minutes = 60, seconds = 1 }

local function getNextTickInterval(data)
	local v6 = v5[data.unit]
	return (math.max(data.secondsRemaining - data.value * v6 + 1, 0.05))
end

local function useRemainingTime(p2)
	local state, setState = React.useState(function()
		return getRemainingTime(p2)
	end)

	React.useEffect(function()
		if not p2 then
			setState(nil)
			return
		end

		local flag = false
		local thread = nil
		local function tick2()
			if flag then
				return
			end

			local v6 = getRemainingTime(p2)
			setState(v6)

			if not v6 or v6.value < 0 then
				return
			end

			local delay2 = task.delay
			local v7 = v5[v6.unit]
			thread = delay2(math.max(v6.secondsRemaining - v6.value * v7 + 1, 0.05), tick2)
		end

		if not flag then
			local v6 = getRemainingTime(p2)
			setState(v6)

			if v6 and not (v6.value < 0) then
				local delay2 = task.delay
				local v7 = v5[v6.unit]
				thread = delay2(math.max(v6.secondsRemaining - v6.value * v7 + 1, 0.05), tick2)
			end
		end

		return function()
			flag = true

			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { p2 })

	return state
end

return useRemainingTime
