local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/React")

local function normalizeStickY(p2)
	local v5 = math.abs(p2)

	if v5 <= 0.2 then
		return 0
	end

	return math.sign(p2) * (v5 - 0.2) / 0.8
end

local function scrollByStick(current, y, dt)
	local v5 = math.max(0, current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y)

	if v5 == 0 then
		return
	end

	local v6 = math.abs(y)
	local v7 = v6 <= 0.2 and 0 or math.sign(y) * (v6 - 0.2) / 0.8

	if v7 == 0 then
		return
	end

	local v8 = math.clamp(current.CanvasPosition.Y + dt * -v7 * 1000, 0, v5)
	current.CanvasPosition = Vector2.new(current.CanvasPosition.X, v8)
end

local function useGamepadStickScroll(data)
	React.useEffect(function()
		if not data.enabled then
			return
		end

		local contextActionServiceOverride = data.contextActionServiceOverride or ContextActionService
		local runServiceOverride = data.runServiceOverride or RunService
		local v5 = nil

		contextActionServiceOverride:BindCoreAction(data.actionName, function(p2, p3, p4)
			if p3 == Enum.UserInputState.Change then
				v5 = p4
			elseif p3 == Enum.UserInputState.End then
				v5 = nil
			end

			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.Thumbstick2)

		local renderSteppedConnection = runServiceOverride.RenderStepped:Connect(function(dt)
			local current = data.scrollingFrameRef.current

			if v5 ~= nil and current ~= nil then
				scrollByStick(current, v5.Position.Y, dt)
			end
		end)

		return function()
			contextActionServiceOverride:UnbindCoreAction(data.actionName)
			renderSteppedConnection:Disconnect()
		end
	end, {
		data.actionName,
		data.enabled,
		data.scrollingFrameRef,
		data.contextActionServiceOverride,
		data.runServiceOverride
	})
end

return useGamepadStickScroll
