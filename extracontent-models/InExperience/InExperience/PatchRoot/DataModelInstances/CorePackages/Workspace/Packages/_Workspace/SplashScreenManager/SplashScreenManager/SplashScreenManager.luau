local parent = script:FindFirstAncestor("SplashScreenManager").Parent

game:GetService("RunService")
local MockableProxyServices = require(parent.MockableProxyServices)
local RunService = MockableProxyServices.RunService

local __splashScreenManager_Fader__ = nil
local function obfuscateEnvironment() -- 1 equivalent call inferred from this helper
	__splashScreenManager_Fader__ = Instance.new("ColorCorrectionEffect")

	if __splashScreenManager_Fader__ then
		__splashScreenManager_Fader__.Name = "__SplashScreenManager_Fader__"
		__splashScreenManager_Fader__.Parent = game:GetService("Lighting")

		__splashScreenManager_Fader__.TintColor = Color3.new(0, 0, 0)
		__splashScreenManager_Fader__.Enabled = true
	end
end

local function unobfuscateEnvironment() -- 1 equivalent call inferred from this helper
	if __splashScreenManager_Fader__ then
		__splashScreenManager_Fader__:Destroy()
		__splashScreenManager_Fader__ = nil
	end
end

local v = false
local v2 = true
local v3 = false
local v4 = {}

local function callCallbacks() -- 2 equivalent calls inferred from this helper
	for _, v5 in v4 do
		v5(v2)
	end
end

local SplashScreenManager = {}

function SplashScreenManager.initialize(p: number, p2: number?, p3: number?)
	local function fn() -- 1 equivalent call inferred from this helper
		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
		end

		unobfuscateEnvironment() -- inferred equivalent call
		v2 = true
		v3 = false
	end

	if not (v3 or v) then
		v2 = false
		obfuscateEnvironment() -- inferred equivalent call
		callCallbacks() -- inferred equivalent call
		local dts = {}
		local v5 = 0
		local v6 = 1 / p
		local v7 = p3 or p

		local lastTime = tick()
		local v8 = 0

		local renderSteppedConnection = nil

		renderSteppedConnection = RunService.RenderStepped:Connect(function(dt)
			v8 = tick() - lastTime

			table.insert(dts, dt)
			v5 += dt

			if v7 < #dts then
				local v9 = table.remove(dts, 1)

				if v9 ~= nil then
					v5 -= v9
				end
			end

			local v9 = v5 / #dts

			if p2 and p2 < v8 or v7 <= #dts and math.floor(v9 * 100) <= math.floor(v6 * 100) then
				v2 = true
				callCallbacks() -- inferred equivalent call
				fn() -- inferred equivalent call
			end
		end)

		v3 = true
	end
end

function SplashScreenManager.addStatusChangeListener(p)
	table.insert(v4, p)
	return p
end

function SplashScreenManager.removeStatusChangeListener(p)
	for k, v5 in v4 do
		if v5 == p then
			table.remove(v4, k)
		end
	end
end

function SplashScreenManager.isFPSAtTarget()
	return v2
end

function SplashScreenManager.__setTestMode()
	v = true
end

return SplashScreenManager
