local parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(parent.React)

local function useProgressiveRowCap(p: number, p2: number?, value: number?, p3: number?)
	local v = p2 ~= nil
	local v2 = math.max(1, value or 1)

	local state, setState = React.useState(function()
		if v then
			return (math.min(math.max(0, p2), p))
		end

		return p
	end)
	local v3

	if v then
		v3 = math.min(state, p)
	else
		v3 = p
	end

	local v4 = v and v3 < p

	React.useEffect(function()
		if not v4 then
			return nil
		end

		local flag = nil
		local function advance()
			if flag then
				return
			end

			setState(function(p4: number)
				return p4 + v2
			end)
		end

		if p3 and p3 > 0 then
			task.delay(p3 / 1000, advance)
		else
			task.defer(advance)
		end

		return function()
			flag = true
		end
	end, { v4, v2, state, p3 })

	return v3, v4
end

return useProgressiveRowCap
