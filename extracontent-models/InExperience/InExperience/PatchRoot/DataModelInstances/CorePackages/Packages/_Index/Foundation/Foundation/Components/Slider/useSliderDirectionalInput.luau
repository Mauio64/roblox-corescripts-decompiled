local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Services = require(Foundation.Utility.Wrappers.Services)

local SliderStepDirection = require(script.Parent.SliderStepDirection)

local SliderStepSize = require(script.Parent.SliderStepSize)

local Flags = require(Foundation.Utility.Flags)
local calculateAdjacentStepValue = require(script.Parent.calculateAdjacentStepValue)
local calculateDirectionalStepValue = require(script.Parent.calculateDirectionalStepValue)
local constants = require(script.Parent.constants)

local function getStepForKeyCode(keyCode, flag: boolean)
	if not Flags.FoundationSliderCapture then
		if table.find(constants.coarseIncrement, keyCode) then
			return { sign = 1, size = SliderStepSize.Page }
		end

		if table.find(constants.coarseDecrement, keyCode) then
			return { sign = -1, size = SliderStepSize.Page }
		end
	end

	local v = flag and "vertical" or "horizontal"

	if table.find(constants.stepIncrement[v], keyCode) then
		return { sign = 1, size = SliderStepSize.Step }
	end

	if table.find(constants.stepDecrement[v], keyCode) then
		return { sign = -1, size = SliderStepSize.Step }
	end

	return nil
end

local function isExitKey(keyCode): boolean -- 1 equivalent call inferred from this helper
	return table.find(constants.exit, keyCode) ~= nil
end

local function getRepeatInterval(count: number, step: number?): number -- 1 equivalent call inferred from this helper
	if not Flags.FoundationSliderCapture or step ~= nil and step > 0 then
		return 0.1
	end

	if count >= 15 then
		return 0.03
	end

	return if count >= 5 then 0.06 else 0.1
end

local function useSliderDirectionalInput(flag: boolean, step: number?, range: NumberRange, flag2: boolean, handlers)
	local ref = React.useRef({ step = step, range = range, handlers = handlers })

	ref.current = { step = step, range = range, handlers = handlers }

	React.useEffect(function()
		if not flag then
			return
		end

		local v = nil
		local v2 = 0
		local v3 = SliderStepSize.Step
		local thread = nil
		local v4 = 0
		local v5 = 0

		local function performStep(p: number, p2)
			local current = ref.current
			local v6

			if p > 0 then
				v6 = SliderStepDirection.Increment
			else
				v6 = SliderStepDirection.Decrement
			end

			local onStep = current.handlers.onStep
			local v7

			if Flags.FoundationSliderCapture then
				v7 = calculateAdjacentStepValue(current.handlers.getValue(), v6, current.range, current.step, p2)
			else
				v7 = calculateDirectionalStepValue(current.handlers.getValue(), v6, current.range, current.step, p2)
			end

			onStep(v7)
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

		local function startStepping(p, p2: number, p3)
			if p == v and p2 == v2 and p3 == v3 then
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
			v3 = p3

			performStep(p2, p3)

			thread = task.spawn(function()
				task.wait(0.4)
				local count = 0

				while v == p and v2 == p2 and v3 == p3 do
					performStep(p2, p3)
					count += 1
					task.wait(getRepeatInterval(count, ref.current.step)) -- inferred equivalent call
				end
			end)
		end

		local function evaluateInput(p)
			if Flags.FoundationSliderCapture and isExitKey(p.KeyCode) then -- inferred equivalent call
				local onExit = ref.current.handlers.onExit

				if onExit then
					onExit()
				end

				return
			end

			local stepForKeyCode = getStepForKeyCode(p.KeyCode, flag2)

			if stepForKeyCode then
				startStepping(p, stepForKeyCode.sign, stepForKeyCode.size)
			elseif table.find(constants.analogStep, p.KeyCode) then
				local v6

				if flag2 then
					v6 = p.Position.Y
				else
					v6 = p.Position.X
				end

				if math.abs(v6) >= constants.thumbstickDeadzone then
					local v7 = v6 > 0 and 1 or -1
					local v8

					if v4 == 0 then
						v8 = false
					else
						v8 = v7 ~= v4
					end

					v5 = not v8 and 0 or v5 + 1

					if Flags.FoundationSliderCapture and v8 and v5 < 3 then
						stopStepping(p) -- inferred equivalent call
					else
						v4 = v7
						startStepping(p, v7, SliderStepSize.Step)
					end
				else
					v4 = 0
					v5 = 0
					stopStepping(p) -- inferred equivalent call
				end
			end
		end

		local function handleInputEnded(p)
			if table.find(constants.analogStep, p.KeyCode) then
				v4 = 0
				v5 = 0
			end

			stopStepping(p) -- inferred equivalent call
		end

		local v6 = {
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

			for _, connection in v6 do
				connection:Disconnect()
			end
		end
	end, { flag, flag2 })
end

return useSliderDirectionalInput
