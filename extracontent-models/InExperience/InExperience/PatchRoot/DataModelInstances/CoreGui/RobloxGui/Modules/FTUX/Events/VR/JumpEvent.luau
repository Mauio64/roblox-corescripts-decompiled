local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

require(script.Parent.Parent.EventType)

local t1 = {
	Name = "FirstPersonToggleEvent"
}
local u4 = false
local u5 = nil

local function onJumpInput(p1, p2, _) -- line: 16
	-- upvalues: u4 (ref)
	if p1 == "JumpAction" and p2 == Enum.UserInputState.Begin then
		u4 = true
	end

	return Enum.ContextActionResult.Pass
end

function startJumpEventListener() -- line: 26
	-- upvalues: ContextActionService (copy), onJumpInput (copy)
	ContextActionService:BindCoreAction("JumpAction", onJumpInput, false, Enum.KeyCode.Space)
end
function stopJumpEventListener() -- line: 30
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindAction("JumpAction")
end
function t1.StartEvent(p4) -- line: 34
	-- upvalues: u4 (ref), u5 (ref), RunService (copy)
	startJumpEventListener()

	local function onRenderStepped(_) -- line: 39
		-- upvalues: u4 (ref), p4 (copy), u5 (ref)
		if u4 then
			stopJumpEventListener()
			p4()

			if u5 then
				u5:Disconnect()
				u5 = nil
			end
		end
	end

	u5 = RunService.RenderStepped:Connect(onRenderStepped)
end
function t1.StopEvent() -- line: 58
	-- upvalues: u5 (ref)
	if u5 then
		u5:Disconnect()
		u5 = nil
	end

	stopJumpEventListener()
end

return t1
