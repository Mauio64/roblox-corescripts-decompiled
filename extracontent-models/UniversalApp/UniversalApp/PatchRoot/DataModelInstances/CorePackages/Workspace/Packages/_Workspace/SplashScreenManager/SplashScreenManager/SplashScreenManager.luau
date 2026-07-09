local Parent = script:FindFirstAncestor("SplashScreenManager").Parent

game:GetService("RunService")

local RunService = require(Parent.MockableProxyServices).RunService
local ColorCorrectionEffect = nil

local function obfuscateEnvironment() -- line: 19
	-- upvalues: ColorCorrectionEffect (ref)
	ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

	if ColorCorrectionEffect then
		ColorCorrectionEffect.Name = "__SplashScreenManager_Fader__"
		ColorCorrectionEffect.Parent = game:GetService("Lighting")
		ColorCorrectionEffect.TintColor = Color3.new(0, 0, 0)
		ColorCorrectionEffect.Enabled = true
	end
end
local function unobfuscateEnvironment() -- line: 30
	-- upvalues: ColorCorrectionEffect (ref)
	if ColorCorrectionEffect then
		ColorCorrectionEffect:Destroy()
		ColorCorrectionEffect = nil
	end
end

local u6 = false
local u7 = true
local u8 = false
local t1 = {}

local function callCallbacks() -- line: 43
	-- upvalues: t1 (copy), u7 (ref)
	for _, v12 in t1 do
		v12(u7)
	end
end

return {
	initialize = function(n1: number, n2: number?, n3: number?) -- line: 50
		-- upvalues: u8 (ref), u6 (ref), u7 (ref), ColorCorrectionEffect (ref), t1 (copy), RunService (ref)
		if not u8 and not u6 then
			u7 = false
			ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			if ColorCorrectionEffect then
				ColorCorrectionEffect.Name = "__SplashScreenManager_Fader__"
				ColorCorrectionEffect.Parent = game:GetService("Lighting")
				ColorCorrectionEffect.TintColor = Color3.new(0, 0, 0)
				ColorCorrectionEffect.Enabled = true
			end

			for _, v17 in t1 do
				v17(u7)
			end

			local t2 = {}
			local n4 = 0
			local v20 = 1 / n1
			local v21 = n3 or n1
			local timestamp = tick()
			local n5 = 0
			local connection = nil

			connection = RunService.RenderStepped:Connect(function(dt) -- line: 74
				-- upvalues: n5 (ref), timestamp (copy), t2 (copy), n4 (ref), v21 (copy), n2 (copy), v20 (copy), u7 (ref), t1 (copy), connection (ref), ColorCorrectionEffect (ref), u8 (ref)
				n5 = tick() - timestamp
				table.insert(t2, dt)
				n4 += dt

				if #t2 > v21 then
					local v30 = table.remove(t2, 1)

					if v30 ~= nil then
						n4 -= v30
					end
				end

				local v31 = n4 / #t2

				if n2 and n5 > n2 or #t2 >= v21 and math.floor(v31 * 100) <= math.floor(v20 * 100) then
					u7 = true

					for _, v33 in t1 do
						v33(u7)
					end

					if connection then
						connection:Disconnect()
					end

					if ColorCorrectionEffect then
						ColorCorrectionEffect:Destroy()
						ColorCorrectionEffect = nil
					end

					u7 = true
					u8 = false
				end
			end)
			u8 = true
		end
	end,
	addStatusChangeListener = function(p1) -- line: 106
		-- upvalues: t1 (copy)
		table.insert(t1, p1)

		return p1
	end,
	removeStatusChangeListener = function(p2) -- line: 111
		-- upvalues: t1 (copy)
		for v27, v28 in t1 do
			if v28 == p2 then
				table.remove(t1, v27)
			end
		end
	end,
	isFPSAtTarget = function() -- line: 119
		-- upvalues: u7 (ref)
		return u7
	end,
	__setTestMode = function() -- line: 123
		-- upvalues: u6 (ref)
		u6 = true
	end
}
