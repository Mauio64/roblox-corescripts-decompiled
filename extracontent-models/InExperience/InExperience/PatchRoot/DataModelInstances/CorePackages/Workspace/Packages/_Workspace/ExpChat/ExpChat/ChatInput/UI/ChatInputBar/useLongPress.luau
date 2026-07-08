local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)

local function isPointerInput(p1) -- line: 22
	return p1.UserInputType == Enum.UserInputType.MouseButton1 or p1.UserInputType == Enum.UserInputType.Touch
end
local function isGamepadActivation(p2) -- line: 26
	return p2.KeyCode == Enum.KeyCode.ButtonA
end
local function isGestureInput(p3) -- line: 33
	-- upvalues: UserInputService (copy)
	if p3.UserInputType == Enum.UserInputType.MouseButton1 or p3.UserInputType == Enum.UserInputType.Touch then
		return true
	end

	if UserInputService.GamepadEnabled and p3.KeyCode == Enum.KeyCode.ButtonA then
		return true
	end

	return false
end
local function useLongPress(t1: {[any]: any}) -- line: 53
	-- upvalues: React (copy), UserInputService (copy)
	local onLongPress = t1.onLongPress
	local onTap = t1.onTap
	local v14 = t1.thresholdSeconds or 0.5
	local v15 = React.useRef(nil)
	local v16 = React.useRef(false)

	React.useEffect(function() -- line: 67
		-- upvalues: v15 (copy)
		return function() -- line: 68
			-- upvalues: v15 (copy)
			local current = v15.current

			if current ~= nil then
				pcall(task.cancel, current)
				v15.current = nil
			end
		end
	end, {})

	local v17 = React.useCallback(function() -- line: 77
		-- upvalues: v16 (copy), onTap (copy)
		if v16.current then
			v16.current = false

			return
		end

		if onTap ~= nil then
			onTap()
		end
	end, { onTap })
	local v18 = React.useCallback(function(_, p5) -- line: 87
		-- upvalues: onLongPress (copy), UserInputService (copy), v15 (copy), v16 (copy), v14 (copy)
		if onLongPress == nil or p5.UserInputType ~= Enum.UserInputType.MouseButton1 and p5.UserInputType ~= Enum.UserInputType.Touch and (not UserInputService.GamepadEnabled or p5.KeyCode ~= Enum.KeyCode.ButtonA) then
			return
		end

		local current = v15.current

		if current ~= nil then
			pcall(task.cancel, current)
			v15.current = nil
		end

		v16.current = false
		v15.current = task.delay(v14, function() -- line: 100
			-- upvalues: v15 (copy), v16 (copy), onLongPress (copy)
			v15.current = nil
			v16.current = true

			if onLongPress ~= nil then
				onLongPress()
			end
		end)
	end, {
		onLongPress,
		v14
	})
	local v19 = React.useCallback(function(_, p7) -- line: 109
		-- upvalues: onLongPress (copy), UserInputService (copy), v15 (copy)
		if onLongPress == nil or p7.UserInputType ~= Enum.UserInputType.MouseButton1 and p7.UserInputType ~= Enum.UserInputType.Touch and (not UserInputService.GamepadEnabled or p7.KeyCode ~= Enum.KeyCode.ButtonA) then
			return
		end

		local current = v15.current

		if current ~= nil then
			pcall(task.cancel, current)
			v15.current = nil
		end
	end, { onLongPress })

	if onLongPress == nil then
		return nil
	end

	return {
		[React.Event.Activated] = v17,
		[React.Event.InputBegan] = v18,
		[React.Event.InputEnded] = v19
	}
end

return useLongPress
