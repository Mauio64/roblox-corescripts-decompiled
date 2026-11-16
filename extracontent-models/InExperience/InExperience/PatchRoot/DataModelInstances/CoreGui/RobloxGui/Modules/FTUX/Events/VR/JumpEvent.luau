local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
require(script.Parent.Parent.EventType)

local JumpEvent = { Name = "FirstPersonToggleEvent" }

local flag = false
local renderSteppedConnection = nil

local function onJumpInput(p, p2, _)
	if p == "JumpAction" and p2 == Enum.UserInputState.Begin then
		flag = true
	end

	return Enum.ContextActionResult.Pass
end

function startJumpEventListener()
	ContextActionService:BindCoreAction("JumpAction", onJumpInput, false, Enum.KeyCode.Space)
end

function stopJumpEventListener()
	ContextActionService:UnbindAction("JumpAction")
end

function JumpEvent.StartEvent(callback)
	startJumpEventListener()

	local function onRenderStepped(_)
		if flag then
			stopJumpEventListener()

			callback()

			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end
		end
	end

	renderSteppedConnection = RunService.RenderStepped:Connect(onRenderStepped)
end

function JumpEvent.StopEvent()
	if renderSteppedConnection then
		renderSteppedConnection:Disconnect()
		renderSteppedConnection = nil
	end

	stopJumpEventListener()
end

return JumpEvent
