local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Services = require(Foundation.Utility.Wrappers.Services)

local SliderStepDirection = require(Foundation.Components.Slider.SliderStepDirection)

local calculateAdjacentStepValue = require(Foundation.Components.Slider.calculateAdjacentStepValue)
local constants = require(Foundation.Components.Slider.constants)

local function getStepSignForKeyCode(keyCode, flag: boolean): nil | number -- 1 equivalent call inferred from this helper
	local v = flag and "vertical" or "horizontal"

	if table.find(constants.stepIncrement[v], keyCode) then
		return 1
	end

	if table.find(constants.stepDecrement[v], keyCode) then
		return -1
	end

	return nil
end

local function isExitKey(keyCode): boolean -- 1 equivalent call inferred from this helper
	return table.find(constants.exit, keyCode) ~= nil
end

local function getRepeatInterval(p: number, p2: number?): number
	if p2 ~= nil and p2 > 0 then
		return 0.1
	end

	if p >= 15 then
		return 0.03
	end

	return if p >= 5 then 0.06 else 0.1
end

local function useSliderDirectionalInput(flag: boolean, step2: number?, range: NumberRange, flag2: boolean, handlers)
	local ref = React.useRef({ step = step2, range = range, handlers = handlers })

	ref.current = { step = step2, range = range, handlers = handlers }

	React.useEffect(function()
		if not flag then
			return
		end

		local v = nil
		local v2 = 0
		local thread = nil
		local v3 = 0
		local v4 = 0

		local function performStep(p: number) -- 2 equivalent calls inferred from this helper
			local current = ref.current
			local v5

			if p > 0 then
				v5 = SliderStepDirection.Increment
			else
				v5 = SliderStepDirection.Decrement
			end

			current.handlers.onStep(calculateAdjacentStepValue(
				current.handlers.getValue(),
				v5,
				current.range,
				current.step
			))
		end

		local function stopStepping(p) -- 3 equivalent calls inferred from this helper
			if p ~= nil and p ~= v then
				return
			end

			v = nil
			v2 = 0

			if thread then
				task.cancel(thread)
				thread = nil
			end
		end

		local function startStepping(p, p2: number)
			if p == v and p2 == v2 then
				return
			end

			v = nil
			v2 = 0

			if thread then
				task.cancel(thread)
				thread = nil
			end

			v = p
			v2 = p2
			performStep(p2) -- inferred equivalent call
			thread = task.spawn(function()
				task.wait(0.4)
				local count = 0

				while v == p and v2 == p2 do
					performStep(p2) -- inferred equivalent call
					count += 1
					local step = ref.current.step
					task.wait((step == nil or not (step > 0)) and (count >= 15 and 0.03 or count >= 5 and 0.06 or 0.1) or 0.1)
				end
			end)
		end

		local function evaluateInput(p)
			if isExitKey(p.KeyCode) then -- inferred equivalent call
				ref.current.handlers.onExit()
				return
			end

			local stepSignForKeyCode = getStepSignForKeyCode(p.KeyCode, flag2) -- inferred equivalent call

			if stepSignForKeyCode then
				startStepping(p, stepSignForKeyCode)
			elseif table.find(constants.analogStep, p.KeyCode) then
				local v5

				if flag2 then
					v5 = p.Position.Y
				else
					v5 = p.Position.X
				end

				if math.abs(v5) >= constants.thumbstickDeadzone then
					local v6 = v5 > 0 and 1 or -1
					local v7

					if v3 == 0 then
						v7 = false
					else
						v7 = v6 ~= v3
					end

					v4 = not v7 and 0 or v4 + 1

					if v7 and v4 < 3 then
						stopStepping(p) -- inferred equivalent call
					else
						v3 = v6
						startStepping(p, v6)
					end
				else
					v3 = 0
					v4 = 0
					stopStepping(p) -- inferred equivalent call
				end
			end
		end

		local function handleInputEnded(p)
			if table.find(constants.analogStep, p.KeyCode) then
				v3 = 0
				v4 = 0
			end

			stopStepping(p) -- inferred equivalent call
		end

		local v5 = {
			Services.UserInputService.InputBegan:Connect(evaluateInput),
			Services.UserInputService.InputChanged:Connect(evaluateInput),
			Services.UserInputService.InputEnded:Connect(handleInputEnded)
		}

		return function()
			v = nil
			v2 = 0

			if thread then
				task.cancel(thread)
				thread = nil
			end

			for _, connection in v5 do
				connection:Disconnect()
			end
		end
	end, { flag, flag2 })
end

return useSliderDirectionalInput
