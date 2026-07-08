local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

require(script.Parent.Parent.EventType)

local t1 = {
	Name = "FirstPersonToggleEvent"
}
local u4 = false
local u5 = nil

local function onFirstPersonToggleInput(p1, p2, _) -- line: 16
	-- upvalues: u4 (ref)
	if p1 == "FirstPersonToggleAction" and p2 == Enum.UserInputState.Begin then
		u4 = true
	end

	return Enum.ContextActionResult.Pass
end

function startFirstPersonToggleListener() -- line: 26
	-- upvalues: ContextActionService (copy), onFirstPersonToggleInput (copy)
	ContextActionService:BindCoreAction("FirstPersonToggleAction", onFirstPersonToggleInput, false, Enum.KeyCode.ButtonR3)
end
function stopFirstPersonToggleListener() -- line: 35
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindAction("FirstPersonToggleAction")
end
function t1.StartEvent(p4) -- line: 39
	-- upvalues: u4 (ref), u5 (ref), RunService (copy)
	startFirstPersonToggleListener()

	local function onRenderStepped(_) -- line: 44
		-- upvalues: u4 (ref), p4 (copy), u5 (ref)
		if u4 then
			stopFirstPersonToggleListener()
			task.wait(0.2)
			p4()

			if u5 then
				u5:Disconnect()
				u5 = nil
			end
		end
	end

	u5 = RunService.RenderStepped:Connect(onRenderStepped)
end
function t1.StopEvent() -- line: 64
	-- upvalues: u5 (ref)
	if u5 then
		u5:Disconnect()
	end

	stopFirstPersonToggleListener()
end

return t1
