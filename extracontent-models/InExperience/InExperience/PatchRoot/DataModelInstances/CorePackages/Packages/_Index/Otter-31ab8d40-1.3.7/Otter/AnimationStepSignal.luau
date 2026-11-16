local RunService = game:GetService("RunService")

local v = {}
local v2 = {
	Connect = function(self, callback)
		v[callback] = true
		return {
			Disconnect = function()
				v[callback] = nil
			end
		}
	end,
	Fire = function(self, p: number)
		for k, _ in v do
			k(p)
		end
	end
}
local AnimationStepSignal = {}

function AnimationStepSignal:Connect(onRenderStepped)
	if _G.__OTTER_MOCK_ANIMATION_STEP_SIGNAL__ then
		return v2:Connect(onRenderStepped)
	end

	return RunService.RenderStepped:Connect(onRenderStepped)
end

function AnimationStepSignal:Fire(value: number?)
	if _G.__OTTER_MOCK_ANIMATION_STEP_SIGNAL__ then
		v2:Fire(value or 1 / 60)
	else
		error("Cannot manually fire real animation step signal")
	end
end

return AnimationStepSignal
