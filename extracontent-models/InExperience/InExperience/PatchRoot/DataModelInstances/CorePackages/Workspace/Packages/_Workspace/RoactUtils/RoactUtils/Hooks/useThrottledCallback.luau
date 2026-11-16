local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)
local Promise = require(parent.Promise)

local function useThrottledCallback(current, current2: number)
	local ref = React.useRef(current)
	local ref2 = React.useRef(current2)
	ref.current = current
	ref2.current = current2

	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(0)

	local v = React.useCallback(function()
		if ref3.current then
			return
		end

		local current3 = ref2.current or 0
		local v = ref4.current + current3 - tick()

		local function runCallback() -- 1 equivalent call inferred from this helper
			ref.current()
			ref4.current = tick()
			ref3.current = nil
		end

		if v > 0 then
			ref3.current = Promise.delay(v):andThen(runCallback)
			return
		end

		runCallback() -- inferred equivalent call
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

	return v
end

return useThrottledCallback
