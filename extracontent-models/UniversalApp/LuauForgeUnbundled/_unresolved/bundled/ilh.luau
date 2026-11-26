local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local React = require(CorePackages.Packages.React)
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers

local defineFastString = game:DefineFastString("PerfInsightsIXPLayer", "PerfRegressionTestLayer")
local defineFastFlag = game:DefineFastFlag("PerfInsightsEnabled", false)

local v5 = {
	hbMin = game:DefineFastInt("PerfInsightsHbMin", 0),
	hbMax = game:DefineFastInt("PerfInsightsHbMax", 0),
	inMin = game:DefineFastInt("PerfInsightsInMin", 0),
	inMax = game:DefineFastInt("PerfInsightsInMax", 0)
}

local v6 = v5

local v7 = 0

function LUAUFORGE_MODULE_GLOBALS_ilh_PerformTask(p2, p3)
	local v8 = tick() + math.random(p2, p3) * 0.001
	local count = 0

	while tick() < v8 do
		count += 1
	end
end

function LUAUFORGE_MODULE_GLOBALS_ilh_FrameWork()
	if tick() < v7 + 2 then
		LUAUFORGE_MODULE_GLOBALS_ilh_PerformTask(v6.hbMin, v6.hbMax)
	end
end

function LUAUFORGE_MODULE_GLOBALS_ilh_InputWork()
	LUAUFORGE_MODULE_GLOBALS_ilh_PerformTask(v6.inMin, v6.inMax)
end

return function(): nil
	if not defineFastFlag then
		return nil
	end

	local appUserLayer = appUserLayers[defineFastString]

	v6 = useUserExperiment({ appUserLayer }, function(p2)
		local v8 = v5
		local v9 = p2[appUserLayer]

		if not v9 then
			return v8
		end

		v8.hbMin = v9.PerfInsightsHbMin or v8.hbMin
		v8.hbMax = v9.PerfInsightsHbMax or v8.hbMax
		v8.inMin = v9.PerfInsightsInMin or v8.inMin
		v8.inMax = v9.PerfInsightsInMax or v8.inMax

		return v8
	end)

	local v8 = v6.hbMin > 0 or v6.hbMax > 0 or v6.inMin > 0 or v6.inMax > 0

	React.useEffect(function()
		if not v8 then
			return function() end
		end

		local connections = {}
		local flag = false
		local v9 = false

		table.insert(connections, RunService.Stepped:Connect(LUAUFORGE_MODULE_GLOBALS_ilh_FrameWork))

		table.insert(connections, UserInputService.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				flag = true
				v7 = tick()
			end
		end))

		table.insert(connections, UserInputService.InputChanged:Connect(function()
			if flag then
				v9 = true
			end

			v7 = tick()
		end))

		table.insert(connections, UserInputService.InputEnded:Connect(function()
			if flag and not v9 then
				LUAUFORGE_MODULE_GLOBALS_ilh_InputWork()
			end

			flag = false
			v9 = false
		end))

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { v8 })

	return nil
end
