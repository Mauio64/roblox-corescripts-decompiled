local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Services = require(Foundation.Utility.Wrappers.Services)
local SliderStepDirection = require(script.Parent.SliderStepDirection)
local SliderStepSize = require(script.Parent.SliderStepSize)
local calculateDirectionalStepValue = require(script.Parent.calculateDirectionalStepValue)

local function getStepForKeyCode(p1) -- line: 28
	-- upvalues: SliderStepSize (copy)
	if p1 == Enum.KeyCode.Right or p1 == Enum.KeyCode.DPadRight then
		return {
			sign = 1,
			size = SliderStepSize.Step
		}
	end

	if p1 == Enum.KeyCode.Left or p1 == Enum.KeyCode.DPadLeft then
		return {
			sign = -1,
			size = SliderStepSize.Step
		}
	end

	if p1 == Enum.KeyCode.ButtonR1 then
		return {
			sign = 1,
			size = SliderStepSize.Page
		}
	end

	if p1 == Enum.KeyCode.ButtonL1 then
		return {
			sign = -1,
			size = SliderStepSize.Page
		}
	end

	return nil
end
local function useSliderDirectionalInput(b1: boolean, n1: number?, numberRange: NumberRange, t1: {[any]: any}) -- line: 47
	-- upvalues: React (copy), SliderStepSize (copy), calculateDirectionalStepValue (copy), SliderStepDirection (copy), getStepForKeyCode (copy), Services (copy)
	local v15 = React.useRef({
		step = n1,
		range = numberRange,
		handlers = t1
	})

	v15.current = {
		step = n1,
		range = numberRange,
		handlers = t1
	}
	React.useEffect(function() -- line: 60
		-- upvalues: b1 (copy), SliderStepSize (copy), v15 (copy), calculateDirectionalStepValue (copy), SliderStepDirection (copy), getStepForKeyCode (copy), Services (copy)
		if not b1 then
			return
		end

		local u16 = nil
		local n2 = 0
		local Step = SliderStepSize.Step
		local u19 = nil

		local function performStep(n3: number, p2) -- line: 70
			-- upvalues: v15 (copy), calculateDirectionalStepValue (copy), SliderStepDirection (copy)
			local current = v15.current

			current.handlers.onStep(calculateDirectionalStepValue(current.handlers.getValue(), if not (n3 > 0) then SliderStepDirection.Decrement else SliderStepDirection.Increment, current.range, current.step, p2))
		end
		local function stopStepping(p3) -- line: 83
			-- upvalues: u16 (ref), n2 (ref), u19 (ref)
			if p3 ~= nil and p3 ~= u16 then
				return
			end

			u16 = nil
			n2 = 0

			if u19 then
				task.cancel(u19)
				u19 = nil
			end
		end
		local function startStepping(p4, n4: number, p5) -- line: 95
			-- upvalues: u16 (ref), n2 (ref), Step (ref), u19 (ref), v15 (copy), calculateDirectionalStepValue (copy), SliderStepDirection (copy)
			if p4 == u16 and (n4 == n2 and p5 == Step) then
				return
			end

			u16 = nil
			n2 = 0

			if u19 then
				task.cancel(u19)
				u19 = nil
			end

			u16 = p4
			n2 = n4
			Step = p5

			local current = v15.current

			current.handlers.onStep(calculateDirectionalStepValue(current.handlers.getValue(), if not (n4 > 0) then SliderStepDirection.Decrement else SliderStepDirection.Increment, current.range, current.step, p5))
			u19 = task.spawn(function() -- line: 107
				-- upvalues: u16 (ref), p4 (copy), n2 (ref), n4 (copy), Step (ref), p5 (copy), v15 (copy), calculateDirectionalStepValue (copy), SliderStepDirection (copy)
				task.wait(0.4)

				while u16 == p4 and n2 == n4 and Step == p5 do
					local v37 = n4
					local v38 = p5
					local current2 = v15.current

					current2.handlers.onStep(calculateDirectionalStepValue(current2.handlers.getValue(), if not (v37 > 0) then SliderStepDirection.Decrement else SliderStepDirection.Increment, current2.range, current2.step, v38))
					task.wait(0.1)
				end
			end)
		end
		local function evaluateInput(p6) -- line: 119
			-- upvalues: getStepForKeyCode (copy), startStepping (copy), SliderStepSize (copy), u16 (ref), n2 (ref), u19 (ref)
			local v34 = getStepForKeyCode(p6.KeyCode)

			if v34 then
				startStepping(p6, v34.sign, v34.size)

				return
			end

			if p6.KeyCode == Enum.KeyCode.Thumbstick1 then
				if math.abs(p6.Position.X) >= 0.8 then
					startStepping(p6, not (p6.Position.X > 0) and -1 or 1, SliderStepSize.Step)

					return
				end

				if p6 ~= nil and p6 ~= u16 then
					return
				end

				u16 = nil
				n2 = 0

				if u19 then
					task.cancel(u19)
					u19 = nil
				end
			end
		end

		local t2 = {
			Services.UserInputService.InputBegan:Connect(evaluateInput),
			Services.UserInputService.InputChanged:Connect(evaluateInput),
			Services.UserInputService.InputEnded:Connect(stopStepping)
		}

		return function() -- line: 141
			-- upvalues: u16 (ref), n2 (ref), u19 (ref), t2 (copy)
			u16 = nil
			n2 = 0

			if u19 then
				task.cancel(u19)
				u19 = nil
			end

			for _, v36 in t2 do
				v36:Disconnect()
			end
		end
	end, { b1 })
end

return useSliderDirectionalInput
