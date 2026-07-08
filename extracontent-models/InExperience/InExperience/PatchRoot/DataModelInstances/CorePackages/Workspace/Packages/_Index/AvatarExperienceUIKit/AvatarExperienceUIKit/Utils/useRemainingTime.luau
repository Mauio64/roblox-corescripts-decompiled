local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local getRemainingTime = require(script.Parent.getRemainingTime)
local t1 = {
	days = 86400,
	hours = 3600,
	minutes = 60,
	seconds = 1
}

local function getNextTickInterval(p1) -- line: 56
	-- upvalues: t1 (copy)
	local v8 = t1[p1.unit]

	return (math.max(p1.secondsRemaining - p1.value * v8 + 1, 0.05))
end
local function useRemainingTime(s1: string?) -- line: 62
	-- upvalues: React (copy), getRemainingTime (copy), t1 (copy)
	local v10, v11 = React.useState(function() -- line: 63
		-- upvalues: getRemainingTime (copy), s1 (copy)
		return getRemainingTime(s1)
	end)

	React.useEffect(function() -- line: 67
		-- upvalues: s1 (copy), v11 (copy), getRemainingTime (copy), t1 (copy)
		if not s1 then
			v11(nil)

			return
		end

		local u12 = false
		local u13 = nil

		local function tick() -- line: 76
			-- upvalues: u12 (ref), getRemainingTime (copy), s1 (copy), v11 (copy), u13 (ref), t1 (copy), tick (copy)
			if u12 then
				return
			end

			local v18 = getRemainingTime(s1)

			v11(v18)

			if not v18 or v18.value < 0 then
				return
			end

			local delay = task.delay
			local v20 = t1[v18.unit]

			u13 = delay(math.max(v18.secondsRemaining - v18.value * v20 + 1, 0.05), tick)
		end

		if not u12 then
			local v15 = getRemainingTime(s1)

			v11(v15)

			if v15 and not (v15.value < 0) then
				local delay = task.delay
				local v17 = t1[v15.unit]

				u13 = delay(math.max(v15.secondsRemaining - v15.value * v17 + 1, 0.05), tick)
			end
		end

		return function() -- line: 91
			-- upvalues: u12 (ref), u13 (ref)
			u12 = true

			if u13 then
				task.cancel(u13)
				u13 = nil
			end
		end
	end, { s1 })

	return v10
end

return useRemainingTime
