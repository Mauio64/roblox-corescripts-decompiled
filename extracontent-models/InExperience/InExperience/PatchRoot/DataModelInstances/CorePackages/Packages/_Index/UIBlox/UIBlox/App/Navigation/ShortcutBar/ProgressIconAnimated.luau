local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)

require(script.Parent.Types)

local ProgressIcon = require(script.Parent.ProgressIcon)

local function useRenderStepped(t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}) -- line: 33
	-- upvalues: React (copy), RunService (copy)
	local v11 = React.useRef(0)
	local v12 = React.useRef(0)
	local isAnimationRunning = t1.isAnimationRunning
	local isKeyPressed = t1.isKeyPressed
	local isKeyHolding = t1.isKeyHolding
	local onKeyHolding = t2.onKeyHolding
	local onAnimationRunning = t2.onAnimationRunning
	local onComplete = t2.onComplete
	local onReset = t2.onReset
	local animationTriggerTime = t3.animationTriggerTime
	local animationKeyHoldingTime = t3.animationKeyHoldingTime
	local animationCoolDownTime = t3.animationCoolDownTime
	local v23 = React.useCallback(function(n1: number) -- line: 54
		-- upvalues: v12 (copy), animationTriggerTime (copy), onKeyHolding (copy)
		v12.current = v12.current + n1

		if v12.current >= animationTriggerTime then
			onKeyHolding()
		end
	end, {
		onKeyHolding,
		animationTriggerTime
	})
	local v24 = React.useCallback(function(n2: number) -- line: 61
		-- upvalues: v11 (copy), animationKeyHoldingTime (copy), onAnimationRunning (copy), onComplete (copy)
		v11.current = math.clamp(v11.current + n2 / animationKeyHoldingTime, 0, 1)
		onAnimationRunning(v11.current)

		if v11.current >= 1 then
			onComplete()
		end
	end, {
		onAnimationRunning,
		animationKeyHoldingTime,
		onComplete
	})
	local v25 = React.useCallback(function(n3: number) -- line: 69
		-- upvalues: v11 (copy), animationCoolDownTime (copy), onAnimationRunning (copy), onReset (copy)
		v11.current = math.clamp(v11.current - n3 / animationCoolDownTime, 0, 1)
		onAnimationRunning(v11.current)

		if v11.current <= 0 then
			onReset()
		end
	end, {
		onAnimationRunning,
		animationCoolDownTime,
		onReset
	})

	React.useEffect(function() -- line: 77
		-- upvalues: isKeyHolding (copy), v11 (copy), v24 (copy), isKeyPressed (copy), v23 (copy), isAnimationRunning (copy), v25 (copy), RunService (copy), v12 (copy)
		local connection = nil
		local v47 = nil

		if isKeyHolding then
			v11.current = 0
			v47 = v24
		elseif isKeyPressed then
			v47 = v23
		elseif isAnimationRunning then
			v47 = v25
		end

		if v47 then
			connection = RunService.RenderStepped:Connect(v47)
		end

		if connection then
			return function() -- line: 94
				-- upvalues: isKeyPressed (copy), v12 (copy), connection (ref)
				if isKeyPressed then
					v12.current = 0
				end

				connection:Disconnect()
			end
		end

		return function() -- line: 102
		end
	end, {
		isKeyPressed,
		isKeyHolding,
		isAnimationRunning,
		v23,
		v24,
		v25
	})
end
local function ProgressIconAnimated(p1) -- line: 113
	-- upvalues: React (copy), useRenderStepped (copy), UserInputService (copy), ProgressIcon (copy)
	local v27, v28 = React.useState(false)
	local v29, v30 = React.useState(false)
	local v31, v32 = React.useState(false)
	local v33, v34 = React.useState(false)
	local v35, v36 = React.useBinding(nil)
	local v37 = React.useCallback(function() -- line: 121
		-- upvalues: v30 (copy), v32 (copy)
		v30(true)
		v32(true)
	end, {})
	local v38 = React.useCallback(function(p2) -- line: 126
		-- upvalues: v36 (copy)
		v36(p2)
	end, {})
	local v39 = React.useCallback(function() -- line: 130
		-- upvalues: v28 (copy), v30 (copy), v32 (copy), v34 (copy), p1 (copy)
		v28(false)
		v30(false)
		v32(false)
		v34(true)

		if p1.onHoldComplete then
			p1.onHoldComplete()
		end
	end, { p1.onHoldComplete })
	local v40 = React.useCallback(function() -- line: 140
		-- upvalues: v32 (copy), v36 (copy)
		v32(false)
		v36(nil)
	end, {})

	useRenderStepped({
		isKeyPressed = v27,
		isKeyHolding = v29,
		isAnimationRunning = v31
	}, {
		onKeyHolding = v37,
		onAnimationRunning = v38,
		onComplete = v39,
		onReset = v40
	}, {
		animationTriggerTime = p1.animationTriggerTime,
		animationKeyHoldingTime = p1.animationKeyHoldingTime,
		animationCoolDownTime = p1.animationCoolDownTime
	})

	local v41 = React.useCallback(function(p3) -- line: 160
		-- upvalues: p1 (copy), v28 (copy), v34 (copy), v31 (copy), v30 (copy), v36 (copy)
		if p3.UserInputType ~= Enum.UserInputType.Keyboard and p3.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return
		end

		if p3.KeyCode == p1.keyCode then
			if p3.UserInputState == Enum.UserInputState.Begin then
				v28(true)
				v34(false)

				if v31 then
					v30(true)

					return
				end

				v36(nil)

				return
			end

			if p3.UserInputState == Enum.UserInputState.End then
				v28(false)
				v30(false)
			end
		end
	end, {
		p1.keyCode,
		v31
	})

	React.useEffect(function() -- line: 184
		-- upvalues: p1 (copy), UserInputService (copy), v41 (copy)
		if p1.progress then
			return function() -- line: 186
			end
		end

		local connection = UserInputService.InputBegan:Connect(v41)
		local connection2 = UserInputService.InputEnded:Connect(v41)

		return function() -- line: 191
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {
		v41,
		p1.progress
	})

	local v42 = false

	if p1.progress or (v29 or v31 or v33) then
		v42 = true
	end

	return React.createElement(ProgressIcon, {
		progress = p1.progress or v35,
		icon = p1.icon,
		iconHolding = p1.iconHolding,
		isHolding = v42
	})
end

return ProgressIconAnimated
