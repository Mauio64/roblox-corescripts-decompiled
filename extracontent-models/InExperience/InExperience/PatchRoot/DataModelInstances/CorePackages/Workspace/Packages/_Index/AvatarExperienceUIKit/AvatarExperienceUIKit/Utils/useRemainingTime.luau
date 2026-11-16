local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)

local getRemainingTime = require(script.Parent.getRemainingTime)

local v = { days = 86400, hours = 3600, minutes = 60, seconds = 1 }

local function getNextTickInterval(remainingTime) -- 2 equivalent calls inferred from this helper
	local v2 = v[remainingTime.unit]
	return (math.max(remainingTime.secondsRemaining - remainingTime.value * v2 + 1, 0.05))
end

local function useRemainingTime(p: string?)
	local state, setState = React.useState(function()
		return getRemainingTime(p)
	end)

	React.useEffect(function()
		if not p then
			setState(nil)
			return
		end

		local flag = false
		local thread = nil
		local function tick()
			if flag then
				return
			end

			local remainingTime = getRemainingTime(p)
			setState(remainingTime)

			if not remainingTime or remainingTime.value < 0 then
				return
			end

			thread = task.delay(getNextTickInterval(remainingTime), tick) -- inferred equivalent call
		end

		if not flag then
			local remainingTime = getRemainingTime(p)
			setState(remainingTime)

			if remainingTime and not (remainingTime.value < 0) then
				thread = task.delay(getNextTickInterval(remainingTime), tick) -- inferred equivalent call
			end
		end

		return function()
			flag = true

			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { p })

	return state
end

return useRemainingTime
