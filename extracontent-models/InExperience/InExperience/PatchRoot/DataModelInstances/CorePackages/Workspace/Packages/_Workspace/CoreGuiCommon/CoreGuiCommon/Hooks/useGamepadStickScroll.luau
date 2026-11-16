local parent = script:FindFirstAncestor("CoreGuiCommon").Parent

local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local React = require(parent.React)

local function normalizeStickY(p: number) -- 1 equivalent call inferred from this helper
	local v = math.abs(p)

	if v <= 0.2 then
		return 0
	end

	return math.sign(p) * (v - 0.2) / 0.8
end

local function scrollByStick(current, y: number, dt: number)
	local v = math.max(0, current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y)

	if v == 0 then
		return
	end

	local stickY = normalizeStickY(y) -- inferred equivalent call

	if stickY == 0 then
		return
	end

	local v2 = math.clamp(current.CanvasPosition.Y + dt * -stickY * 1000, 0, v)
	current.CanvasPosition = Vector2.new(current.CanvasPosition.X, v2)
end

local function useGamepadStickScroll(data)
	React.useEffect(function()
		if not data.enabled then
			return
		end

		local contextActionServiceOverride = data.contextActionServiceOverride or ContextActionService
		local runServiceOverride = data.runServiceOverride or RunService
		local v = nil

		contextActionServiceOverride:BindCoreAction(data.actionName, function(_, p, p2)
			if p == Enum.UserInputState.Change then
				v = p2
			elseif p == Enum.UserInputState.End then
				v = nil
			end

			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.Thumbstick2)

		local renderSteppedConnection = runServiceOverride.RenderStepped:Connect(function(dt)
			local current = data.scrollingFrameRef.current

			if v ~= nil and current ~= nil then
				scrollByStick(current, v.Position.Y, dt)
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
