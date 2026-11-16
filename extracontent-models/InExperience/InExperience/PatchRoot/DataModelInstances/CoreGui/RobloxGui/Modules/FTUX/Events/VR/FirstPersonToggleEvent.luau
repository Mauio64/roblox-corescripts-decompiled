local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
require(script.Parent.Parent.EventType)

local FirstPersonToggleEvent = { Name = "FirstPersonToggleEvent" }

local flag = false
local renderSteppedConnection = nil

local function onFirstPersonToggleInput(p, p2, _)
	if p == "FirstPersonToggleAction" and p2 == Enum.UserInputState.Begin then
		flag = true
	end

	return Enum.ContextActionResult.Pass
end

function startFirstPersonToggleListener()
	ContextActionService:BindCoreAction(
		"FirstPersonToggleAction",
		onFirstPersonToggleInput,
		false,
		Enum.KeyCode.ButtonR3
	)
end

function stopFirstPersonToggleListener()
	ContextActionService:UnbindAction("FirstPersonToggleAction")
end

function FirstPersonToggleEvent.StartEvent(callback)
	startFirstPersonToggleListener()

	local function onRenderStepped(_)
		if flag then
			stopFirstPersonToggleListener()

			task.wait(0.2)
			callback()

			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end
		end
	end

	renderSteppedConnection = RunService.RenderStepped:Connect(onRenderStepped)
end

function FirstPersonToggleEvent.StopEvent()
	if renderSteppedConnection then
		renderSteppedConnection:Disconnect()
	end

	stopFirstPersonToggleListener()
end

return FirstPersonToggleEvent
