local parent = script:FindFirstAncestor("ExpChat").Parent

local React = require(parent.React)

local function usePausableTimeout(flag: boolean, p: number, callback)
	local ref = React.useRef(0)
	React.useEffect(function()
		if p <= 0 or not flag then
			return nil
		end

		local lastTime = os.clock()
		local v = math.max(0, p - ref.current)
		local thread = task.delay(v, callback)
		return function()
			ref.current += os.clock() - lastTime
			pcall(task.cancel, thread)
		end
	end, { flag, p, callback })
end

return usePausableTimeout
