local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/Promise")

local function useThrottledCallback(current, current2)
	local ref = React.useRef(current)
	local ref2 = React.useRef(current2)
	ref.current = current
	ref2.current = current2

	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(0)

	local v5 = React.useCallback(function()
		if ref3.current then
			return
		end

		local current3 = ref2.current or 0
		local v6 = ref4.current + current3 - tick()

		local function runCallback()
			ref.current()
			ref4.current = tick()
			ref3.current = nil
		end

		if v6 > 0 then
			ref3.current = Promise.delay(v6):andThen(runCallback)
			return
		end

		ref.current()
		ref4.current = tick()
		ref3.current = nil
	end)

	React.useEffect(function()
		return function()
			local current3 = ref3.current

			if current3 then
				current3:cancel()

				ref.current()
			end
		end
	end, {})

	return v5
end

return useThrottledCallback
