local RunService = game:GetService("RunService")

local HttpService = game:GetService("HttpService")

local roRum = require("@luauforge/bundled/igt").RoRum

local isStudio = RunService:IsStudio()

local function generateGuid()
	return HttpService:GenerateGUID(false):lower()
end

local v5 = roRum.new({
	generateId = generateGuid,
	generateTraceId = function()
		return HttpService:GenerateGUID(false):gsub("-", ""):lower()
	end,
	generateSpanId = function()
		return HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 16):lower()
	end
})

if isStudio then
	print("[LuaAppRoRum] Initialized successfully")
end

return v5
