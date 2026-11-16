local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local function scheduleCancellableDelay(duration: number, fn) -- 2 equivalent calls inferred from this helper
	local v = false
	local v2 = false
	local thread = task.delay(duration, function()
		if not v then
			v2 = true
			fn()
		end
	end)

	return function()
		v = true

		if not v2 then
			task.cancel(thread)
		end
	end
end

return {
	useInExpConfigLoadingSkeleton = function(current: boolean, current2: boolean)
		local state, setState = React.useState("idle")
		local ref = React.useRef(current)
		local ref2 = React.useRef(current2)
		ref.current = current
		ref2.current = current2

		React.useEffect(function()
			if not current then
				setState("idle")
			elseif current2 then
				if state == "idle" then
					setState("waiting")
				end
			elseif state == "waiting" or state == "visible" then
				setState("idle")
			end
		end, { current, current2, state })

		React.useEffect(function()
			if state == "waiting" then
				local function fn()
					if ref.current and ref2.current then
						setState("minimum")
					else
						setState("idle")
					end
				end

				return scheduleCancellableDelay(0.35, fn) -- inferred equivalent call
			else
				if state ~= "minimum" then
					return nil
				end

				local function fn()
					if ref.current and ref2.current then
						setState("visible")
					else
						setState("idle")
					end
				end

				return scheduleCancellableDelay(0.5, fn) -- inferred equivalent call
			end
		end, { state })

		return current and (state == "minimum" or state == "visible")
	end,
	CONFIG_LOADING_DELAY_SECONDS = 0.35,
	CONFIG_LOADING_MINIMUM_DISPLAY_SECONDS = 0.5
}
