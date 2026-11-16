local function IsRunningInStudio()
	local RunService = game:GetService("RunService")
	return RunService:IsStudio()
end
local RunService = game:GetService("RunService")
local isStudio = RunService:IsStudio()

local function PCALL(callback, p2, p3)
	local v5 = isStudio

	if p3 ~= nil then
		v5 = p3
	end

	local success, result = pcall(function()
		return callback()
	end)

	if success then
		return result
	end

	if v5 then
		assert(success, result)
		return p2
	end

	local v6 = "safeCall failed"
	pcall(function()
		v6 = tostring(result)
	end)
	warn(v6)

	return p2
end

return PCALL
