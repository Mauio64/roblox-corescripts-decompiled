local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local parent = script.Parent.Parent.Parent.Parent.Parent

local React = require(parent.React)
require(script.Parent.Types)
local ProgressIcon = require(script.Parent.ProgressIcon)

local function useRenderStepped(data, data2, data3)
	local ref = React.useRef(0)
	local ref2 = React.useRef(0)

	local isAnimationRunning = data.isAnimationRunning
	local isKeyPressed = data.isKeyPressed
	local isKeyHolding = data.isKeyHolding

	local onKeyHolding = data2.onKeyHolding
	local onAnimationRunning = data2.onAnimationRunning
	local onComplete = data2.onComplete
	local onReset = data2.onReset

	local animationTriggerTime = data3.animationTriggerTime
	local animationKeyHoldingTime = data3.animationKeyHoldingTime
	local animationCoolDownTime = data3.animationCoolDownTime

	local v = React.useCallback(function(p: number)
		ref2.current += p

		if animationTriggerTime <= ref2.current then
			onKeyHolding()
		end
	end, { onKeyHolding, animationTriggerTime })

	local v2 = React.useCallback(function(p: number)
		ref.current = math.clamp(ref.current + p / animationKeyHoldingTime, 0, 1)
		onAnimationRunning(ref.current)

		if ref.current >= 1 then
			onComplete()
		end
	end, { onAnimationRunning, animationKeyHoldingTime, onComplete })

	local v3 = React.useCallback(function(p: number)
		ref.current = math.clamp(ref.current - p / animationCoolDownTime, 0, 1)
		onAnimationRunning(ref.current)

		if ref.current <= 0 then
			onReset()
		end
	end, { onAnimationRunning, animationCoolDownTime, onReset })

	React.useEffect(function()
		local renderSteppedConnection = nil
		local v4 = nil

		if isKeyHolding then
			ref.current = 0
			v4 = v2
		elseif isKeyPressed then
			v4 = v
		elseif isAnimationRunning then
			v4 = v3
		end

		if v4 then
			renderSteppedConnection = RunService.RenderStepped:Connect(v4)
		end

		if renderSteppedConnection then
			return function()
				if isKeyPressed then
					ref2.current = 0
				end

				renderSteppedConnection:Disconnect()
			end
		end

		return function() end
	end, { isKeyPressed, isKeyHolding, isAnimationRunning, v, v2, v3 })
end

local function ProgressIconAnimated(props)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)

	local v, v2 = React.useBinding(nil)

	useRenderStepped({ isKeyPressed = state, isKeyHolding = state2, isAnimationRunning = state3 }, {
		onKeyHolding = React.useCallback(function()
			setState2(true)
			setState3(true)
		end, {}),
		onAnimationRunning = React.useCallback(function(p)
			v2(p)
		end, {}),
		onComplete = React.useCallback(function()
			setState(false)
			setState2(false)
			setState3(false)
			setState4(true)

			if props.onHoldComplete then
				props.onHoldComplete()
			end
		end, { props.onHoldComplete }),
		onReset = React.useCallback(function()
			setState3(false)
			v2(nil)
		end, {})
	}, {
		animationTriggerTime = props.animationTriggerTime,
		animationKeyHoldingTime = props.animationKeyHoldingTime,
		animationCoolDownTime = props.animationCoolDownTime
	})

	local v3 = React.useCallback(function(data)
		if data.UserInputType ~= Enum.UserInputType.Keyboard and data.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return
		end

		if data.KeyCode == props.keyCode then
			if data.UserInputState == Enum.UserInputState.Begin then
				setState(true)
				setState4(false)

				if state3 then
					setState2(true)
				else
					v2(nil)
				end
			elseif data.UserInputState == Enum.UserInputState.End then
				setState(false)
				setState2(false)
			end
		end
	end, { props.keyCode, state3 })

	React.useEffect(function()
		if props.progress then
			return function() end
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(v3)
		local inputEndedConnection = UserInputService.InputEnded:Connect(v3)
		return function()
			inputBeganConnection:Disconnect()
			inputEndedConnection:Disconnect()
		end
	end, { v3, props.progress })

	local isHolding = (props.progress or state2 or state3 or state4) and true or false

	return React.createElement(ProgressIcon, {
		progress = props.progress or v,
		icon = props.icon,
		iconHolding = props.iconHolding,
		isHolding = isHolding
	})
end

return ProgressIconAnimated
