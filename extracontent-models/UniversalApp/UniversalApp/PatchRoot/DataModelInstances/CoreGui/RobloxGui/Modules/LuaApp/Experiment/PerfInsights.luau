local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local React = require(CorePackages.Packages.React)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local v7 = game:DefineFastString("PerfInsightsIXPLayer", "PerfRegressionTestLayer")
local v8 = game:DefineFastFlag("PerfInsightsEnabled", false)
local t1 = {
	hbMin = game:DefineFastInt("PerfInsightsHbMin", 0),
	hbMax = game:DefineFastInt("PerfInsightsHbMax", 0),
	inMin = game:DefineFastInt("PerfInsightsInMin", 0),
	inMax = game:DefineFastInt("PerfInsightsInMax", 0)
}
local u10 = t1
local n1 = 0

function PerformTask(p1, p2) -- line: 24
	local v14 = tick() + math.random(p1, p2) * 0.001
	local n2 = 0

	while v14 > tick() do
		n2 += 1
	end
end
function FrameWork() -- line: 32
	-- upvalues: n1 (ref), u10 (ref)
	if tick() < n1 + 2 then
		PerformTask(u10.hbMin, u10.hbMax)
	end
end
function InputWork() -- line: 38
	-- upvalues: u10 (ref)
	PerformTask(u10.inMin, u10.inMax)
end

return function() -- line: 42
	-- upvalues: v8 (copy), AppUserLayers (copy), v7 (copy), u10 (ref), useUserExperiment (copy), t1 (copy), React (copy), RunService (copy), UserInputService (copy), n1 (ref)
	if not v8 then
		return nil
	end

	local v16 = AppUserLayers[v7]

	u10 = useUserExperiment({ v16 }, function(p3) -- line: 51
		-- upvalues: t1 (copy), v16 (copy)
		local v19 = t1
		local v20 = p3[v16]

		if v20 then
			v19.hbMin = v20.PerfInsightsHbMin or v19.hbMin
			v19.hbMax = v20.PerfInsightsHbMax or v19.hbMax
			v19.inMin = v20.PerfInsightsInMin or v19.inMin
			v19.inMax = v20.PerfInsightsInMax or v19.inMax
		end

		return v19
	end)

	local v17 = u10.hbMin > 0 or (u10.hbMax > 0 or (u10.inMin > 0 or u10.inMax > 0))

	React.useEffect(function() -- line: 65
		-- upvalues: v17 (copy), RunService (copy), UserInputService (copy), n1 (ref)
		if not v17 then
			return function() -- line: 67
			end
		end

		local t2 = {}
		local u22 = false
		local u23 = false

		table.insert(t2, RunService.Stepped:Connect(FrameWork))
		table.insert(t2, UserInputService.InputBegan:Connect(function(input) -- line: 78
			-- upvalues: u22 (ref), n1 (ref)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				u22 = true
				n1 = tick()
			end
		end))
		table.insert(t2, UserInputService.InputChanged:Connect(function() -- line: 91
			-- upvalues: u22 (ref), u23 (ref), n1 (ref)
			if u22 then
				u23 = true
			end

			n1 = tick()
		end))
		table.insert(t2, UserInputService.InputEnded:Connect(function() -- line: 101
			-- upvalues: u22 (ref), u23 (ref)
			if u22 and not u23 then
				InputWork()
			end

			u22 = false
			u23 = false
		end))

		return function() -- line: 110
			-- upvalues: t2 (copy)
			for _, v26 in t2 do
				v26:Disconnect()
			end
		end
	end, { v17 })

	return nil
end
