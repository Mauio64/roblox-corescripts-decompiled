local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

return function(current2: number, current3: number, p: number?, value: boolean?, _: number?)
	local current4 = p or current3
	local state, setState = React.useState(value or false)
	local state2, setState2 = React.useState(false)
	local ref = React.useRef(value or 0)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		local lastTime = tick()
		local thread = nil
		local v = false

		if state then
			local v2 = current3 - ref.current
			local current = current3

			if v2 > 0 then
				local v3 = true
				thread = task.delay(v2, function()
					v = true
					thread = nil
					ref.current = current
					setState2(v3)
				end)
			elseif state2 ~= true then
				v = true
				setState2(true)
			end
		else
			local v2 = ref.current - current2
			local current = current2

			if v2 > 0 then
				local v3 = false
				thread = task.delay(v2, function()
					v = true
					thread = nil
					ref.current = current
					setState2(v3)
				end)
			elseif state2 ~= false then
				v = true
				setState2(false)
			end
		end

		local v2 = state
		return function()
			if not v then
				if thread then
					task.cancel(thread)
				end

				if not ref2.current then
					local v3 = tick() - lastTime

					if not v2 then
						v3 *= -1
					end

					ref.current = math.clamp(ref.current + v3, 0, current4)
				end
			end

			ref2.current = false
		end
	end, { state, state2, current2, current3, current4 })

	return state2, (React.useCallback(function(flag: boolean, current: boolean?)
		ref2.current = current

		if current then
			if flag then
				ref.current = current4
			else
				ref.current = 0
			end
		end

		setState(flag)
	end, { setState }))
end
