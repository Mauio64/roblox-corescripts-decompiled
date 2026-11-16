local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function useDelayedActionHandler(duration: number, p: number?, callback)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(0)

	local function handleAction()
		local now = os.clock()

		if p ~= nil and ref2.current ~= nil and now - ref2.current < p then
			return
		end

		ref2.current = now
		local current = ref.current

		if current ~= nil then
			task.cancel(current)
		end

		ref.current = task.delay(duration, function()
			callback()
		end)
	end

	React.useEffect(function()
		return function()
			local current = ref.current

			if current ~= nil then
				task.cancel(current)
			end
		end
	end, { ref })

	return handleAction
end

return useDelayedActionHandler
