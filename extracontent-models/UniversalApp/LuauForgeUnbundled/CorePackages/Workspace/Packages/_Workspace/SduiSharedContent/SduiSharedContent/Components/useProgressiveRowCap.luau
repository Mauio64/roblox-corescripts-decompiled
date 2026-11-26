local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")

local function useProgressiveRowCap(p2, p3, value, p4)
	local v5 = p3 ~= nil
	local v6 = math.max(1, value or 1)

	local state, setState = React.useState(function()
		if v5 then
			return (math.min(math.max(0, p3), p2))
		end

		return p2
	end)

	local v7 = if v5 then math.min(state, p2) else p2
	local v8 = v5 and v7 < p2

	React.useEffect(function()
		if not v8 then
			return nil
		end

		local flag = nil
		local function advance()
			if flag then
				return
			end

			setState(function(p5)
				return p5 + v6
			end)
		end

		if p4 and p4 > 0 then
			task.delay(p4 / 1000, advance)
		else
			task.defer(advance)
		end

		return function()
			flag = true
		end
	end, { v8, v6, state, p4 })

	return v7, v8
end

return useProgressiveRowCap
