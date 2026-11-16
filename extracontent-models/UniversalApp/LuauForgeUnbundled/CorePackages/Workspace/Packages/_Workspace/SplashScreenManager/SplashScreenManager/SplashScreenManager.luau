game:GetService("RunService")
local runService = require("@game/CorePackages/Workspace/Packages/_Workspace/SplashScreenManager/MockableProxyServices").RunService

local __splashScreenManager_Fader__ = nil
local function obfuscateEnvironment()
	__splashScreenManager_Fader__ = Instance.new("ColorCorrectionEffect")

	if __splashScreenManager_Fader__ then
		__splashScreenManager_Fader__.Name = "__SplashScreenManager_Fader__"
		__splashScreenManager_Fader__.Parent = game:GetService("Lighting")

		__splashScreenManager_Fader__.TintColor = Color3.new(0, 0, 0)
		__splashScreenManager_Fader__.Enabled = true
	end
end

local function unobfuscateEnvironment()
	if __splashScreenManager_Fader__ then
		__splashScreenManager_Fader__:Destroy()
		__splashScreenManager_Fader__ = nil
	end
end

local v5 = false
local v6 = true
local v7 = false
local v8 = {}

local function callCallbacks()
	for k, v9 in v8 do
		v9(v6)
	end
end

return {
	initialize = function(p2, p3, p4)
		if not (v7 or v5) then
			v6 = false
			__splashScreenManager_Fader__ = Instance.new("ColorCorrectionEffect")

			if __splashScreenManager_Fader__ then
				__splashScreenManager_Fader__.Name = "__SplashScreenManager_Fader__"
				__splashScreenManager_Fader__.Parent = game:GetService("Lighting")

				__splashScreenManager_Fader__.TintColor = Color3.new(0, 0, 0)
				__splashScreenManager_Fader__.Enabled = true
			end

			for k, v9 in v8 do
				v9(v6)
			end

			local dts = {}
			local v9 = 0
			local v10 = 1 / p2
			local v11 = p4 or p2

			local lastTime = tick()
			local v12 = 0

			local renderSteppedConnection = nil

			renderSteppedConnection = runService.RenderStepped:Connect(function(dt)
				v12 = tick() - lastTime

				table.insert(dts, dt)
				v9 += dt

				if v11 < #dts then
					local v14 = table.remove(dts, 1)

					if v14 ~= nil then
						v9 -= v14
					end
				end

				local v14 = v9 / #dts

				if p3 and p3 < v12 then
					v6 = true

					for k, v16 in v8 do
						v16(v6)
					end

					if renderSteppedConnection then
						renderSteppedConnection:Disconnect()
					end

					if __splashScreenManager_Fader__ then
						__splashScreenManager_Fader__:Destroy()
						__splashScreenManager_Fader__ = nil
					end

					v6 = true
					v7 = false
				elseif v11 <= #dts and math.floor(v14 * 100) <= math.floor(v10 * 100) then
					v6 = true

					for k, v16 in v8 do
						v16(v6)
					end

					if renderSteppedConnection then
						renderSteppedConnection:Disconnect()
					end

					if __splashScreenManager_Fader__ then
						__splashScreenManager_Fader__:Destroy()
						__splashScreenManager_Fader__ = nil
					end

					v6 = true
					v7 = false
				end
			end)

			v7 = true
		end
	end,
	addStatusChangeListener = function(p2)
		table.insert(v8, p2)
		return p2
	end,
	removeStatusChangeListener = function(p2)
		for k, v9 in v8 do
			if v9 == p2 then
				table.remove(v8, k)
			end
		end
	end,
	isFPSAtTarget = function()
		return v6
	end,
	__setTestMode = function()
		v5 = true
	end
}
