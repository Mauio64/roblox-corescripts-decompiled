local RunService = game:GetService("RunService")
local t1 = {}
local t2 = {
	Connect = function(_, p2: ((...any) -> ...any)) -- line: 8
		-- upvalues: t1 (copy)
		t1[p2] = true

		return {
			Disconnect = function() -- line: 11
				-- upvalues: t1 (copy), p2 (copy)
				t1[p2] = nil
			end
		}
	end,
	Fire = function(_, n1: number) -- line: 16
		-- upvalues: t1 (copy)
		for v8, _ in t1 do
			v8(n1)
		end
	end
}

return {
	Connect = function(_, p5) -- line: 24
		-- upvalues: t2 (copy), RunService (copy)
		if _G.__OTTER_MOCK_ANIMATION_STEP_SIGNAL__ then
			return t2:Connect(p5)
		end

		return RunService.RenderStepped:Connect(p5)
	end,
	Fire = function(_, n2: number?) -- line: 31
		-- upvalues: t2 (copy)
		if _G.__OTTER_MOCK_ANIMATION_STEP_SIGNAL__ then
			t2:Fire(n2 or 0.016666666666666666)

			return
		end

		error("Cannot manually fire real animation step signal")
	end
}
