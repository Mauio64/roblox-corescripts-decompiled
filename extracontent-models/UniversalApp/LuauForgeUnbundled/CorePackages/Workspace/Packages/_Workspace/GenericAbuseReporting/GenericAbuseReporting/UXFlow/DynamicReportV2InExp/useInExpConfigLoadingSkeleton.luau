local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local function scheduleCancellableDelay(duration, callback)
	local v5 = false
	local v6 = false
	local thread = task.delay(duration, function()
		if not v5 then
			v6 = true
			callback()
		end
	end)

	return function()
		v5 = true

		if not v6 then
			task.cancel(thread)
		end
	end
end

return {
	useInExpConfigLoadingSkeleton = function(current, current2)
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

				local v5 = false
				local v6 = false
				local thread = task.delay(0.35, function()
					if not v5 then
						v6 = true
						fn()
					end
				end)

				return function()
					v5 = true

					if not v6 then
						task.cancel(thread)
					end
				end
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

				local v5 = false
				local v6 = false
				local thread = task.delay(0.5, function()
					if not v5 then
						v6 = true
						fn()
					end
				end)

				return function()
					v5 = true

					if not v6 then
						task.cancel(thread)
					end
				end
			end
		end, { state })

		return current and (state == "minimum" or state == "visible")
	end,
	CONFIG_LOADING_DELAY_SECONDS = 0.35,
	CONFIG_LOADING_MINIMUM_DISPLAY_SECONDS = 0.5
}
