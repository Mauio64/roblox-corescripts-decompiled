local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("DictationCore").Parent

local React = require(parent.React)

local function isPointerInput(p): boolean -- 3 equivalent calls inferred from this helper
	return p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch
end

local function isGamepadActivation(p): boolean -- 3 equivalent calls inferred from this helper
	return p.KeyCode == Enum.KeyCode.ButtonA
end

local function isGestureInput(p): boolean
	if isPointerInput(p) or UserInputService.GamepadEnabled and isGamepadActivation(p) then -- inferred equivalent call
		return true
	end

	return false
end

local function useLongPress(data)
	local onLongPress = data.onLongPress
	local onTap = data.onTap
	local thresholdSeconds = data.thresholdSeconds or 0.5

	local ref = React.useRef(nil)

	local ref2 = React.useRef(false)

	React.useEffect(function()
		return function()
			local current = ref.current

			if current ~= nil then
				pcall(task.cancel, current)
				ref.current = nil
			end
		end
	end, {})

	local v = React.useCallback(function()
		if ref2.current then
			ref2.current = false
		elseif onTap ~= nil then
			onTap()
		end
	end, { onTap })

	local v2 = React.useCallback(function(_, p)
		if onLongPress ~= nil then
			local v2

			if isPointerInput(p) then -- inferred equivalent call
				v2 = true
			elseif UserInputService.GamepadEnabled then
				v2 = isGamepadActivation(p) and true or false -- inferred equivalent call
			else
				v2 = false
			end

			if v2 then
				local current = ref.current

				if current ~= nil then
					pcall(task.cancel, current)
					ref.current = nil
				end

				ref2.current = false
				ref.current = task.delay(thresholdSeconds, function()
					ref.current = nil
					ref2.current = true

					if onLongPress ~= nil then
						onLongPress()
					end
				end)
			end
		end
	end, { onLongPress, thresholdSeconds })

	local v3 = React.useCallback(function(_, p)
		if onLongPress ~= nil then
			local v3

			if isPointerInput(p) then -- inferred equivalent call
				v3 = true
			elseif UserInputService.GamepadEnabled then
				v3 = isGamepadActivation(p) and true or false -- inferred equivalent call
			else
				v3 = false
			end

			if v3 then
				local current = ref.current

				if current ~= nil then
					pcall(task.cancel, current)
					ref.current = nil
				end
			end
		end
	end, { onLongPress })

	if onLongPress == nil then
		return nil
	end

	return {
		[React.Event.Activated] = v,
		[React.Event.InputBegan] = v2,
		[React.Event.InputEnded] = v3
	}
end

return useLongPress
